// Site-level bundle generation.
//
// Public API: `#jtd.site(config: ..., nav: ...)`.
// `site` is an Elembic element. Its display function will eventually emit
// assets and all documents described by nav.

#import "@preview/elembic:1.1.1" as e
#import "types.typ"

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
  display: it => {
    // TODO: Emit site/nav metadata, assets, and documents in later tasks.
    none
  },
)
