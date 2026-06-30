#import "@preview/oxifmt:1.0.0": strfmt

#let open-color = json("../assets/open-color.json")
#let oc(name, step) = open-color.at(name).at(step)
#let named-color(name) = open-color.at(name)

// Theme token definitions.
//
// Built-in themes are functions so users can customize them with Typst's
// built-in function `.with(...)` support, e.g. `jtd.themes.light.with(link: ...)`.
// The returned dictionary is converted to CSS custom properties in
// `assets/css/theme.css` as `--jtd-{token-name}`.
//
// Core color tokens:
// - `theme-accent`, `body-background`, `body-heading`, `body-text`, `link`, `sidebar`, `border`
// - `code-background`, `table-background`, `base-button`, `feedback`
// Component palette tokens:
// - `component-blue`, `component-green`, `component-purple`, `component-red`
// - `component-yellow`, `component-yellow-text`, `component-white`, `button-primary`
// Core layout tokens:
// - `nav-width`, `content-width`, `header-height`
// Core shape/spacing tokens:
// - `border-radius`, `spacing-unit`

#let light(
  color-scheme: "light",
  body-background: named-color("white"),
  body-heading: oc("gray", 9),
  body-text: oc("gray", 7),
  link: none,
  sidebar: oc("gray", 0),
  border: oc("gray", 2),
  code-background: named-color("white"),
  table-background: named-color("white"),
  base-button: oc("gray", 0),
  feedback: oc("gray", 2),
  component-blue: oc("blue", 6),
  component-green: oc("green", 7),
  component-purple: oc("violet", 7),
  component-red: oc("red", 7),
  component-yellow: oc("yellow", 5),
  component-yellow-text: oc("gray", 9),
  component-white: named-color("white"),
  button-primary: none,
  nav-width: "16.5rem",
  content-width: "50rem",
  header-height: "3.75rem",
  border-radius: "4px",
  spacing-unit: "1rem",
  ..tokens,
) = {
  let extra = tokens.named()
  let accent = extra.at("theme-accent", default: oc("cyan", 6))
  let link = if link == none { accent } else { link }
  let button-primary = if button-primary == none { accent } else { button-primary }

  (
    color-scheme: color-scheme,
    body-background: body-background,
    body-heading: body-heading,
    body-text: body-text,
    theme-accent: accent,
    link: link,
    sidebar: sidebar,
    border: border,
    code-background: code-background,
    table-background: table-background,
    base-button: base-button,
    feedback: feedback,
    component-blue: component-blue,
    component-green: component-green,
    component-purple: component-purple,
    component-red: component-red,
    component-yellow: component-yellow,
    component-yellow-text: component-yellow-text,
    component-white: component-white,
    button-primary: button-primary,
    nav-width: nav-width,
    content-width: content-width,
    header-height: header-height,
    border-radius: border-radius,
    spacing-unit: spacing-unit,
  ) + extra
}

#let dark = light.with(
  color-scheme: "dark",
  body-background: oc("gray", 9),
  body-heading: oc("gray", 0),
  body-text: oc("gray", 2),
  theme-accent: oc("cyan", 4),
  sidebar: oc("gray", 9),
  border: oc("gray", 7),
  code-background: named-color("black"),
  table-background: oc("gray", 8),
  base-button: oc("gray", 8),
  feedback: oc("gray", 8),
  component-blue: oc("blue", 4),
  component-green: oc("green", 4),
  component-purple: oc("violet", 3),
  component-red: oc("red", 5),
  component-yellow: oc("yellow", 3),
  component-yellow-text: oc("gray", 9),
)


// Generate CSS custom properties for the configured theme.
// The site asset manifest writes this output to `assets/css/theme.css`.
#let render-theme-css(theme: none) = {
  let theme = if type(theme) == function {
    theme()
  } else if type(theme) == dictionary {
    theme
  } else {
    assert(false, message: strfmt(
      "expected theme function or dictionary, found {}",
      repr(type(theme))))
  }

  let defs = strfmt("  color-scheme: {};\n", theme.at("color-scheme", default: "light"))
  for (key, value) in theme {
    if key != "with" {
      defs += strfmt("  --jtd-{}: {};\n", key, str(value))
    }
  }
  strfmt(":root {{\n{}\n}}\n", defs)
}
