// Theme token definitions.
//
// Built-in themes are functions so users can customize them with Typst's
// built-in function `.with(...)` support, e.g. `jtd.themes.light.with(link: ...)`.
// Later asset generation should call the configured theme function to obtain
// the concrete token dictionary.

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
  nav-width: "16.5rem",
  content-width: "50rem",
  header-height: "3.75rem",
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
  nav-width: nav-width,
  content-width: content-width,
  header-height: header-height,
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
)

// Convert a configured theme function or raw dictionary into concrete tokens.
#let tokens(theme) = if type(theme) == function {
  theme()
} else if type(theme) == dictionary {
  theme
} else {
  assert(false, message: "justypdocs.theme: expected theme function or dictionary, found " + repr(type(theme)))
}

// Generate CSS custom properties for the configured theme.
#let render-theme-css(theme) = {
  let theme = tokens(theme)
  let css = ":root {\n"
  for (key, value) in theme {
    if key != "with" {
      css += "  --jtd-" + key + ": " + str(value) + ";\n"
    }
  }
  css += "}\n"
  css
}
