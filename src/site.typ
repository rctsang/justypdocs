// Site-level bundle generation.
//
// Public API: `#jtd.site(config: ..., nav: ...)`.
// `site` is an Elembic element. Its display function will eventually emit
// assets and all documents described by nav.

#import "@preview/elembic:1.1.1" as e
#import "types.typ"
#import "nav.typ": pages-from-nav
#import "assets.typ": manifest

#let emit-assets(config) = {
  for item in manifest(config) { asset(item.path, item.data) }
}

// Internal bundle document emission helper used by `jtd.site`.
#let emit-documents(nav) = {
  for page in pages-from-nav(nav) {
    document(page.path)[
      #metadata((kind: "jtd-current-page", id: page.id))
      #include page.src
    ]
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
    #emit-documents(it.nav)
  ],
)
