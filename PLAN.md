# Justypdocs Implementation Plan

## Goal

Build a Typst 0.15 static documentation-site template inspired by Just the Docs, using bundle export for multi-file output and Elembic for typed, stylable layouts and components.

The initial focus is layout, themes, styling, navigation, and reusable content components. Search is explicitly deferred and should later be added as a post-processing step over generated HTML.

## Core Architecture

Use `site.typ` as the bundle entrypoint and central site manifest. It should import the package, define site configuration and navigation, call `jtd.site(...)` once, and then define pages with Typst's built-in `document(...)` elements using `include`.

Page files should own their page-level layout selection and page metadata by applying a `jtd.page(...)` show rule. This keeps the bundle structure explicit in `site.typ` while keeping each page responsible for its own presentation mode.

There should not be a separate `config.typ` file in the intended authoring model.

Proposed structure for a consuming site:

```text
my-docs/
  site.typ
  pages/
    home.typ
    guide/
      install.typ
      config.typ
```

Proposed package structure:

```text
justypdocs/
  typst.toml
  src/
    lib.typ
    site.typ
    page.typ
    layouts.typ
    nav.typ
    theme.typ
    components.typ
    assets.typ
  assets/
    css/
      base.css
      layout.css
      navigation.css
      content.css
      components.css
    js/
      site.js
  examples/
    basic/
      site.typ
      pages/
        home.typ
        guide/
          install.typ
```

## Bundle Model

Typst 0.15 bundle export enables static-site output with:

```typst
#document("index.html", include "pages/home.typ")
#asset("assets/css/site.css", read("assets/css/site.css"))
```

Build commands should use:

```sh
typst compile --features bundle,html --format bundle site.typ dist
typst watch --features bundle,html --format bundle site.typ dist
```

`typst watch` can provide local serving and live reload unless disabled by flags.

## Intended `site.typ` Shape

```typst
#import "@local/justypdocs:0.0.1" as jtd

#let config = (
  title: "My Docs",
  description: "Project documentation",
  base-url: "/",
  footer: [Built with justypdocs],
  theme: jtd.themes.light.with(
    link: "#7253ed",
  ),
)

#let nav = (
  (title: "home", path: "index.html"),
  (
    title: "guide",
    children: (
      (title: "install", path: "guide/install.html"),
      (title: "config", path: "guide/config.html"),
    ),
  ),
)

#jtd.site(
  config: config,
  nav: nav,
)

#document("index.html", include "pages/home.typ")
#document("guide/install.html", include "pages/guide/install.typ")
#document("guide/config.html", include "pages/guide/config.typ")
```

`site.typ` should not call a page-layout helper around page content. It should only define shared site data, call `jtd.site(...)`, and list bundled documents/assets through the package API and Typst's built-in bundle elements.

## Intended Page Shape

Each page imports the package and applies `jtd.page(...)` as a show rule:

```typst
#import "@local/justypdocs:0.0.1" as jtd

#show: jtd.page(
  title: "Home",
  layout: "minimal",
)

= justypdocs

a typst template for a static webpage

#jtd.callout(kind: "note")[
  requires Typst v0.15.0 or greater with `--features bundle,html`
]
```

The page owns:

- Its visible title.
- Its layout choice, such as `"default"` or `"minimal"`.
- Its body content.
- Any page-local layout options added later.

The surrounding `document(...)` in `site.typ` owns:

- The output path.
- The fact that the page is part of the bundle.

The initial implementation should determine whether `jtd.page(...)` should also set HTML document metadata such as title and description, or whether users should optionally pass metadata to `document(...)` in `site.typ` when needed.

## `jtd.site(...)`

`jtd.site(...)` is responsible for registering site-wide data and emitting shared assets.

Responsibilities:

- Accept `config` and `nav`.
- Store or expose config/nav so `jtd.page(...)` can render layouts for included documents.
- Emit shared CSS assets.
- Emit shared JavaScript assets.
- Emit generated theme CSS variables.
- Emit any other global bundle assets needed by layouts/components.

Example call:

```typst
#jtd.site(
  config: config,
  nav: nav,
)
```

~~The implementation should investigate the best mechanism for sharing `config` and `nav` from `jtd.site(...)` to later `jtd.page(...)` calls in included documents. Likely options include an Elembic settings element or Typst state/context patterns.~~

