// Native Typst rendering helpers for paged/PDF output.

#import "theme.typ" as themes

#let resolve-theme(theme: none) = {
  if theme == none {
    return themes.light()
  }
  if type(theme) == function {
    return theme()
  }
  theme
}

#let current-theme() = {
  let sites = query(<jtd-site>)
  if sites == () {
    return themes.light()
  }
  resolve-theme(theme: sites.first().value.config.theme)
}

#let color(theme, key) = rgb(theme.at(key))

#let ensure-theme(theme) = if theme == none { themes.light() } else { theme }

#let callout-color(theme, kind) = {
  if kind == "tip" {
    color(theme, "component-green")
  } else if kind == "warning" {
    color(theme, "component-yellow")
  } else if kind == "danger" {
    color(theme, "component-red")
  } else if kind == "important" {
    color(theme, "component-purple")
  } else if kind == "info" {
    color(theme, "component-blue")
  } else {
    color(theme, "theme-accent")
  }
}

#let button-style(theme, variant) = {
  let accent = color(theme, "theme-accent")
  let white = color(theme, "component-white")
  let yellow-text = color(theme, "component-yellow-text")
  if variant == "outline" {
    (fill: none, text: accent, stroke: rgb(theme.border))
  } else if variant == "primary" {
    (fill: color(theme, "button-primary"), text: white, stroke: color(theme, "button-primary"))
  } else if variant == "purple" {
    (fill: color(theme, "component-purple"), text: white, stroke: color(theme, "component-purple"))
  } else if variant == "blue" {
    (fill: color(theme, "component-blue"), text: white, stroke: color(theme, "component-blue"))
  } else if variant == "green" {
    (fill: color(theme, "component-green"), text: white, stroke: color(theme, "component-green"))
  } else if variant == "red" {
    (fill: color(theme, "component-red"), text: white, stroke: color(theme, "component-red"))
  } else if variant == "yellow" {
    (fill: color(theme, "component-yellow"), text: yellow-text, stroke: color(theme, "component-yellow"))
  } else {
    (fill: rgb(theme.at("base-button")), text: accent, stroke: rgb(theme.at("border")))
  }
}

#let label-style(theme, variant) = {
  let white = color(theme, "component-white")
  if variant == "green" {
    (fill: color(theme, "component-green"), text: white)
  } else if variant == "purple" {
    (fill: color(theme, "component-purple"), text: white)
  } else if variant == "red" {
    (fill: color(theme, "component-red"), text: white)
  } else if variant == "yellow" {
    (fill: color(theme, "component-yellow"), text: color(theme, "component-yellow-text"))
  } else if variant == "blue" {
    (fill: color(theme, "component-blue"), text: white)
  } else {
    (fill: color(theme, "theme-accent"), text: white)
  }
}

#let callout(kind: "note", title: none, body, theme: none) = {
  let theme = ensure-theme(theme)
  let accent = callout-color(theme, kind)
  block(
    width: 100%,
    inset: 10pt,
    outset: (y: 6pt),
    radius: 3pt,
    stroke: 1pt + accent,
    breakable: true,
  )[
    #if title != none {
      text(fill: accent, weight: "bold")[#title]
      parbreak()
    }
    #body
  ]
}

#let button(variant: "default", href: "#", body, theme: none) = {
  let theme = ensure-theme(theme)
  let style = button-style(theme, variant)
  let content = box(
    inset: (x: 7pt, y: 3pt),
    radius: 3pt,
    fill: style.fill,
    stroke: 1pt + style.stroke,
  )[
    #text(fill: style.text, weight: "medium")[#body]
  ]
  if href == "#" {
    content
  } else {
    link(href)[#content]
  }
}

#let label(variant: "default", body, theme: none) = {
  let theme = ensure-theme(theme)
  let style = label-style(theme, variant)
  box(
    inset: (x: 5pt, y: 1.5pt),
    radius: 10pt,
    fill: style.fill,
  )[
    #text(fill: style.text, size: 8pt, weight: "bold")[#body]
  ]
}

#let card(title: none, body, theme: none) = {
  let theme = ensure-theme(theme)
  block(
  width: 100%,
  inset: 10pt,
  outset: (y: 6pt),
  radius: 3pt,
  stroke: 1pt + rgb(theme.at("border")),
  breakable: true,
  )[
    #if title != none {
      text(fill: rgb(theme.at("body-heading")), weight: "bold")[#title]
      parbreak()
    }
    #body
  ]
}

#let render-image(src, alt: "", data: none, format: none, width: none, height: none, fit: none) = {
  let args = (:)
  if alt != "" { args.alt = alt }
  if format != none { args.format = format }
  if width != none { args.width = width }
  if height != none { args.height = height }
  if fit != none { args.fit = fit }
  image(if data == none { src } else { data }, ..args)
}
