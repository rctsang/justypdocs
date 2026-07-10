// Paged/PDF page layout.

#import "../paged.typ": current-theme

#let paged(page-data, ctx: none, body) = {
  let theme = current-theme()
  [
    #set page(margin: (x: 1in, y: 0.8in))
    #set text(fill: rgb(theme.at("body-text")), size: 10.5pt)
    #show heading: it => text(fill: rgb(theme.at("body-heading")))[#it]

    #heading(level: 1)[#page-data.title]
    #body
  ]
}
