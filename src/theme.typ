#import "@preview/oxifmt:1.0.0": strfmt

// Theme token definitions.
//
// Built-in themes are functions so users can customize them with Typst's
// built-in function `.with(...)` support, e.g. `jtd.themes.light.with(link: ...)`.
// The returned dictionary is converted to CSS custom properties in
// `assets/css/theme.css` as `--jtd-{token-name}`.
//
// Core color tokens:
// - `body-background`, `body-heading`, `body-text`, `link`, `sidebar`, `border`
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
  body-background: "#fff",
  body-heading: "#27262b",
  body-text: "#5c5962",
  link: "#7253ed",
  sidebar: "#f5f6fa",
  border: "#eeebee",
  code-background: "#fff",
  table-background: "#fff",
  base-button: "#f7f7f7",
  feedback: "#eeebee",
  component-blue: "#2f80ed",
  component-green: "#038761",
  component-purple: "#7253ed",
  component-red: "#dd2e44",
  component-yellow: "#f7c948",
  component-yellow-text: "#27262b",
  component-white: "#fff",
  button-primary: "#7253ed",
  nav-width: "16.5rem",
  content-width: "50rem",
  header-height: "3.75rem",
  border-radius: "4px",
  spacing-unit: "1rem",
  ..tokens,
) = (
  color-scheme: color-scheme,
  body-background: body-background,
  body-heading: body-heading,
  body-text: body-text,
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
) + tokens.named()

#let dark = light.with(
  color-scheme: "dark",
  body-background: "#27262b",
  body-heading: "#f5f6fa",
  body-text: "#e6e1e8",
  link: "#5ca0fb",
  sidebar: "#27262b",
  border: "#44434d",
  code-background: "#0d1117",
  table-background: "#302d36",
  base-button: "#302d36",
  feedback: "#302d36",
  component-blue: "#5ca0fb",
  component-green: "#41c78a",
  component-purple: "#a78bfa",
  component-red: "#ff6b6b",
  component-yellow: "#f4d35e",
  component-yellow-text: "#27262b",
  button-primary: "#5ca0fb",
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
