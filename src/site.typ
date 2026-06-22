// Site-level bundle generation.
//
// Public API: `#jtd.site(config: ..., nav: ...)`.
// `site` is an Elembic element. Its display function will eventually emit
// assets and all documents described by nav.

#import "@preview/elembic:1.1.1" as e
#import "types.typ" as public-types

#let site = e.element.declare(
  "site",
  prefix: public-types.prefix,
  doc: "Defines and emits a justypdocs site bundle.",
  fields: (
    e.field("config", public-types.config, doc: "Site-wide configuration.", required: true, named: true),
    e.field("nav", public-types.nav, doc: "Navigation tree and page emission source.", required: true, named: true),
  ),
  display: it => {
    // TODO: Emit site/nav metadata, assets, and documents in later tasks.
    none
  },
)
