// Shared layout helpers.

#import "../assets.typ"
#import "../nav.typ": entry-by-id

#let classes(..items) = {
  items.pos()
    .filter(item => item != none and item != "")
    .join(" ")
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

#let shared-assets(ctx) = [
  #for item in assets.manifest(asset-config(ctx)) {
    if item.path.ends-with(".css") {
      html.elem("link", attrs: (rel: "stylesheet", href: rooted-url(ctx, item.path)))
    } else if item.path.ends-with(".js") {
      html.elem("script", attrs: (src: rooted-url(ctx, item.path)))[]
    }
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

#let render-header-links(ctx) = {
  if ctx == none or ctx.config.header-links.len() == 0 {
    return none
  }

  html.elem("nav", attrs: (class: "header-links", "aria-label": "Auxiliary"))[
    #html.elem("ul", attrs: (class: "header-links-list"))[
      #for link in ctx.config.header-links {
        html.elem("li", attrs: (class: "header-links-item"))[
          #html.elem("a", attrs: (class: "header-link", href: rooted-url(ctx, link.href)))[#link.title]
        ]
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
