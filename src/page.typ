// Page-level show rule/template.
//
// Public API: `#show: jtd.page(id: ..., title: ..., layout: "default")`.
// Page title is independent from the matching nav node's title.

#import "@preview/elembic:1.1.1" as e
#import "types.typ" as public-types

#let page(
  id: none,
  title: none,
  layout: "default",
  description: none,
  path: none,
  tags: (),
  categories: (),
) = body => {
  let data = (
    id: id,
    title: title,
    layout: layout,
    description: description,
    path: path,
    tags: tags,
    categories: categories,
  )
  let (ok-page, page) = e.types.cast(data, public-types.page-metadata)
  assert(ok-page, message: "justypdocs.page: invalid page metadata: " + repr(page))

  // TODO: Emit/query metadata and dispatch layouts in later tasks.
  body
}
