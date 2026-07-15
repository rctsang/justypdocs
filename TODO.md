# Justypdocs TODO

## 1. Create Package Skeleton

- [x] Add `typst.toml`.
- [x] Add `src/lib.typ`, `src/site.typ`, `src/page.typ`, `src/layouts.typ`, `src/nav.typ`, `src/theme.typ`, `src/components.typ`, `src/assets.typ`, and `src/types.typ`.
- [x] Add authored CSS files under `assets/css/`.
- [x] Add authored JS under `assets/js/site.js`.
- [x] Add `examples/basic/site.typ`.
- [x] Add example pages under `examples/basic/pages/`.

## 2. Define Public API With Elembic

- [x] Export `jtd.site(...)`, `jtd.page(...)`, `jtd.themes`, component constructors, and public types from `src/lib.typ`.
- [x] Use Elembic elements/types where practical for API objects and validation.
- [x] Define `jtd.site` as an Elembic element, not a plain function.
- [x] Define `jtd.page` as an Elembic element with a required body, usable as `#show: jtd.page.with(...)`.
- [x] Define config type/fields.
- [x] Define nav node types: page node and section node.
- [x] Define page metadata type/fields.
- [x] Make every nav node `id` required and globally unique.
- [x] Make nav `title` a navigation label only.
- [x] Make `jtd.page.with(id: ..., title: ...)` required, with page title independent from nav `title`.
- [x] Add source comments documenting each public API.

## 3. Implement Elembic Nav/Node Types

- [x] Define a page-node type with `id`, `title`, `src`, and `path`.
- [x] Define a section-node type with `id`, `title`, and `children`.
- [x] Plan for page nodes to support `children` later, while keeping it out of scope unless needed.
- [x] Define a recursive nav type if practical; otherwise validate recursive children manually.
- [x] Add constructors/helpers if useful: `nav-page(...)`, `nav-section(...)`.
- [x] Support raw dictionary nav nodes if that keeps authoring ergonomic.
- [x] Validate malformed nodes with useful errors.
- [x] Validate duplicate nav node ids with useful errors.
- [x] Keep nav node titles scoped to navigation UI only.

## 4. Implement Nav Model Helpers

- [x] Detect/cast page nodes.
- [x] Detect/cast section nodes.
- [x] Recursively traverse nav.
- [x] Implement `pages-from-nav(nav)`.
- [x] Implement `entry-by-id(id, nav)`.
- [x] Have `entry-by-id(id, nav)` return `(entry: node, trail: ids)`.
- [x] Ensure `trail` is an array of nav node ids only.
- [x] Implement internal `emit-documents(nav)` using `pages-from-nav(nav)`.
- [x] Defer path-based helpers.
- [x] Defer dedicated breadcrumb/children helpers; breadcrumbs should resolve ids through `entry-by-id`.
- [x] Use dynamic `include page.src`, since dynamic include/import works.

## 5. Implement `jtd.site(...)`

- [x] Accept `config` and `nav`.
- [x] Implement as an Elembic element display function.
- [x] Cast/validate config and nav with Elembic types where possible.
- [x] Validate that every nav page node has `id`, `title`, `src`, and `path`.
- [x] Validate that every nav section node has `id`, `title`, and `children`.
- [x] Validate that all nav node ids are unique.
- [x] Expose config/nav via metadata or another queryable mechanism.
- [x] Emit shared CSS assets.
- [x] Emit shared JS assets.
- [x] Emit generated theme CSS variables.
- [x] Recursively emit one `document(page.path)[#include page.src]` per nav page node.
- [x] Emit/query metadata associating each generated document with `page.id` if useful.
- [x] Do not use nav `title` as the page title.

## 6. Implement Page Lookup/Context

- [x] Let the `jtd.page` element retrieve site config/nav.
- [x] Let the `jtd.page` element identify the current nav page by `id`.
- [x] Validate that `jtd.page.with(id: ...)` exists in the registered nav metadata when building a site.
- [x] Use `entry-by-id(id, nav).trail` for active nav and breadcrumb context.
- [x] Use `jtd.page.with(path: ...)` only as an optional fallback/debug aid if needed.
- [x] Document standalone page compilation behavior in source comments.

