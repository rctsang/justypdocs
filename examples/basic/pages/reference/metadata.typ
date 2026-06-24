#import "../../../../src/lib.typ" as jtd

#show: jtd.page.with(
  id: "reference-metadata",
  title: "Page Metadata Reference",
  description: "Demonstrates page metadata fields emitted by jtd.page.",
  tags: ("metadata", "frontmatter"),
  categories: ("reference",),
)

= Metadata

Pages match navigation entries by stable `id`.

```typst
#show: jtd.page.with(
  id: "reference-metadata",
  title: "Page Metadata Reference",
  tags: ("metadata",),
  categories: ("reference",),
)
```

The page `title` is separate from the navigation label.
