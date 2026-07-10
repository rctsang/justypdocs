// Layout dispatcher.
// `default` renders the full documentation shell with sidebar navigation.
// `minimal` keeps shared assets, header, breadcrumbs, and content styling while
// omitting the sidebar for standalone or presentation-style pages.
// Paged/PDF output uses a native Typst layout without HTML site chrome.

#import "@preview/bullseye:0.1.0": target
#import "layouts/default.typ": default
#import "layouts/minimal.typ": minimal
#import "layouts/paged.typ": paged

#let render(page, ctx: none, body) = context {
  if target() != "html" {
    paged(page, ctx: ctx, body)
  } else if page.layout == "minimal" {
    minimal(page, ctx: ctx, body)
  } else {
    default(page, ctx: ctx, body)
  }
}