## 7. Implement `jtd.page(...)`

- [x] Implement as an Elembic element with a required `body` field.
- [x] Support page usage via `#show: jtd.page.with(id: ..., title: ...)`.
- [x] Require `id`.
- [x] Require `title`.
- [x] Accept `layout`, `description`, optional `path`, `tags`, `categories`, and future-oriented metadata fields.
- [x] Emit/queryable frontmatter-like metadata from the element display function for future features.
- [x] Use page `title` for page-level layout rendering and metadata where supported.
- [x] Do not infer page title from nav.
- [x] Retrieve nav title only for navigation UI.
- [x] Look up nav metadata by page `id`.
- [x] Dispatch to selected layout.
- [x] Support initial layouts: `default` and `minimal`.

## 8. Implement Core Elembic Components

- [x] Add `callout`.
- [x] Add `button`.
- [x] Add `label`.
- [x] Add `card`.
- [x] Add typed fields for each component.
- [x] Add default styling hooks/classes.
- [x] Support customization with Elembic set/show rules.
- [x] Consider `page-header`, `breadcrumb`, `children-nav`, and `aux-nav` only if useful for the layout implementation.
- [x] Comment source with usage docs for each public component.

## 9. Implement Theme System

- [x] Define `themes.light`.
- [x] Define `themes.dark`.
- [x] Support `.with(...)` customization.
- [x] Generate `assets/css/theme.css` from `config.theme`.
- [x] Ensure authored CSS consumes CSS custom properties.
- [x] Keep bulk CSS in real `.css` files.
- [x] Comment source with theme token docs.

## 10. Implement Default Layout

- [x] Render skip link.
- [x] Render sidebar.
- [x] Render site title.
- [x] Render recursive nav tree.
- [x] Use nav titles in sidebar.
- [x] Render active nav state.
- [x] Render mobile header.
- [x] Render breadcrumbs using nav titles.
- [x] Render main content wrapper.
- [x] Render page title from `jtd.page.with(title: ...)` where layout requires it.
- [x] Render footer.

## 11. Implement Minimal Layout

- [x] Render a simpler page shell.
- [x] Include shared CSS/JS.
- [x] Render page title from `jtd.page.with(title: ...)` where appropriate.
- [x] Render content without full sidebar.
- [x] Preserve theme typography and colors.

## 12. Port Core CSS

- [x] Add base typography and colors.
- [x] Add layout/sidebar styles.
- [x] Add navigation styles.
- [x] Add breadcrumb styles.
- [x] Add main content styles.
- [x] Add code block styles.
- [x] Add table styles.
- [x] Add blockquote styles.
- [x] Add button, label, callout, and card styles.
- [x] Add responsive behavior.
- [x] Add basic print styles.

## 13. Add JavaScript

- [x] Implement mobile nav toggle.
- [x] Implement nested nav expand/collapse.
- [x] Optionally make scrollable code blocks focusable.
- [x] Optionally add copy-code behavior.
- [x] Keep search out of scope.

## 14. Build Examples

- [x] Create a basic light-theme site.
- [x] Create a dark-theme or custom-theme example.
- [x] Include nested nav pages.
- [x] Include default and minimal layout pages.
- [x] Demonstrate differing nav title and page title.
- [x] Demonstrate matching nav page node id and `jtd.page.with(id: ...)`.
- [x] Demonstrate page tags/categories/frontmatter metadata.
- [x] Demonstrate callouts, buttons, labels, cards, code, and tables.

## 15. Verify Bundle Output

- [x] Run `typst compile --features bundle,html --format bundle examples/basic/site.typ dist`.
- [x] Verify all HTML pages are emitted from nav.
- [x] Verify users do not manually declare page `document(...)` elements.
- [x] Verify duplicate nav node ids fail with a useful error.
- [x] Verify missing `jtd.page.with(id: ...)` fails with a useful error.
- [x] Verify unknown `jtd.page.with(id: ...)` fails with a useful error when building a site.
- [x] Verify CSS/JS assets are emitted.
- [x] Verify nested page asset paths work.
- [x] Verify nav titles appear in navigation.
- [x] Verify page titles appear in page layouts/metadata.
- [x] Verify nav title and page title can differ.
- [x] Verify page lookup by id drives nav-derived features.
- [x] Verify page metadata is emitted/queryable for future features.
- [x] Verify active nav state and breadcrumbs.
- [x] Verify mobile menu behavior.
- [x] Verify theme overrides.

