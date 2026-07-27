// Site-level bundle generation.
//
// Public API: `#jtd.site(config: ..., nav: ...)`.
// `site` is an Elembic element that owns static-site bundle generation.
// Users declare config/nav once, then `site` emits shared CSS/JS/theme assets
// plus one `document(page.path)` for every page node in the nav tree. Page
// bodies should usually be written as `body: include "page.typ"` in the user's
// site file, so include paths resolve from the user's project rather than this
// package. Page files should use `#show: jtd.page.with(id: ..., title:
// ...)`; users do not manually declare page `document(...)` elements.

#import "@preview/elembic:1.1.1" as e
#import "types.typ"
#import "nav.typ": pages-from-nav
#import "assets.typ": manifest

#let emit-assets(config) = {
  for item in manifest(config) { asset(item.path, item.data) }
}

// Internal bundle document emission helper used by `jtd.site`.
// Each emitted document renders the page body declared by the matching nav page
// node. The page element then resolves nav context by stable `id`.
#let emit-documents(nav, config) = {
  for page in pages-from-nav(nav) {
    document(page.path)[
      #metadata((kind: "jtd-current-page", id: page.id, path: page.path, config: config)) <jtd-current-page>
      #page.body
    ]
  }
}

#let emit-page-assets() = context {
  for item in query(<jtd-page-asset>) {
    let value = item.value
    asset(value.output-path, value.data)
  }
}

#let site = e.element.declare(
  "site",
  prefix: types.prefix,
  doc: "Defines and emits a justypdocs site bundle.",
  fields: (
    e.field("config", types.config, required: true, named: true,
      doc: "Site-wide configuration."),
    e.field("nav", types.nav, required: true, named: true,
      doc: "Navigation tree and page emission source."),
  ),
  display: it => [
    #metadata((
      kind: "justypdocs-site",
      config: it.config,
      nav: it.nav,
    )) <jtd-site>
    #emit-assets(it.config)
    #emit-documents(it.nav, it.config)
    #emit-page-assets()
  ],
)
