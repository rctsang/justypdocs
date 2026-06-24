// Layout implementations.
//
// These are intentionally minimal shells for now. The full Just-the-Docs-like
// default layout and richer minimal layout are expanded in later layout tasks.

#let default(page, ctx: none, body) = [
  #heading(level: 1)[#page.title]
  #body
]

#let minimal(page, ctx: none, body) = [
  #heading(level: 1)[#page.title]
  #body
]

#let render(page, ctx: none, body) = {
  if page.layout == "default" {
    default(page, ctx: ctx, body)
  } else if page.layout == "minimal" {
    minimal(page, ctx: ctx, body)
  } else {
    assert(false, message: "justypdocs.page: unknown layout " + repr(page.layout))
  }
}