## 16. Source Documentation

- [x] Add source comments for `site.typ` API.
- [x] Add source comments for `page.typ` API.
- [x] Add source comments for config schema.
- [x] Add source comments for nav section/page node schemas.
- [x] Document that every nav node `id` is required, globally unique, and intended to be stable.
- [x] Explicitly comment that nav `title` and page `title` are separate.
- [x] Add source comments for layouts.
- [x] Add source comments for theme customization.
- [x] Add source comments for components.
- [x] Add source comments for build/watch commands where examples live.
- [x] Keep external docs minimal until API stabilizes.

## 17. Polish Layout and Navigation UX

### 17.1 Vendor likely SVG symbols

  - [x] Add a small SVG symbol set for layout icons.
  - [x] Include likely initial symbols: `menu`, `chevron-right`, `copy`, and `check`.
  - [x] Keep `external-link` and `search` as likely future symbols, but do not wire search yet.
  - [x] Decide whether symbols are emitted as a standalone asset or inlined where needed.
  - [x] Replace text-only menu and generated chevrons with SVG icon usage where practical.

### 17.2 Add a breadcrumb root link

  - [x] Add a root breadcrumb link back to the homepage.
  - [x] Keep homepage breadcrumbs non-redundant.

### 17.3 Move the menu button into the main header

  - [x] Move the mobile menu button from the sidebar header to the main header.
  - [x] Hide or omit the menu button when nav/sidebar is unavailable, including the minimal layout.
  - [x] Keep the mobile menu button visible only below the desktop breakpoint.
  - [x] Update JavaScript to continue toggling the sidebar from the main-header menu button.

### 17.4 Align header and sidebar boundaries

  - [x] Align the site-header and main-header bottom borders.
  - [x] Ensure the sidebar site title and main header use the same header height on desktop.

### 17.5 Add Just-the-Docs-like hover gradients

  - [x] Add horizontal gradient hover styles for sidebar links.
  - [x] Add matching hover styles for the sidebar site title.
  - [x] Add matching hover styles for nav section toggles and the menu button.

### 17.6 Remove the main-header title

  - [x] Remove `.main-header-title` from the default layout.
  - [x] Keep the site title only in the navigation/sidebar header.
  - [x] Ensure the main header only contains controls such as the mobile menu button.

### 17.7 Verify layout polish

  - [x] Re-check default layout on desktop and mobile.
  - [x] Re-check minimal layout has no nav-only controls.
  - [x] Rebuild the basic bundle and representative standalone pages.

## 18. Custom Header Link Content and HTML Attribute Sinks

### 18.1 Support custom header link content

  - [x] Extend `types.header-link` to support custom `body` content.
  - [x] Keep simple text links working with `title` and `href`.
  - [x] Add optional `aria-label` support for icon-only header links.
  - [x] Render `body` inside the header `<a>` when provided, otherwise render `title`.
  - [x] Preserve existing global `config.header-links` behavior in default and minimal layouts.

### 18.2 Add header link attribute pass-through

  - [x] Enable unknown fields on the `header-link` type.
  - [x] Treat unknown fields as HTML attributes on the generated anchor.
  - [x] Append custom `class` values to the built-in `header-link` class.
  - [x] Preserve built-in `href` rooting for site-relative links.
  - [x] Preserve absolute URLs, `mailto:`, and fragment links unchanged.

### 18.3 Enable component argument sinks

  - [x] Enable unknown fields on `jtd.callout`.
  - [x] Enable unknown fields on `jtd.button`.
  - [x] Enable unknown fields on `jtd.label`.
  - [x] Enable unknown fields on `jtd.card`.
  - [x] Pass unknown named arguments through as HTML attributes for HTML output.
  - [x] Ignore HTML-only pass-through attributes for paged/PDF output.

