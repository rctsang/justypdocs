// Public Elembic components.
//
// These placeholder elements establish the public API. Rendering and styling
// behavior will be expanded in the component implementation task.

#import "@preview/elembic:1.1.1" as e
#import "types.typ": prefix

// Highlighted content block.
#let callout = e.element.declare(
  "callout",
  prefix: prefix,
  doc: "A highlighted documentation callout.",
  display: it => block(it.body),
  fields: (
    e.field("body", content, required: true,
      doc: "Callout body."),
    e.field("kind", str, default: "note",
      doc: "Callout kind."),
    e.field("title", e.types.option(str), default: none,
      doc: "Optional callout title."),
  ),
)

// Link-like action component.
#let button = e.element.declare(
  "button",
  prefix: prefix,
  doc: "A styled action link/button.",
  display: it => link(it.href)[#it.body],
  fields: (
    e.field("body", content, required: true,
      doc: "Button contents."),
    e.field("href", str, default: "#",
      doc: "Button target URL."),
    e.field("variant", str, default: "default",
      doc: "Button visual variant."),
  ),
)

// Small inline label/badge.
#let label = e.element.declare(
  "label",
  prefix: prefix,
  doc: "An inline label or badge.",
  display: it => text(size: 0.8em)[#it.body],
  fields: (
    e.field("body", content, required: true,
      doc: "Label contents."),
    e.field("variant", str, default: "default",
      doc: "Label visual variant."),
  ),
)

// Generic card container.
#let card = e.element.declare(
  "card",
  prefix: prefix,
  doc: "A bordered card container.",
  display: it => block(it.body),
  fields: (
    e.field("body", content, required: true,
      doc: "Card contents."),
    e.field("title", e.types.option(content), default: none,
      doc: "Optional card title."),
  ),
)
