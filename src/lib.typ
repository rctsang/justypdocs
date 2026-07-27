// Public entrypoint for justypdocs.
//
// Exported API:
// - `site(config: ..., nav: ...)`
// - `page(id: ..., title: ..., layout: ...)`
// - `themes.light` / `themes.dark`
// - Elembic components: `callout`, `button`, `label`, `card`
// - Page asset declarations: `asset`, `stylesheet`, `script`
// - `types` module with public Elembic-backed types.
// - `nav` module with traversal and lookup helpers.

#import "site.typ": site
#import "page.typ": page
#import "theme.typ" as themes
#import "components.typ": callout, button, label, card
#import "page-assets.typ": asset, stylesheet, script
#import "types.typ" as types
#import "nav.typ" as nav
