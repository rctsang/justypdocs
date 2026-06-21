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
- [x] Define config type/fields.
- [x] Define nav node types: page node and section node.
- [x] Define page metadata type/fields.
- [x] Make every nav node `id` required and globally unique.
- [x] Make nav `title` a navigation label only.
- [x] Make `jtd.page(id: ..., title: ...)` required, with page title independent from nav `title`.
- [x] Add source comments documenting each public API.

## 3. Implement Elembic Nav/Node Types

- [ ] Define a page-node type with `id`, `title`, `src`, and `path`.
- [ ] Define a section-node type with `id`, `title`, and `children`.
- [ ] Plan for page nodes to support `children` later, while keeping it out of scope unless needed.
- [ ] Define a recursive nav type if practical; otherwise validate recursive children manually.
- [ ] Add constructors/helpers if useful: `nav-page(...)`, `nav-section(...)`.
- [ ] Support raw dictionary nav nodes if that keeps authoring ergonomic.
- [ ] Validate malformed nodes with useful errors.
- [ ] Validate duplicate nav node ids with useful errors.
- [ ] Keep nav node titles scoped to navigation UI only.

## 4. Implement Nav Model Helpers

- [ ] Detect/cast page nodes.
- [ ] Detect/cast section nodes.
- [ ] Recursively traverse nav.
- [ ] Implement `pages-from-nav(nav)`.
- [ ] Implement `entry-by-id(id, nav)`.
- [ ] Have `entry-by-id(id, nav)` return `(entry: node, trail: ids)`.
- [ ] Ensure `trail` is an array of nav node ids only.
- [ ] Implement internal `emit-documents(nav)` using `pages-from-nav(nav)`.
- [ ] Defer path-based helpers.
- [ ] Defer dedicated breadcrumb/children helpers; breadcrumbs should resolve ids through `entry-by-id`.
- [ ] Use dynamic `include page.src`, since dynamic include/import works.

## 5. Implement `jtd.site(...)`

- [ ] Accept `config` and `nav`.
- [ ] Cast/validate config and nav with Elembic types where possible.
- [ ] Validate that every nav page node has `id`, `title`, `src`, and `path`.
- [ ] Validate that every nav section node has `id`, `title`, and `children`.
- [ ] Validate that all nav node ids are unique.
- [ ] Expose config/nav via metadata or another queryable mechanism.
- [ ] Emit shared CSS assets.
- [ ] Emit shared JS assets.
- [ ] Emit generated theme CSS variables.
- [ ] Recursively emit one `document(page.path)[#include page.src]` per nav page node.
- [ ] Emit/query metadata associating each generated document with `page.id` if useful.
- [ ] Do not use nav `title` as the page title.

## 6. Implement Page Lookup/Context

- [ ] Let `jtd.page(...)` retrieve site config/nav.
- [ ] Let `jtd.page(...)` identify the current nav page by `id`.
- [ ] Validate that `jtd.page(id: ...)` exists in the registered nav metadata when building a site.
- [ ] Use `entry-by-id(id, nav).trail` for active nav and breadcrumb context.
- [ ] Use `jtd.page(path: ...)` only as an optional fallback/debug aid if needed.
- [ ] Document standalone page compilation behavior in source comments.

## 7. Implement `jtd.page(...)`

- [ ] Implement as a show-rule/template function.
- [ ] Require `id`.
- [ ] Require `title`.
- [ ] Accept `layout`, `description`, optional `path`, `tags`, `categories`, and future-oriented metadata fields.
- [ ] Emit/queryable frontmatter-like metadata for future features.
- [ ] Use page `title` for page-level layout rendering and metadata where supported.
- [ ] Do not infer page title from nav.
- [ ] Retrieve nav title only for navigation UI.
- [ ] Look up nav metadata by page `id`.
- [ ] Dispatch to selected layout.
- [ ] Support initial layouts: `default` and `minimal`.

## 8. Implement Core Elembic Components

- [ ] Add `callout`.
- [ ] Add `button`.
- [ ] Add `label`.
- [ ] Add `card`.
- [ ] Add typed fields for each component.
- [ ] Add default styling hooks/classes.
- [ ] Support customization with Elembic set/show rules.
- [ ] Consider `page-header`, `breadcrumb`, `children-nav`, and `aux-nav` only if useful for the layout implementation.
- [ ] Comment source with usage docs for each public component.

