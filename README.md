# justypdocs

A Typst static documentation-site template inspired by [Just the Docs](https://just-the-docs.com/), built around Typst HTML/bundle export and Elembic elements.

Built with heavy use of GPT5.5

## Status

Experimental. This project targets Typst `0.15.0` HTML and bundle features, which are still under active development.

## Features

- Static multi-page documentation sites from a single nav tree
- `#show: jtd.page.with(...)` page wrapper
- Default and minimal layouts
- Recursive sidebar navigation
- Breadcrumbs
- Header links
- Theme customization via Typst dictionaries/functions
- Styled callouts, buttons, labels, and cards
- Mobile nav toggle and collapsible sections
- Bundle output with CSS, JS, icon, and theme assets
- Example light and custom/dark theme sites

## Local Installation

Install this package into Typst's local package namespace:

```sh
python3 install.py --link --force -y
```

Then import it from examples or your own project:

```typst
#import "@local/justypdocs:0.0.1" as jtd
```

## Basic Usage

Create a site file:

```typst
#import "@local/justypdocs:0.0.1" as jtd

#let config = (
  title: "My Docs",
  description: "Project documentation.",
  base-url: "/",
  footer: [Built with justypdocs],
  header-links: (
    (title: "GitHub", href: "https://github.com/"),
  ),
  theme: jtd.themes.light,
)

#let nav = (
  (
    id: "home",
    title: "Home",
    src: "/pages/home.typ",
    path: "index.html",
  ),
  (
    id: "guide",
    title: "Guide",
    children: (
      (
        id: "guide-install",
        title: "Install",
        src: "/pages/guide/install.typ",
        path: "guide/install.html",
      ),
    ),
  ),
)

#jtd.site(config: config, nav: nav)
```

Create a page:

```typst
#import "@local/justypdocs:0.0.1" as jtd

#show: jtd.page.with(
  id: "guide-install",
  title: "Installing My Project",
  description: "How to install the project.",
  tags: ("install",),
  categories: ("guide",),
)

= Install

Page content goes here.
```

The page `id` must match a nav page node. Nav `title` is only the navigation label; page `title` is used by layouts and metadata.

## Build

Build the basic example site:

```sh
typst compile --root "." --features bundle,html --format bundle examples/basic/site.typ dist
```

Build the custom theme example:

```sh
typst compile --root "." --features bundle,html --format bundle examples/custom/site.typ dist-custom
```

Compile an individual page to PDF:

```sh
typst compile --root "." examples/basic/pages/guide/components.typ components.pdf
```

## Components

```typst
#jtd.callout(kind: "warning", title: "Warning")[
  Important supporting content.
]

#jtd.button(href: "/guide/install.html", variant: "primary")[Get started]

#jtd.label(variant: "green")[New]

#jtd.card(title: [Example card])[
  Related content or links.
]
```

Supported callout kinds include `note`, `info`, `tip`, `warning`, `danger`, and `important`.

Supported button variants include `default`, `outline`, `primary`, `purple`, `blue`, `green`, `red`, and `yellow`.

Supported label variants include `default`, `blue`, `green`, `purple`, `red`, and `yellow`.

## Themes

Themes are Typst functions/dictionaries. Built-in themes:

```typst
jtd.themes.light
jtd.themes.dark
```

Customize with `.with(...)`:

```typst
#let config = (
  title: "My Docs",
  base-url: "/",
  theme: jtd.themes.light.with(
    theme-accent: "#15aabf",
    nav-width: "18rem",
  ),
)
```

Theme tokens are emitted as CSS custom properties prefixed with `--jtd-`.

## Verification

Run the project verification script:

```sh
python3 tests/verify.py
```

This installs the local package, builds example bundles, checks generated assets/layout HTML, verifies theme output, and checks validation failures.

## Notes

- Search is intentionally deferred to a future post-processing step.
- Components render for both HTML and paged/PDF output.
- Typst HTML/bundle export is experimental, so behavior may change with Typst releases.
