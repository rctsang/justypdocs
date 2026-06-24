#import "../../../src/lib.typ" as jtd

#show: jtd.page.with(
  id: "custom-home",
  title: "Custom Theme Example",
  description: "A dark custom-theme example.",
  tags: ("theme", "dark"),
  categories: ("examples",),
)

= Custom Theme

This example uses `jtd.themes.dark.with(...)` to override theme tokens.
