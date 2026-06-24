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
)


// Generate CSS custom properties for the configured theme.
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
