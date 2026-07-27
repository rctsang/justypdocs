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

#let css-value(value) = if type(value) == str { value } else { repr(value) }

#let append-style(attrs, declarations) = {
  let declarations = declarations.filter(item => item != none)
  if declarations.len() == 0 {
    return attrs
  }

  let existing = attrs.at("style", default: "")
  let prefix = if existing == "" {
    ""
  } else if existing.ends-with(";") {
    existing + " "
  } else {
    existing + "; "
  }
  attrs.insert("style", prefix + declarations.join(" "))
  attrs
}

#let image-html-attrs(src, alt, width, height, fit, fields) = {
  let attrs = html-attrs(
    fields,
    (),
    base-class: "jtd-image",
  )
  attrs.insert("src", src)
  attrs.insert("alt", alt)

  let styles = ()
  if width != none {
    if type(width) == int {
      attrs.insert("width", width)
    } else {
      styles.push("width: " + css-value(width) + ";")
    }
  }
  if height != none {
    if type(height) == int {
      attrs.insert("height", height)
    } else {
      styles.push("height: " + css-value(height) + ";")
    }
  }
  if fit != none {
    styles.push("object-fit: " + fit + ";")
  }

  append-style(attrs, styles)
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

// Target-aware image function.
// HTML output renders an `<img>` with pass-through attributes. Paged/PDF output
// renders Typst's native image element with optional sizing.
#let image(src: none, alt: "", data: none, format: none, width: none, height: none, fit: none, ..fields) = context {
  if src == none {
    panic("jtd.image requires a src")
  }

  if target() == "html" {
    let attrs = image-html-attrs(src, alt, width, height, fit, fields.named())
    html.elem("img", attrs: attrs)[]
  } else {
    paged.render-image(
      src,
      alt: alt,
      data: data,
      format: format,
      width: width,
      height: height,
      fit: fit,
    )
  }
}
