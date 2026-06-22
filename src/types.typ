// Elembic public and internal e.types for justypdocs.
//
// Nav title and page title are intentionally separate:
// - Nav node `title` is a navigation label.
// - `jtd.page(title: ...)` is the page's own title.

#import "@preview/elembic:1.1.1" as e

#let prefix = "@local/justypdocs:0.0.1"

// Site configuration passed to `jtd.site(config: ...)`.
#let config = e.types.declare(
  "justypdocs-config",
  prefix: prefix,
  doc: "Site-wide justypdocs configuration.",
  fields: (
    e.field("title", str, required: true, named: true,
      doc: "Site title."),
    e.field("description", e.types.option(str), default: none,
      doc: "Site description."),
    e.field("base-url", str, default: "/",
      doc: "Base URL used for generated links."),
    e.field("footer", e.types.option(content), default: none,
      doc: "Footer content."),
    e.field("theme", e.types.any, default: (:),
      doc: "Theme token dictionary."),
  ),
  casts: ((from: dictionary),),
)

// Page nodes represent emitted bundle documents.
#let nav-page = e.types.declare(
  "justypdocs-nav-page",
  prefix: prefix,
  doc: "A navigation page node with bundle source and output paths.",
  fields: (
    e.field("id", str, required: true, named: true,
      doc: "Globally unique stable nav node id."),
    e.field("title", str, required: true, named: true,
      doc: "Navigation label, not the page title."),
    e.field("src", str, required: true, named: true,
      doc: "Source Typst file to include."),
    e.field("path", str, required: true, named: true,
      doc: "Output path in the generated site."),
  ),
  casts: ((from: dictionary),),
)

// Section nodes group other nav nodes. Children are validated recursively later.
#let nav-section = e.types.declare(
  "justypdocs-nav-section",
  prefix: prefix,
  doc: "A navigation section node containing child nav nodes.",
  fields: (
    e.field("id", str, required: true, named: true,
      doc: "Globally unique stable nav node id."),
    e.field("title", str, required: true, named: true,
      doc: "Visible navigation section label."),
    e.field("children", array, required: true, named: true,
      doc: "Nested nav nodes."),
  ),
  casts: ((from: dictionary),),
)

// Loose nav-node type for public fields. Recursive validation happens in nav helpers.
#let nav-node = e.types.union(nav-page, nav-section)
#let nav = e.types.array(nav-node)

// Metadata declared by each page with `jtd.page(...)`.
#let page-metadata = e.types.declare(
  "justypdocs-page-metadata",
  prefix: prefix,
  doc: "Page-local metadata declared through jtd.page(...).",
  fields: (
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
  casts: ((from: dictionary),),
)