`config` and `nav` can be exposed via metadata, then queried for within helper functions in included documents.
the data will not be available to the document if compiled standalone, but when that is the case, presumably it doesn't matter, as `config` and `nav` are for building the entire website anyways.
default configurations can be declared in-file if `config` is unavailable in the query, but is needed for the document content (which also shouldn't be the case)

## `jtd.page(...)`

`jtd.page(...)` should be a show-rule/template function that wraps page content in a selected layout.

Responsibilities:

- Accept page metadata such as `title`, `description`, and `layout`.
- Retrieve site config/nav registered by `jtd.site(...)`.
- Render the selected layout shell.
- Render sidebar, header, breadcrumbs, main content, and footer where appropriate.
- Compute active nav state from the current output path or explicit page path metadata.
- Support layout variants.

Initial layouts:

- `"default"`: Just-the-Docs-like sidebar, header, breadcrumbs, content, and footer.
- `"minimal"`: simpler page shell with reduced or no sidebar, useful for landing pages.

Additional layouts can be added later without changing the bundle model.

## Assets

CSS and JavaScript should be written as explicit `.css` and `.js` files rather than Typst raw blocks. This lets authors and package maintainers rely on editor and LSP support.

Package assets should live under `assets/` and be emitted by `jtd.site(...)` using `read(...)` and `asset(...)`.

Conceptual implementation:

```typst
#asset("assets/css/base.css", read("../assets/css/base.css"))
#asset("assets/css/layout.css", read("../assets/css/layout.css"))
#asset("assets/css/navigation.css", read("../assets/css/navigation.css"))
#asset("assets/css/content.css", read("../assets/css/content.css"))
#asset("assets/css/components.css", read("../assets/css/components.css"))
#asset("assets/js/site.js", read("../assets/js/site.js"))
#asset("assets/css/theme.css", render-theme-css(config.theme))
```

The exact relative paths should be verified when implementing package asset reads.

Theme customization may still generate a small CSS file from Typst dictionaries, but the bulk stylesheet and scripts should stay in real `.css` and `.js` source files.

## Elembic Role

Use Elembic for reusable, typed, customizable layout and content components. Do not rely on Elembic or bundle introspection to discover pages in the initial version.

Good Elembic candidates:

- `callout`
- `button`
- `label`
- `card`
- `page-header`
- `sidebar`
- `breadcrumb`
- `children-nav`
- `aux-nav`
- `layout-settings`

Elembic set/show rules should support scoped customization of components:

```typst
#show: e.set_(button, radius: 4px, variant: "primary")
#show: e.set_(callout, accent: blue)
```

Use typed fields for component options so invalid configuration fails clearly.

## Theme System

Model Just the Docs SCSS variables as Typst dictionaries and emit CSS custom properties.

Initial light theme tokens:

```typst
#let light-theme = (
  color-scheme: "light",
  body-background: "#fff",
  body-heading: "#27262b",
  body-text: "#5c5962",
  link: "#7253ed",
  sidebar: "#f5f6fa",
  border: "#eeebee",
  code-background: "#fff",
  table-background: "#fff",
  nav-width: "16.5rem",
  content-width: "50rem",
  header-height: "3.75rem",
)
```

Initial dark theme tokens:

```typst
#let dark-theme = (
  color-scheme: "dark",
  body-background: "#27262b",
  body-heading: "#f5f6fa",
  body-text: "#e6e1e8",
  link: "#5ca0fb",
  sidebar: "#27262b",
  border: "#44434d",
  code-background: "#0d1117",
  table-background: "#302d36",
)
```

Generated CSS should expose these as custom properties:

```css
:root {
  color-scheme: light;
  --body-background: #fff;
  --body-heading: #27262b;
  --body-text: #5c5962;
  --link: #7253ed;
  --sidebar: #f5f6fa;
  --border: #eeebee;
}
```

This makes themes easy to customize without introducing a SCSS build step.

## Layout Target

Recreate the core Just the Docs structure for the default layout:

- Fixed left sidebar on medium/desktop viewports.
- Mobile top header with hamburger menu.
- Main content constrained to approximately `50rem`.
- Responsive breakpoints similar to Just the Docs `md` and `lg` breakpoints.
- Breadcrumbs above content.
- Optional auxiliary links in the header.
- Optional footer in sidebar and/or below content.
- Active nav highlighting.
- Expandable nested navigation.

The generated default page should roughly follow this semantic shape:

```html
<body>
  <a class="skip-to-main" href="#main-content">Skip to main content</a>
  <header class="side-bar">...</header>
  <div class="main" id="top">
    <div id="main-header" class="main-header">...</div>
    <div class="main-content-wrap">
      <nav class="breadcrumb-nav">...</nav>
      <div id="main-content" class="main-content">
        <main>...</main>
        <footer>...</footer>
      </div>
    </div>
  </div>
</body>
```

Use Typst HTML export and `html.elem` where necessary to preserve semantic structure and classes.

## Navigation Model

Represent navigation as explicit data in `site.typ` rather than trying to infer it from page files.

Example:

```typst
#let nav = (
  (title: "home", path: "index.html"),
  (title: "guide", children: (
    (title: "install", path: "guide/install.html"),
    (title: "config", path: "guide/config.html"),
  )),
)
```

Implement helpers:

- `nav-link(title, path, children: (), external: false)`
- `nav-section(title, children)`
- `flatten-nav(nav)`
- `breadcrumbs-for(path, nav)`
- `children-for(path, nav)`
- `is-active(path, item)`

Active navigation should be generated by comparing the current page path with nav items. If Typst does not expose the current bundle output path inside the page content, `jtd.page(...)` may need an explicit `path` option as a fallback:

```typst
#show: jtd.page(
  title: "Install",
  path: "guide/install.html",
)
```

JavaScript should only handle mobile menu behavior and optional expand/collapse interactions.

## CSS Scope For Initial Version

Port the relevant Just the Docs SCSS into authored plain CSS using variables:

- Base typography and colors.
- Sidebar/main layout.
- Navigation tree.
- Breadcrumbs.
- Main content typography.
- Code blocks.
- Tables.
- Blockquotes.
- Buttons.
- Labels.
- Callouts.
- Skip-to-main link.
- Basic print styles.

Avoid porting all Just the Docs utility classes in the first version. Add utility classes later only when they are clearly useful.

## JavaScript Scope For Initial Version

Initial `site.js` should be minimal:

- Toggle mobile nav.
- Expand/collapse nav groups.
- Optionally make horizontally scrollable code blocks focusable.
- Optionally support a copy-code button.

Search is not part of the initial JavaScript scope.

## Search Plan For Later

Search should be deferred and implemented as a post-processing step after Typst emits the bundle.

Example future workflow:

```sh
typst compile --features bundle,html --format bundle site.typ dist
justypdocs-index dist
```

The post-processor can parse generated HTML, extract page title/content/headings, and emit:

```text
dist/assets/js/search-data.json
```

A later optional search script can consume Lunr or a lighter index. This avoids forcing Typst to stringify arbitrary page content accurately.

## Verification Plan

During implementation, verify:

- The example bundle compiles successfully.
- Output includes expected HTML pages and assets.
- `site.typ` only needs `jtd.site(...)` plus `document(..., include ...)` declarations.
- Page files can apply `#show: jtd.page(...)` and render with the selected layout.
- Nested page asset paths work correctly.
- Light and dark themes render correctly.
- Custom theme overrides work through Typst dictionaries.
- Desktop layout has fixed sidebar and bounded content width.
- Mobile layout has functioning hamburger nav.
- Nav active states and nested expansion work.
- Breadcrumbs are correct for nested pages.
- Page metadata behavior is documented and works as designed.

## Milestones

1. Create the package skeleton and minimal example `site.typ` with `jtd.site(...)`, two `document(..., include ...)` pages, and copied CSS/JS assets.
2. Implement `jtd.site(...)` to accept config/nav, expose them to pages, and emit shared assets.
3. Implement `jtd.page(...)` as a page-level show rule with `default` and `minimal` layout support.
4. Implement theme dictionaries and generated theme CSS variables.
5. Port Just the Docs layout, navigation, and content styles into authored CSS files.
6. Add minimal JavaScript for mobile menu and nav expansion.
7. Add Elembic components for callouts, buttons, labels, cards, and page-local UI.
8. Add examples for light, dark, and custom themes.
9. Document the authoring model: `site.typ` owns config/nav/assets/document declarations, while each page owns `jtd.page(...)` and content.
10. Later, add a post-processing search indexer.

## Design Recommendation

Keep `site.typ` explicit and simple: define config/nav, call `jtd.site(...)`, and list documents using `document(..., include ...)`. This preserves a clear mental model, aligns with Typst 0.15 bundle export, avoids premature introspection complexity, and makes the generated website structure obvious from one file.