### 18.4 Preserve generated component classes

  - [x] Keep built-in classes such as `jtd-callout`, `jtd-button`, `jtd-label`, and `jtd-card`.
  - [x] Keep variant classes such as `jtd-callout-warning` and `jtd-button-primary`.
  - [x] Append user-provided `class` values instead of replacing built-in classes.
  - [x] Add a shared helper for filtering known fields and merging HTML attrs.

### 18.5 Demonstrate custom HTML and attrs in examples

  - [x] Add an icon-style header link example in `examples/basic/site.typ`.
  - [x] Add a component example with custom `id`, `class`, and `data-*` attrs.
  - [x] Demonstrate an anchor/scroll-style use case such as `href: "#target"`.

### 18.6 Verify custom HTML and attrs

  - [x] Assert generated header links can contain custom HTML content.
  - [x] Assert header link accessibility attrs such as `aria-label` are emitted.
  - [x] Assert header link custom classes and attrs pass through.
  - [x] Assert component custom attributes pass through in HTML output.
  - [x] Assert built-in component classes remain present with custom classes.
  - [x] Assert PDF smoke tests still pass when components receive custom HTML attrs.

### 18.7 Document custom HTML and attr pass-through

  - [x] Update source comments for `header-link` config fields.
  - [x] Update source comments for component argument sinks.
  - [x] Update README with simple and custom-content header link examples.
  - [x] Update README with component HTML attribute pass-through examples.



# Future Work

## Paged/PDF Component Rendering

- [x] Add target-aware rendering for Elembic components.
  - Keep existing HTML `html.elem(...)` output for HTML export.
  - Render native Typst content for paged/PDF export.
  - Preserve existing public APIs for `callout`, `button`, `label`, and `card`.
- [x] Add a shared paged style module.
  - Create a module such as `src/paged.typ` for PDF component helpers.
  - Centralize Open Color and variant color resolution there.
  - Avoid duplicating component palette logic across components.
- [x] Mirror HTML component variants in paged output.
  - [x] Map callout kinds: `note`, `info`, `tip`, `warning`, `danger`, `important`.
  - [x] Map button variants: `default`, `outline`, `primary`, `purple`, `blue`, `green`, `red`, `yellow`.
  - [x] Map label variants: `default`, `blue`, `green`, `purple`, `red`, `yellow`.
- [x] Add paged theme resolution.
  - [x] Add helpers that resolve the same theme dictionaries/functions used for HTML themes.
  - [x] Use `themes.light` as the standalone PDF fallback when no site config is available.
  - Defer deeper config-aware standalone PDF theming unless a clean context mechanism is needed.
- [x] Implement native Typst component shapes.
  - [x] Render callouts as bordered blocks with transparent fill and colored title/accent.
  - [x] Render buttons as styled links.
  - [x] Render labels as inline pill badges.
  - [x] Render cards as bordered blocks with optional title.
- [x] Add a paged layout path for standalone PDF compilation.
  - [x] Add a layout such as `src/layouts/paged.typ`.
  - [x] Make `layouts.render(...)` choose paged output for PDF/paged targets.
  - [x] Render page title and body with consistent document margins and typography.
  - Avoid emitting HTML sidebar/header/nav chrome in PDF output.
- [x] Add smoke verification for PDF compilation.
  - [x] Compile `examples/basic/pages/guide/components.typ` to PDF.
  - [x] Compile a representative normal page to PDF.
  - [x] Assert generated PDF files exist and are non-empty.
- [x] Document paged behavior in source comments.
  - [x] Comment that components support both HTML and paged output.
  - [x] Add example compile commands for individual page PDF output.

## Deferred Search

- [ ] Design future `justypdocs-index dist` postprocessor.
- [ ] Parse emitted HTML.
- [ ] Extract page titles from generated page HTML, not nav titles.
- [ ] Read page metadata such as tags/categories when available.
- [ ] Emit `assets/js/search-data.json`.
- [ ] Add optional search UI/JS later.
