// Page-level wrapper element.
//
// Public API: `#show: jtd.page.with(id: ..., title: ..., layout: "default")`.
// Page title is independent from the matching nav node's title.

#import "@preview/elembic:1.1.1" as e
#import "types.typ"
#import "nav.typ": entry-by-id
#import "layouts.typ"

// Query site-level metadata emitted by `jtd.site`.
// When a page is compiled standalone, this metadata is unavailable; in that
// case page rendering falls back to page-local metadata and nav-derived
// features are skipped until the full site bundle is compiled.
#let site-context(id) = {
  let sites = query(<jtd-site>)
  if sites == () {
    return none
  }

  let site = sites.first().value
  let nav-context = entry-by-id(id, site.nav)

  (
    config: site.config,
    nav: site.nav,
    entry: nav-context.entry,
    trail: nav-context.trail,
  )
}

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
  display: it => context {
    let ctx = site-context(it.id)
    let resolved-path = if it.path != none {
      it.path
    } else if ctx != none and "path" in ctx.entry {
      ctx.entry.path
    } else {
      none
    }

    let page-data = (
      id: it.id,
      title: it.title,
      layout: it.layout,
      description: it.description,
      path: resolved-path,
      tags: it.tags,
      categories: it.categories,
    )

    [
      #metadata((
        kind: "justypdocs-page",
        ..page-data,
        site: ctx,
      )) <jtd-page>

      #layouts.render(page-data, ctx: ctx, it.body)
    ]
  },
)
