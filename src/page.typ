// Page-level wrapper element.
//
// Public API: `#show: jtd.page.with(id: ..., title: ..., layout: "default")`.
// Page title is independent from the matching nav node's title.

#import "@preview/elembic:1.1.1" as e
#import "types.typ"

#let page = e.element.declare(
  "page",
  prefix: types.prefix,
  doc: "Wraps page content with justypdocs metadata and layout rendering.",
  fields: (
    e.field("body", content, required: true,
      doc: "Page body content."),
    e.field("id", str, required: true, named: true,
      doc: "Id of the matching nav page node."),
    e.field("title", str, required: true, named: true,
      doc: "Page title used by layouts and metadata."),
    e.field("layout", str, default: "default",
      doc: "Layout name."),
    e.field("description", e.types.option(str), default: none,
      doc: "Page description."),
    e.field("path", e.types.option(str), default: none,
      doc: "Optional debug/fallback output path."),
    e.field("tags", e.types.array(str), default: (),
      doc: "Future-facing page tags."),
    e.field("categories", e.types.array(str), default: (),
      doc: "Future-facing page categories."),
  ),
  display: it => [
    #metadata((
      kind: "justypdocs-page",
      id: it.id,
      title: it.title,
      layout: it.layout,
      description: it.description,
      path: it.path,
      tags: it.tags,
      categories: it.categories,
    ))

    // TODO: Dispatch layouts in task 7. For now, pass content through.
    #it.body
  ],
)
