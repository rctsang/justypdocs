// Target-aware Flowbite icon rendering.
//
// HTML output uses a generated SVG symbol sprite for compact, themeable icons.
// Paged/PDF output delegates to the Iconify Typst package with the same icon
// collection so user-facing names stay consistent across targets.

#import "@preview/bullseye:0.1.0": html, target
#import "@preview/iconify:0.5.3" as iconify

#let flowbite = json("../assets/icons/flowbite.json")

#let classes(..items) = items.pos().filter(item => item != none and item != "").join(" ")

#let css-value(value) = if type(value) == str { value } else { repr(value) }

#let icon-id(name) = name.replace(":", "-")

#let rooted-url(path) = {
  let sites = query(<jtd-site>)
  if sites == () {
    return path
  }

  let base = sites.first().value.config.base-url
  if base == "" {
    return path
  }

  let base = if base.ends-with("/") { base } else { base + "/" }
  let path = if path.starts-with("/") { path.slice(1) } else { path }
  base + path
}

#let sprite() = {
  let prefix = flowbite.prefix
  let root-width = flowbite.at("width", default: flowbite.at("height", default: 24))
  let root-height = flowbite.at("height", default: root-width)
  let symbols = ()

  for (name, icon) in flowbite.icons {
    let width = icon.at("width", default: root-width)
    let height = icon.at("height", default: root-height)
    symbols.push(
      "<symbol id=\"" + prefix + "-" + name + "\" viewBox=\"0 0 " + repr(width) + " " + repr(height) + "\">" + icon.body + "</symbol>"
    )
  }

  "<svg xmlns=\"http://www.w3.org/2000/svg\" style=\"display: none\">" + symbols.join("") + "</svg>"
}

#let html-attrs(name, label, title, size, width, height, y, fields, sprite-path) = {
  let attrs = (:)
  for (key, value) in fields {
    if key != "with" and not key.starts-with("__") and value != none {
      attrs.insert(key, value)
    }
  }

  let user-class = attrs.at("class", default: none)
  attrs.class = classes("jtd-icon", "jtd-icon-" + icon-id(name), user-class)
  if label == none {
    attrs.insert("aria-hidden", "true")
  } else {
    attrs.insert("role", "img")
    attrs.insert("aria-label", label)
  }

  let html-width = if width == none { size } else { width }
  let html-height = if height == none { size } else { height }
  let styles = (
    "width: " + css-value(html-width) + ";",
    "height: " + css-value(html-height) + ";",
  )
  if y != none {
    styles.push("vertical-align: " + css-value(y) + ";")
  }
  let existing = attrs.at("style", default: "")
  let prefix = if existing == "" {
    ""
  } else if existing.ends-with(";") {
    existing + " "
  } else {
    existing + "; "
  }
  attrs.insert("style", prefix + styles.join(" "))

  (
    attrs: attrs,
    title: title,
    href: sprite-path + "#" + icon-id(name),
  )
}

// Public API: `jtd.icon("flowbite:user-outline")`.
//
// `size` applies to both width and height by default. `width`, `height`, and
// `y` are forwarded to Iconify for paged/PDF output; HTML output converts
// sizing and `y` to CSS.
#let icon(
  name,
  label: none,
  title: none,
  size: 1em,
  width: none,
  height: none,
  y: none,
  sprite-path: none,
  ..fields,
) = context {
  if target() == "html" {
    let sprite-path = if sprite-path == none { rooted-url("/assets/icons/flowbite.svg") } else { sprite-path }
    let data = html-attrs(name, label, title, size, width, height, y, fields.named(), sprite-path)
    html.elem("svg", attrs: data.attrs)[
      #if data.title != none { html.elem("title")[#data.title] }
      #html.elem("use", attrs: (href: data.href))[]
    ]
  } else {
    let args = (:)
    args.width = if width == none { size } else { width }
    if height != none { args.height = height }
    if y != none { args.y = y }
    [
      #iconify.provide-icons(flowbite)
      #iconify.icon(name, ..args)
    ]
  }
}
