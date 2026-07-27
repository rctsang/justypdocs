// Shared layout helpers.

#import "../assets.typ"
#import "../nav.typ": entry-by-id

#let classes(..items) = {
  items.pos()
    .filter(item => item != none and item != "")
    .join(" ")
}

#let html-attrs(fields, known, base-class: none) = {
  let attrs = (:)
  for (key, value) in fields {
    if key not in known and key != "with" and not key.starts-with("__") and value != none {
      attrs.insert(key, value)
    }
  }

  let user-class = attrs.at("class", default: none)
  if base-class != none or user-class != none {
    attrs.class = classes(base-class, user-class)
  }

  attrs
}

#let base-url(ctx) = if ctx != none {
  ctx.config.base-url
} else { "" }

#let rooted-url(ctx, path) = {
  if path.starts-with("http://") or path.starts-with("https://") or path.starts-with("mailto:") or path.starts-with("#") {
    return path
  }

  let base = base-url(ctx)
  if base == "" {
    return path
  }

  let base = if base.ends-with("/") { base } else { base + "/" }
  let path = if path.starts-with("/") { path.slice(1) } else { path }
  base + path
}

#let asset-config(ctx) = if ctx != none {
  ctx.config
} else {
  (theme: (:))
}

#let page-assets(page, kind) = {
  if page == none {
    return ()
  }

  query(<jtd-page-asset>)
    .map(item => item.value)
    .filter(item => item.at("page-id", default: none) == page.id and item.at("asset-kind", default: none) == kind)
}

#let shared-head(ctx, page: none) = [
  #html.elem("meta", attrs: (charset: "utf-8"))[]
  #html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1"))[]
  #for item in assets.manifest(asset-config(ctx)) {
    if item.path.ends-with(".css") {
      html.elem("link", attrs: (rel: "stylesheet", href: rooted-url(ctx, item.path)))
    }
  }
  #for item in page-assets(page, "stylesheet") {
    html.elem("link", attrs: (rel: "stylesheet", href: item.url))
  }
]

#let shared-scripts(ctx, page: none) = [
  #for item in assets.manifest(asset-config(ctx)) {
    if item.path.ends-with(".js") {
      html.elem("script", attrs: (src: rooted-url(ctx, item.path)))[]
    }
  }
  #for item in page-assets(page, "script") {
    html.elem("script", attrs: (src: item.url))[]
  }
]

#let page-href(ctx, path) = rooted-url(ctx, path)

#let icon(ctx, name) = html.elem(
  "svg",
  attrs: (
    class: "jtd-icon jtd-icon-" + name,
    "aria-hidden": "true",
  ),
)[
  #html.elem("use", attrs: (href: rooted-url(ctx, "assets/icons/symbols.svg#" + name)))[]
]

#let render-breadcrumbs(ctx) = {
  if ctx == none or ctx.trail.len() <= 1 {
    return none
  }
  html.elem(
    "nav", attrs: (class: "breadcrumb-nav", "aria-label": "Breadcrumb"),
  )[
    #html.elem("ol", attrs: (class: "breadcrumb-nav-list"))[
      #html.elem("li", attrs: (class: "breadcrumb-nav-list-item breadcrumb-nav-root"))[
        #html.elem("a", attrs: (href: rooted-url(ctx, "")))[Home]
      ]
      #for id in ctx.trail {
        let entry = entry-by-id(id, ctx.nav).entry
        html.elem("li", attrs: (class: "breadcrumb-nav-list-item"))[
          #if "path" in entry {
            html.elem("a", attrs: (href: page-href(ctx, entry.path)))[#entry.title]
          } else {
            html.elem("span")[#entry.title]
          }
        ]
      }
    ]
  ]
}

#let render-header-links(ctx, trailing: none) = {
  let links = if ctx == none { () } else { ctx.config.header-links }
  if links.len() == 0 and trailing == none {
    return none
  }

  html.elem("nav", attrs: (class: "header-links", "aria-label": "Auxiliary"))[
    #html.elem("ul", attrs: (class: "header-links-list"))[
      #for link in links {
        html.elem("li", attrs: (class: "header-links-item"))[
          #let attrs = html-attrs(
            link,
            ("title", "href", "body", "aria-label"),
            base-class: "header-link",
          )
          #attrs.insert("href", rooted-url(ctx, link.href))
          #if link.at("aria-label") != none { attrs.insert("aria-label", link.at("aria-label")) }
          #html.elem("a", attrs: attrs)[
            #if link.body != none {
              link.body
            } else {
              link.title
            }
          ]
        ]
      }
      #if trailing != none {
        html.elem("li", attrs: (class: "header-links-item header-links-control"))[#trailing]
      }
    ]
  ]
}

#let site-title(ctx) = if ctx != none {
  ctx.config.title
} else { "" }

#let site-footer(ctx) = if ctx != none and ctx.config.footer != none {
  ctx.config.footer
} else { none }
