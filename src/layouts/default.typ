// Default documentation layout.
// Renders the Just-the-Docs-style shell: fixed sidebar, recursive
// navigation, site footer, mobile menu button, breadcrumbs, page title, and the
// page body. Navigation labels come from nav nodes; page titles come from
// `jtd.page.with(title: ...)`.

#import "utils.typ": classes, icon, page-href, render-breadcrumbs, render-header-links, rooted-url, shared-head, shared-scripts, site-footer, site-title

#let nav-link(node, ctx, active: false) = html.elem(
  "a",
  attrs: (
    class: classes("jtd-nav-link", if active { "active" }),
    href: if "path" in node { page-href(ctx, node.path) } else { "#" },
  ),
)[#node.title]

#let render-nav-node(node, trail, ctx) = {
  let active = node.id in trail
  let item-class = classes("jtd-nav-item", if active { "active" })
  let list-id = "jtd-nav-children-" + node.id

  html.elem("li", attrs: (class: item-class, "data-nav-id": node.id))[
    #if "children" in node {
      html.elem("div", attrs: (class: "jtd-nav-section"))[
        #html.elem("button", attrs: (
          class: "jtd-nav-section-toggle",
          type: "button",
          "aria-expanded": "true",
          "aria-controls": list-id,
        ))[
          #html.elem("span", attrs: (class: "jtd-nav-section-title"))[#node.title]
          #icon(ctx, "chevron-right")
        ]
      ]
      html.elem("ul", attrs: (class: "jtd-nav-list", id: list-id))[
        #for child in node.children { render-nav-node(child, trail, ctx) }
      ]
    } else {
      nav-link(node, ctx, active: active)
    }
  ]
}

#let render-nav(nav, trail, ctx) = html.elem(
  "nav",
  attrs: (class: "jtd-nav", "aria-label": "Main"),
)[
  #html.elem("ul", attrs: (class: "jtd-nav-list"))[
    #for node in nav.nodes { render-nav-node(node, trail, ctx) }
  ]
]

#let default(page, ctx: none, body) = html.elem("html", attrs: (lang: "en"))[
  #html.elem("head")[#shared-head(ctx, page: page)]
  #html.elem("body")[
    #html.elem("header", attrs: (class: "side-bar"))[
      #html.elem("div", attrs: (class: "site-header"))[
        #html.elem("a", attrs: (class: "site-title", href: rooted-url(ctx, "")))[#site-title(ctx)]
        #if ctx != none {
          html.elem("button", attrs: (
            class: "site-button",
            id: "menu-button",
            "aria-label": "Menu",
            "aria-expanded": "false",
          ))[
            #icon(ctx, "menu")
          ]
        }
      ]
      #if ctx != none { render-nav(ctx.nav, ctx.trail, ctx) }
      #render-header-links(ctx)
      #let footer = site-footer(ctx)
      #if footer != none {
        html.elem("div", attrs: (class: "site-footer"))[#footer]
      }
    ]
    #html.elem("div", attrs: (class: "main", id: "top"))[
      #html.elem("div", attrs: (class: "main-header main-header-default", id: "main-header"))[
        #render-header-links(ctx)
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
    #shared-scripts(ctx, page: page)
  ]
]