## 9. Implement Theme System

- [ ] Define `themes.light`.
- [ ] Define `themes.dark`.
- [ ] Support `.with(...)` customization.
- [ ] Generate `assets/css/theme.css` from `config.theme`.
- [ ] Ensure authored CSS consumes CSS custom properties.
- [ ] Keep bulk CSS in real `.css` files.
- [ ] Comment source with theme token docs.

## 10. Implement Default Layout

- [ ] Render skip link.
- [ ] Render sidebar.
- [ ] Render site title.
- [ ] Render recursive nav tree.
- [ ] Use nav titles in sidebar.
- [ ] Render active nav state.
- [ ] Render mobile header.
- [ ] Render breadcrumbs using nav titles.
- [ ] Render main content wrapper.
- [ ] Render page title from `jtd.page(title: ...)` where layout requires it.
- [ ] Render footer.

## 11. Implement Minimal Layout

- [ ] Render a simpler page shell.
- [ ] Include shared CSS/JS.
- [ ] Render page title from `jtd.page(title: ...)` where appropriate.
- [ ] Render content without full sidebar.
- [ ] Preserve theme typography and colors.

## 12. Port Core CSS

- [ ] Add base typography and colors.
- [ ] Add layout/sidebar styles.
- [ ] Add navigation styles.
- [ ] Add breadcrumb styles.
- [ ] Add main content styles.
- [ ] Add code block styles.
- [ ] Add table styles.
- [ ] Add blockquote styles.
- [ ] Add button, label, callout, and card styles.
- [ ] Add responsive behavior.
- [ ] Add basic print styles.

## 13. Add JavaScript

- [ ] Implement mobile nav toggle.
- [ ] Implement nested nav expand/collapse.
- [ ] Optionally make scrollable code blocks focusable.
- [ ] Optionally add copy-code behavior.
- [ ] Keep search out of scope.

## 14. Build Examples

- [ ] Create a basic light-theme site.
- [ ] Create a dark-theme or custom-theme example.
- [ ] Include nested nav pages.
- [ ] Include default and minimal layout pages.
- [ ] Demonstrate differing nav title and page title.
- [ ] Demonstrate matching nav page node id and `jtd.page(id: ...)`.
- [ ] Demonstrate page tags/categories/frontmatter metadata.
- [ ] Demonstrate callouts, buttons, labels, cards, code, and tables.

## 15. Verify Bundle Output

- [ ] Run `typst compile --features bundle,html --format bundle examples/basic/site.typ dist`.
- [ ] Verify all HTML pages are emitted from nav.
- [ ] Verify users do not manually declare page `document(...)` elements.
- [ ] Verify duplicate nav node ids fail with a useful error.
- [ ] Verify missing `jtd.page(id: ...)` fails with a useful error.
- [ ] Verify unknown `jtd.page(id: ...)` fails with a useful error when building a site.
- [ ] Verify CSS/JS assets are emitted.
- [ ] Verify nested page asset paths work.
- [ ] Verify nav titles appear in navigation.
- [ ] Verify page titles appear in page layouts/metadata.
- [ ] Verify nav title and page title can differ.
- [ ] Verify page lookup by id drives nav-derived features.
- [ ] Verify page metadata is emitted/queryable for future features.
- [ ] Verify active nav state and breadcrumbs.
- [ ] Verify mobile menu behavior.
- [ ] Verify theme overrides.

## 16. Source Documentation

- [ ] Add source comments for `site.typ` API.
- [ ] Add source comments for `page.typ` API.
- [ ] Add source comments for config schema.
- [ ] Add source comments for nav section/page node schemas.
- [ ] Document that every nav node `id` is required, globally unique, and intended to be stable.
- [ ] Explicitly comment that nav `title` and page `title` are separate.
- [ ] Add source comments for layouts.
- [ ] Add source comments for theme customization.
- [ ] Add source comments for components.
- [ ] Add source comments for build/watch commands where examples live.
- [ ] Keep external docs minimal until API stabilizes.

## 17. Deferred Search

- [ ] Design future `justypdocs-index dist` postprocessor.
- [ ] Parse emitted HTML.
- [ ] Extract page titles from generated page HTML, not nav titles.
- [ ] Read page metadata such as tags/categories when available.
- [ ] Emit `assets/js/search-data.json`.
- [ ] Add optional search UI/JS later.
