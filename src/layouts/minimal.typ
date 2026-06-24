// Minimal page layout.

#import "utils.typ": shared-assets

#let minimal(page, ctx: none, body) = [
  #shared-assets(ctx)
  #html.elem("div", attrs: (class: "jtd-minimal", id: "top"))[
    #html.elem("main", attrs: (class: "jtd-page jtd-page-minimal", id: "main-content"))[
      #heading(level: 1)[#page.title]
      #body
    ]
  ]
]
