// Layout implementations.

#import "nav.typ": entry-by-id

#let classes(..items) = {
  items.pos()
    .filter(item => item != none and item != "")
    .join(" ")
}

#let nav-link(node, active: false) = html.elem(
  "a",
  attrs: (
    class: classes("jtd-nav-link", if active { "active" }),
    href: if "path" in node { node.path } else { "#" },
  ),
)[#node.title]

#let render-nav-node(node, trail) = {
  let active = node.id in trail
  let item-class = classes("jtd-nav-item", if active { "active" })

  html.elem("li", attrs: (class: item-class, "data-nav-id": node.id))[
    #if "children" in node {
      html.elem("div", attrs: (class: "jtd-nav-section"))[
        #node.title
      ]
      html.elem("ul", attrs: (class: "jtd-nav-list"))[
        #for child in node.children { render-nav-node(child, trail) }
      ]
    } else {
      nav-link(node, active: active)
    }
  ]
}

#let render-nav(nav, trail) = html.elem(
  "nav",
  attrs: (class: "jtd-nav", "aria-label": "Main"),
)[
  #html.elem("ul", attrs: (class: "jtd-nav-list"))[
    #for node in nav.nodes { render-nav-node(node, trail) }
  ]
]

#let render-breadcrumbs(ctx) = {
  if ctx == none or ctx.trail.len() <= 1 {
    return none
  }
  html.elem(
    "nav", attrs: (class: "breadcrumb-nav", aria-label: "Breadcrumb"),
  )[
    #html.elem("ol", attrs: (class: "breadcrumb-nav-list"))[
      #for id in ctx.trail {
        let entry = entry-by-id(id, ctx.nav).entry
        html.elem("li", attrs: (class: "breadcrumb-nav-list-item"))[
          #if "path" in entry {
            html.elem("a", attrs: (href: entry.path))[#entry.title]
          } else {
            html.elem("span")[#entry.title]
          }
        ]
      }
    ]
  ]
}

#let site-title(ctx) = if ctx != none {
  ctx.config.title
} else { "" }
}

#let site-footer(ctx) = if ctx != none and ctx.config.footer != none {
  ctx.config.footer
} else { none }

#let default(page, ctx: none, body) = [
  #html.elem("a", attrs: (
    class: "skip-to-main",
    href: "#main-content",
  ))[Skip to main content]
  #html.elem("header", attrs: (class: "side-bar"))[
    #html.elem("div", attrs: (class: "site-header"))[
      #html.elem("a", attrs: (class: "site-title", href: "/"))[#site-title(ctx)]
      #html.elem("button", attrs: (
        class: "site-button",
        id: "menu-button",
        "aria-label": "Menu",
        "aria-expanded": "false",
      ))[Menu]
    ]
    #if ctx != none { render-nav(ctx.nav, ctx.trail) }
    #let footer = site-footer(ctx)
    #if footer != none {
      html.elem("div", attrs: (class: "site-footer"))[#footer]
    }
  ]
  #html.elem("div", attrs: (class: "main", id: "top"))[
    #html.elem("div", attrs: (class: "main-header", id: "main-header"))[
      #html.elem("div", attrs: (class: "main-header-title"))[#site-title(ctx)]
    ]
    #html.elem("div", attrs: (class: "main-content-wrap"))[
      #render-breadcrumbs(ctx)
      #html.elem("div", attrs: (class: "main-content", id: "main-content"))[
        #html.elem("main", attrs: (class: "jtd-page"))[
          #heading(level: 1)[#page.title]
          #body
        ]
      ]
    ]
  ]
]

#let minimal(page, ctx: none, body) = [
  #heading(level: 1)[#page.title]
  #body
]

#let render(page, ctx: none, body) = {
  if page.layout == "minimal" {
    minimal(page, ctx: ctx, body)
  } else {
    default(page, ctx: ctx, body)
  }
}
