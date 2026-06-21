// Public Elembic components.
//
// These placeholder elements establish the public API. Rendering and styling
// behavior will be expanded in the component implementation task.

#import "@preview/elembic:1.1.1" as e

#let prefix = "@local/justypdocs,v0"

// Highlighted content block.
#let callout = e.element.declare(
  "callout",
  prefix: prefix,
  doc: "A highlighted documentation callout.",
  display: it => block(it.body),
  fields: (
    e.field("body", content, doc: "Callout body.", required: true),
    e.field("kind", str, doc: "Callout kind.", default: "note"),
    e.field("title", e.types.option(str), doc: "Optional callout title.", default: none),
  ),
)

// Link-like action component.
#let button = e.element.declare(
  "button",
  prefix: prefix,
  doc: "A styled action link/button.",
  display: it => link(it.href)[#it.body],
  fields: (
    e.field("body", content, doc: "Button contents.", required: true),
    e.field("href", str, doc: "Button target URL.", default: "#"),
    e.field("variant", str, doc: "Button visual variant.", default: "default"),
  ),
)

// Small inline label/badge.
#let label = e.element.declare(
  "label",
  prefix: prefix,
  doc: "An inline label or badge.",
  display: it => text(size: 0.8em)[#it.body],
  fields: (
    e.field("body", content, doc: "Label contents.", required: true),
    e.field("variant", str, doc: "Label visual variant.", default: "default"),
  ),
)

// Generic card container.
#let card = e.element.declare(
  "card",
  prefix: prefix,
  doc: "A bordered card container.",
  display: it => block(it.body),
  fields: (
    e.field("body", content, doc: "Card contents.", required: true),
    e.field("title", e.types.option(content), doc: "Optional card title.", default: none),
  ),
)
