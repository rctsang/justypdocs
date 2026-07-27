// Public Elembic components.
//
// Components render explicit HTML elements for HTML export and native Typst
// shapes for paged/PDF output.
// Unknown named arguments are forwarded as HTML attributes for HTML export and
// ignored for paged/PDF output.

#import "@preview/elembic:1.1.1" as e
#import "@preview/bullseye:0.1.0": html, target
#import "paged.typ" as paged
#import "types.typ": prefix

#let classes(..items) = items.pos().filter(item => item != none and item != "").join(" ")

#let html-attrs(fields, known, base-class: none) = {
  let attrs = (:)
  for (key, value) in fields {
    if key not in known and key != "with" and not key.starts-with("__") and value != none {
      attrs.insert(key, value)
    }
  }

  let user-class = attrs.at("class", default: none)
  if base-class != none or user-class != none {
    attrs.class = classes(base-class, user-class)
  }

  attrs
}

// Highlighted content block.
#let callout = e.element.declare(
  "callout",
  prefix: prefix,
  doc: "A highlighted documentation callout.",
  display: it => context {
    if target() == "html" {
      let attrs = html-attrs(
        it,
        ("body", "kind", "title"),
        base-class: classes("jtd-callout", "jtd-callout-" + it.kind),
      )
      attrs.insert("data-kind", it.kind)
      html.elem(
        "aside",
        attrs: attrs,
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
  allow-unknown-fields: true,
)

// Link-like action component.
#let button = e.element.declare(
  "button",
  prefix: prefix,
  doc: "A styled action link/button.",
  display: it => context {
    if target() == "html" {
      let attrs = html-attrs(
        it,
        ("body", "href", "variant"),
        base-class: classes("jtd-button", "jtd-button-" + it.variant),
      )
      attrs.insert("href", it.href)
      html.elem(
        "a",
        attrs: attrs,
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
  allow-unknown-fields: true,
)

// Small inline label/badge.
#let label = e.element.declare(
  "label",
  prefix: prefix,
  doc: "An inline label or badge.",
  display: it => context {
    if target() == "html" {
      let attrs = html-attrs(
        it,
        ("body", "variant"),
        base-class: classes("jtd-label", "jtd-label-" + it.variant),
      )
      html.elem(
        "span",
        attrs: attrs,
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
  allow-unknown-fields: true,
)

// Generic card container.
#let card = e.element.declare(
  "card",
  prefix: prefix,
  doc: "A bordered card container.",
  display: it => context {
    if target() == "html" {
      let attrs = html-attrs(
        it,
        ("body", "title"),
        base-class: "jtd-card",
      )
      html.elem("section", attrs: attrs)[
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
  allow-unknown-fields: true,
)

// Target-aware image component.
// HTML output renders an `<img>` with pass-through attributes. Paged/PDF output
// renders Typst's native image element with optional sizing.
#let image = e.element.declare(
  "image",
  prefix: prefix,
  doc: "A target-aware image for HTML and paged/PDF output.",
  display: it => context {
    if target() == "html" {
      let attrs = html-attrs(
        it,
        ("src", "alt", "data", "format", "width", "height", "fit"),
        base-class: "jtd-image",
      )
      attrs.insert("src", it.src)
      attrs.insert("alt", it.alt)
      if it.width != none { attrs.insert("width", it.width) }
      if it.height != none { attrs.insert("height", it.height) }
      html.elem("img", attrs: attrs)[]
    } else {
      paged.render-image(
        it.src,
        alt: it.alt,
        data: it.data,
        format: it.format,
        width: it.width,
        height: it.height,
        fit: it.fit,
      )
    }
  },
  fields: (
    e.field("src", str, required: true, named: true,
      doc: "Image source URL/path."),
    e.field("alt", str, default: "",
      doc: "Alternative text for HTML output."),
    e.field("data", e.types.option(e.types.any), default: none,
      doc: "Optional image data for paged/PDF output, usually read(..., encoding: none)."),
    e.field("format", e.types.option(e.types.any), default: none,
      doc: "Optional native Typst image format for paged/PDF output."),
    e.field("width", e.types.option(e.types.any), default: none,
      doc: "Optional image width."),
    e.field("height", e.types.option(e.types.any), default: none,
      doc: "Optional image height."),
    e.field("fit", e.types.option(str), default: none,
      doc: "Optional native Typst image fit mode for paged/PDF output."),
  ),
  allow-unknown-fields: true,
)
