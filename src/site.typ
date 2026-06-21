// Site-level bundle generation.
//
// Public API: `jtd.site(config: ..., nav: ...)`.
// This will eventually emit assets and all documents described by nav.

#import "@preview/elembic:1.1.1" as e
#import "types.typ" as public-types

#let site(config: none, nav: none) = {
  // Type casting gives early API-shape errors while implementation is pending.
  let (ok-config, config) = e.types.cast(config, public-types.config)
  assert(ok-config, message: "justypdocs.site: invalid config: " + repr(config))

  let (ok-nav, nav) = e.types.cast(nav, public-types.nav)
  assert(ok-nav, message: "justypdocs.site: invalid nav: " + repr(nav))

  // TODO: Emit metadata, assets, and documents in later tasks.
  none
}
