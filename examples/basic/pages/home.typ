#import "../../../src/lib.typ" as jtd

#show: jtd.page.with(
  id: "home",
  title: "Justypdocs Documentation Template",
  description: "A default-layout landing page for the basic example.",
  tags: ("home", "default-layout"),
  categories: ("examples",),
)

= Justypdocs

A Typst template for a static documentation website.

#jtd.callout(title: "Default layout")[
  This home page uses the default documentation layout. The dedicated minimal layout example lives under Demos.
]

#jtd.button(href: "/guide/install.html", variant: "primary")[Get started]
