#import "@local/justypdocs:0.0.1" as jtd

#show: jtd.page.with(
  id: "guide-components",
  title: "Component Examples",
  description: "Callouts, buttons, labels, cards, code, and tables.",
  tags: ("components", "ui"),
  categories: ("guide",),
)

#jtd.stylesheet(
  path: "assets/component-demo.css",
  data: read("assets/component-demo.css"),
)
#jtd.stylesheet(
  path: "/assets/root-demo.css",
  data: read("assets/root-demo.css"),
)
#jtd.script(
  path: "assets/component-demo.js",
  data: read("assets/component-demo.js"),
)
#jtd.asset(
  path: "assets/component-demo.svg",
  data: read("assets/component-demo.svg"),
)
#jtd.asset(
  path: "/assets/root-demo.txt",
  data: read("assets/root-demo.txt"),
)

= Components

#jtd.label(variant: "default")[Stable]
#jtd.label(variant: "green")[New]
#jtd.label(variant: "purple")[Beta]
#jtd.label(variant: "red")[Breaking]
#jtd.label(variant: "yellow")[Warning]

#jtd.callout(kind: "note", title: "Callout")[
  Use callouts for short supporting notes that should stand apart from body content.
]

#jtd.callout(kind: "tip", title: "Tip")[
  Use `kind: "tip"` for positive guidance.
]

#jtd.callout(kind: "warning", title: "Warning")[
  Use `kind: "warning"` when readers should slow down before continuing.
]

#jtd.callout(kind: "danger", title: "Danger")[
  Use `kind: "danger"` for destructive or high-risk actions.
]

#jtd.callout(kind: "important", title: "Important")[
  Use `kind: "important"` for details that should stand out from normal notes.
]

#jtd.button(href: "/reference/metadata.html")[Default]
#jtd.button(href: "/reference/metadata.html", variant: "outline")[Outline]
#jtd.button(href: "/reference/metadata.html", variant: "primary")[Primary]
#jtd.button(href: "/reference/metadata.html", variant: "green")[Green]
#jtd.button(href: "/reference/metadata.html", variant: "yellow")[Yellow]
#jtd.button(
  href: "#component-target",
  variant: "outline",
  id: "jump-to-component-target",
  class: "js-scroll-link",
  data-scroll-to: "component-target",
)[Jump to target]

#jtd.callout(
  kind: "info",
  title: "Custom attributes",
  id: "component-target",
  data-example: "attribute-pass-through",
)[
  Component elements can pass custom HTML attributes through for scripts and CSS.
]

#jtd.card(title: [Example card])[
  Cards can group related links or short summaries.

  #jtd.button(href: "/reference/metadata.html", variant: "blue")[Read metadata reference]
]

#jtd.image(
  src: "assets/component-demo.svg",
  alt: "Component demo graphic",
  data: read("assets/component-demo.svg", encoding: none),
  format: "svg",
  width: 80%,
  fit: "contain",
  class: "component-demo-image",
  data-example: "target-aware-image",
)

```typst
#jtd.callout(kind: "warning", title: "Warning")[Important supporting content.]
```

#table(
  columns: 3,
  [Component], [Class], [Use],
  [Callout], [`jtd-callout`], [Highlighted documentation note],
  [Button], [`jtd-button`], [Prominent link action],
  [Card], [`jtd-card`], [Grouped content block],
)
