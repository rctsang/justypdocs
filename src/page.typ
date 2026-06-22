// Page-level wrapper element.
//
// Public API: `#show: jtd.page.with(id: ..., title: ..., layout: "default")`.
// Page title is independent from the matching nav node's title.

#import "@preview/elembic:1.1.1" as e
#import "types.typ" as public-types

#let page = e.element.declare(
  "page",
  prefix: public-types.prefix,
  doc: "Wraps page content with justypdocs metadata and layout rendering.",
  fields: (
    e.field("body", content, doc: "Page body content.", required: true),
    e.field("id", str, doc: "Id of the matching nav page node.", required: true, named: true),
    e.field("title", str, doc: "Page title used by layouts and metadata.", required: true, named: true),
    e.field("layout", str, doc: "Layout name.", default: "default"),
    e.field("description", e.types.option(str), doc: "Page description.", default: none),
    e.field("path", e.types.option(str), doc: "Optional debug/fallback output path.", default: none),
    e.field("tags", e.types.array(str), doc: "Future-facing page tags.", default: ()),
    e.field("categories", e.types.array(str), doc: "Future-facing page categories.", default: ()),
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
