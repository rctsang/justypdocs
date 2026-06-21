// Elembic public and internal types for justypdocs.
//
// Nav title and page title are intentionally separate:
// - Nav node `title` is a navigation label.
// - `jtd.page(title: ...)` is the page's own title.

#import "@preview/elembic:1.1.1" as e: field, types

#let prefix = "@local/justypdocs,v0"

// Site configuration passed to `jtd.site(config: ...)`.
#let config = types.declare(
  "justypdocs-config",
  prefix: prefix,
  doc: "Site-wide justypdocs configuration.",
  fields: (
    field("title", str, doc: "Site title.", required: true, named: true),
    field("description", types.option(str), doc: "Site description.", default: none),
    field("base-url", str, doc: "Base URL used for generated links.", default: "/"),
    field("footer", types.option(content), doc: "Footer content.", default: none),
    field("theme", types.any, doc: "Theme token dictionary.", default: (:)),
  ),
  casts: ((from: dictionary),),
)

// Page nodes represent emitted bundle documents.
#let nav-page = types.declare(
  "justypdocs-nav-page",
  prefix: prefix,
  doc: "A navigation page node with bundle source and output paths.",
  fields: (
    field("id", str, doc: "Globally unique stable nav node id.", required: true, named: true),
    field("title", str, doc: "Navigation label, not the page title.", required: true, named: true),
    field("src", str, doc: "Source Typst file to include.", required: true, named: true),
    field("path", str, doc: "Output path in the generated site.", required: true, named: true),
  ),
  casts: ((from: dictionary),),
)

// Section nodes group other nav nodes. Children are validated recursively later.
#let nav-section = types.declare(
  "justypdocs-nav-section",
  prefix: prefix,
  doc: "A navigation section node containing child nav nodes.",
  fields: (
    field("id", str, doc: "Globally unique stable nav node id.", required: true, named: true),
    field("title", str, doc: "Visible navigation section label.", required: true, named: true),
    field("children", array, doc: "Nested nav nodes.", required: true, named: true),
  ),
  casts: ((from: dictionary),),
)

// Loose nav-node type for public fields. Recursive validation happens in nav helpers.
#let nav-node = types.union(nav-page, nav-section)
#let nav = types.array(nav-node)

// Metadata declared by each page with `jtd.page(...)`.
#let page-metadata = types.declare(
  "justypdocs-page-metadata",
  prefix: prefix,
  doc: "Page-local metadata declared through jtd.page(...).",
  fields: (
    field("id", str, doc: "Id of the matching nav page node.", required: true, named: true),
    field("title", str, doc: "Page title used by layouts and metadata.", required: true, named: true),
    field("layout", str, doc: "Layout name.", default: "default"),
    field("description", types.option(str), doc: "Page description.", default: none),
    field("path", types.option(str), doc: "Optional debug/fallback output path.", default: none),
    field("tags", types.array(str), doc: "Future-facing page tags.", default: ()),
    field("categories", types.array(str), doc: "Future-facing page categories.", default: ()),
  ),
  casts: ((from: dictionary),),
)
