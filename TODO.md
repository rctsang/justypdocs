# Justypdocs TODO

## 1. Create Package Skeleton

- [ ] Add `typst.toml`.
- [ ] Add `src/lib.typ`, `src/site.typ`, `src/page.typ`, `src/layouts.typ`, `src/nav.typ`, `src/theme.typ`, `src/components.typ`, `src/assets.typ`, and `src/types.typ`.
- [ ] Add authored CSS files under `assets/css/`.
- [ ] Add authored JS under `assets/js/site.js`.
- [ ] Add `examples/basic/site.typ`.
- [ ] Add example pages under `examples/basic/pages/`.

## 2. Define Public API With Elembic

- [ ] Export `jtd.site(...)`, `jtd.page(...)`, `jtd.themes`, component constructors, and public types from `src/lib.typ`.
- [ ] Use Elembic elements/types where practical for API objects and validation.
- [ ] Define config type/fields.
- [ ] Define nav node types: page node and section node.
- [ ] Define page metadata type/fields.
- [ ] Make nav `title` a navigation label only.
- [ ] Make `jtd.page(title: ...)` required and independent from nav `title`.
- [ ] Add source comments documenting each public API.

## 3. Implement Elembic Nav/Node Types

- [ ] Define a page-node type with `title`, `src`, and `path`.
- [ ] Define a section-node type with `title` and `children`.
- [ ] Define a recursive nav type if practical; otherwise validate recursive children manually.
- [ ] Add constructors/helpers if useful: `nav-page(...)`, `nav-section(...)`.
- [ ] Support raw dictionary nav nodes if that keeps authoring ergonomic.
- [ ] Validate malformed nodes with useful errors.
- [ ] Keep nav node titles scoped to navigation UI only.

## 4. Implement Nav Model Helpers

- [ ] Detect/cast page nodes.
- [ ] Detect/cast section nodes.
- [ ] Recursively traverse nav.
- [ ] Implement `pages-from-nav(nav)`.
- [ ] Implement `breadcrumbs-for(path, nav)` using nav titles.
- [ ] Implement `children-for(path, nav)` using nav titles.
- [ ] Implement `is-active(path, item)`.
- [ ] Implement `emit-documents(nav)`.
- [ ] Use dynamic `include page.src`, since dynamic include/import works.

## 5. Implement `jtd.site(...)`

- [ ] Accept `config` and `nav`.
- [ ] Cast/validate config and nav with Elembic types where possible.
- [ ] Expose config/nav via metadata or another queryable mechanism.
- [ ] Emit shared CSS assets.
- [ ] Emit shared JS assets.
- [ ] Emit generated theme CSS variables.
- [ ] Recursively emit one `document(page.path)[#include page.src]` per nav page node.
- [ ] Do not use nav `title` as the page title.

## 6. Implement Page Lookup/Context

- [ ] Let `jtd.page(...)` retrieve site config/nav.
- [ ] Let `jtd.page(...)` identify the current nav page where possible.
- [ ] Determine whether current bundle output path is accessible.
- [ ] If not, support explicit fallback `jtd.page(path: ...)`.
- [ ] Document standalone page compilation behavior in source comments.

## 7. Implement `jtd.page(...)`

- [ ] Implement as a show-rule/template function.
- [ ] Require `title`.
- [ ] Accept `layout`, `description`, optional `path`, `tags`, `categories`, and future-oriented metadata fields.
- [ ] Emit/queryable frontmatter-like metadata for future features.
- [ ] Use page `title` for page-level layout rendering and metadata where supported.
- [ ] Do not infer page title from nav.
- [ ] Retrieve nav title only for navigation UI.
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
- [ ] Demonstrate page tags/categories/frontmatter metadata.
- [ ] Demonstrate callouts, buttons, labels, cards, code, and tables.

## 15. Verify Bundle Output

- [ ] Run `typst compile --features bundle,html --format bundle examples/basic/site.typ dist`.
- [ ] Verify all HTML pages are emitted from nav.
- [ ] Verify users do not manually declare page `document(...)` elements.
- [ ] Verify CSS/JS assets are emitted.
- [ ] Verify nested page asset paths work.
- [ ] Verify nav titles appear in navigation.
- [ ] Verify page titles appear in page layouts/metadata.
- [ ] Verify nav title and page title can differ.
- [ ] Verify page metadata is emitted/queryable for future features.
- [ ] Verify active nav state and breadcrumbs.
- [ ] Verify mobile menu behavior.
- [ ] Verify theme overrides.

## 16. Source Documentation

- [ ] Add source comments for `site.typ` API.
- [ ] Add source comments for `page.typ` API.
- [ ] Add source comments for config schema.
- [ ] Add source comments for nav section/page node schemas.
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
