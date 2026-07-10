// Public Elembic components.
//
// Components render explicit HTML elements for HTML export and native Typst
// shapes for paged/PDF output.

#import "@preview/elembic:1.1.1" as e
#import "@preview/bullseye:0.1.0": html, target
#import "paged.typ" as paged
#import "types.typ": prefix

#let classes(..items) = items.pos().filter(item => item != none and item != "").join(" ")

// Highlighted content block.
#let callout = e.element.declare(
  "callout",
  prefix: prefix,
  doc: "A highlighted documentation callout.",
  display: it => context {
    if target() == "html" {
      html.elem(
        "aside",
        attrs: (
          class: classes("jtd-callout", "jtd-callout-" + it.kind),
          "data-kind": it.kind,
        ),
      )[
        #if it.title != none {
          html.elem("div", attrs: (class: "jtd-callout-title"))[#it.title]
        }
        #html.elem("div", attrs: (class: "jtd-callout-body"))[#it.body]
      ]
    } else {
      paged.callout(kind: it.kind, title: it.title, theme: paged.current-theme(), it.body)
    }
  },
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
  display: it => context {
    if target() == "html" {
      html.elem(
        "a",
        attrs: (
          class: classes("jtd-button", "jtd-button-" + it.variant),
          href: it.href,
        ),
      )[#it.body]
    } else {
      paged.button(variant: it.variant, href: it.href, theme: paged.current-theme(), it.body)
    }
  },
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
  display: it => context {
    if target() == "html" {
      html.elem(
        "span",
        attrs: (class: classes("jtd-label", "jtd-label-" + it.variant)),
      )[#it.body]
    } else {
      paged.label(variant: it.variant, theme: paged.current-theme(), it.body)
    }
  },
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
  display: it => context {
    if target() == "html" {
      html.elem("section", attrs: (class: "jtd-card"))[
        #if it.title != none {
          html.elem("div", attrs: (class: "jtd-card-title"))[#it.title]
        }
        #html.elem("div", attrs: (class: "jtd-card-body"))[#it.body]
      ]
    } else {
      paged.card(title: it.title, theme: paged.current-theme(), it.body)
    }
  },
  fields: (
    e.field("body", content, required: true,
      doc: "Card contents."),
    e.field("title", e.types.option(content), default: none,
      doc: "Optional card title."),
  ),
)
