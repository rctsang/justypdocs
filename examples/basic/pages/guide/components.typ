#import "../../../../src/lib.typ" as jtd

#show: jtd.page.with(
  id: "guide-components",
  title: "Component Examples",
  description: "Callouts, buttons, labels, cards, code, and tables.",
  tags: ("components", "ui"),
  categories: ("guide",),
)

= Components

#jtd.label(variant: "default")[Stable API]

#jtd.callout(kind: "note", title: "Callout")[
  Use callouts for short supporting notes that should stand apart from body content.
]

#jtd.card(title: [Example card])[
  Cards can group related links or short summaries.

  #jtd.button(href: "/reference/metadata.html")[Read metadata reference]
]

```typst
#jtd.callout(title: "Note")[Important supporting content.]
```

#table(
  columns: 3,
  [Component], [Class], [Use],
  [Callout], [`jtd-callout`], [Highlighted documentation note],
  [Button], [`jtd-button`], [Prominent link action],
  [Card], [`jtd-card`], [Grouped content block],
)
