// Layout dispatcher.
// `default` renders the full documentation shell with sidebar navigation.
// `minimal` keeps shared assets, header, breadcrumbs, and content styling while
// omitting the sidebar for standalone or presentation-style pages.

#import "layouts/default.typ": default
#import "layouts/minimal.typ": minimal

#let render(page, ctx: none, body) = {
  if page.layout == "minimal" {
    minimal(page, ctx: ctx, body)
  } else {
    default(page, ctx: ctx, body)
  }
}
