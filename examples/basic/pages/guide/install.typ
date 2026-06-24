#import "../../../../src/lib.typ" as jtd

#show: jtd.page.with(
  id: "guide-install",
  title: "Installing Justypdocs",
  description: "Install and build the basic example site.",
  tags: ("install", "bundle"),
  categories: ("guide",),
)

= Install

This page will demonstrate the default documentation layout.

The navigation title is _Install_, but this page title is _Installing Justypdocs_.

```sh
typst compile --root "." --features bundle,html --format bundle examples/basic/site.typ dist
```

#table(
  columns: 2,
  [Command], [Purpose],
  [`typst compile`], [Build HTML or bundle output],
  [`--features bundle,html`], [Enable experimental site output],
)
