// Minimal page layout.
// Uses the same shared assets and content styling as the default layout, but it
// intentionally disables the sidebar/nav shell. Breadcrumbs still render when a
// page is built inside a site and has nav context.

#import "utils.typ": render-breadcrumbs, render-header-links, shared-assets

#let minimal(page, ctx: none, body) = [
  #shared-assets(ctx)
  #html.elem("div", attrs: (class: "main main-minimal", id: "top"))[
    #if ctx != none and ctx.config.header-links.len() > 0 {
      html.elem("div", attrs: (class: "main-header main-header-minimal", id: "main-header"))[
        #render-header-links(ctx)
      ]
    }
    #html.elem("div", attrs: (class: "main-content-wrap"))[
      #render-breadcrumbs(ctx)
      #html.elem("div", attrs: (class: "main-content", id: "main-content"))[
        #html.elem("main", attrs: (class: "jtd-page jtd-page-minimal"))[
          #heading(level: 1)[#page.title]
          #body
        ]
      ]
    ]
  ]
]
