// Layout dispatcher.

#import "layouts/default.typ": default
#import "layouts/minimal.typ": minimal

#let render(page, ctx: none, body) = {
  if page.layout == "minimal" {
    minimal(page, ctx: ctx, body)
  } else {
    default(page, ctx: ctx, body)
  }
}
