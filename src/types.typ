// Elembic public and internal e.types for justypdocs.
//
// Nav title and page title are intentionally separate:
// - Nav node `title` is a navigation label.
// - `jtd.page(title: ...)` is the page's own title.

#import "@preview/elembic:1.1.1" as e

#let prefix = "@local/justypdocs:0.0.1"

// Link rendered in the right side of layouts' main header.
// Unknown fields are forwarded as HTML attributes on the generated anchor.
#let header-link = e.types.declare(
  "justypdocs-header-link",
  prefix: prefix,
  doc: "A global main-header link.",
  fields: (
    e.field("title", e.types.option(str), default: none,
      doc: "Visible link label when body is not provided."),
    e.field("href", str, required: true, named: true,
      doc: "Link target URL."),
    e.field("body", e.types.option(content), default: none,
      doc: "Custom link body content, such as inline SVG."),
    e.field("aria-label", e.types.option(str), default: none,
      doc: "Accessible label for icon-only links."),
  ),
  allow-unknown-fields: true,
  casts: ((from: dictionary),),
)

// Site configuration passed to `jtd.site(config: ...)`.
// `base-url` is applied to emitted asset and page links, so generated HTML does
// not depend on relative paths from nested output directories.
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
    e.field("header-links", e.types.array(header-link), default: (),
      doc: "Global links rendered in the main header."),
    e.field("theme", e.types.any, default: (:),
      doc: "Theme token dictionary."),
  ),
  casts: ((from: dictionary),),
)

// Page nodes represent emitted bundle documents.
// Page nodes may eventually gain `children`, allowing pages to act as nav
// parents. For the initial implementation, page routing stays explicit with a
// required `path`, and only section nodes contain children.
// Required fields: globally unique stable `id`, navigation-only `title`, page
// `body`, and output `path`. The body should usually be `include "page.typ"`,
// written in the user's site file so paths resolve from the user's project.
#let nav-page = e.types.declare(
  "justypdocs-nav-page",
  prefix: prefix,
  doc: "A navigation page node with bundle body content and output path.",
  fields: (
    e.field("id", str, required: true, named: true,
      doc: "Globally unique stable nav node id."),
    e.field("title", str, required: true, named: true,
      doc: "Navigation label, not the page title."),
    e.field("body", content, required: true, named: true,
      doc: "Page content to emit, usually from an include in the site file."),
    e.field("path", str, required: true, named: true,
      doc: "Output path in the generated site."),
  ),
  casts: ((from: dictionary),),
)

// Section nodes group other nav nodes. Required fields: globally unique stable
// `id`, navigation-only `title`, and recursive `children`.
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

// Loose nav-node type for individual node casts. The public `nav` type below
// owns recursive validation and duplicate-id checks.
#let nav-node = e.types.union(nav-page, nav-section)

// Recursively cast raw user nav data into normalized Elembic nav node values.
#let cast-nav-nodes(nodes, seen: ()) = {
  assert(type(nodes) == array, message: "justypdocs: nav must be an array of nodes")

  let normalized = ()
  for raw in nodes {
    // Shape determines whether it is a section or page: section nodes have
    // `children`; page nodes have `src` and `path`.
    let node-type = if type(raw) == dictionary and "children" in raw {
      nav-section
    } else {
      nav-page
    }

    let (ok, node) = e.types.cast(raw, node-type)
    assert(ok, message: "justypdocs: invalid nav node: " + repr(node))

    assert(
      node.id not in seen,
      message: "justypdocs: duplicate nav node id " + repr(node.id),
    )
    seen.push(node.id)

    if "children" in node {
      let (children, next-seen) = cast-nav-nodes(node.children, seen: seen)
      node.children = children
      seen = next-seen
    }

    normalized.push(node)
  }

  (normalized, seen)
}

// Recursive navigation tree. This is the authoritative public nav type.
// Duplicate ids fail during casting so page lookup, active nav, and breadcrumb
// generation can all use a single stable id namespace.
#let nav = e.types.declare(
  "justypdocs-nav",
  prefix: prefix,
  doc: "Recursive justypdocs navigation tree.",
  fields: (
    e.field("nodes", array, required: true, named: true,
      doc: "Normalized recursive nav nodes."),
  ),
  casts: (
    (
      from: array,
      with: nav => nodes => {
        let (nodes, _) = cast-nav-nodes(nodes)
        nav(nodes: nodes)
      },
    ),
  ),
)

// Metadata declared by each page with `jtd.page(...)`.
// This mirrors the public page fields so later post-processing can read emitted
// page title, tags, categories, and descriptions from generated HTML.
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
