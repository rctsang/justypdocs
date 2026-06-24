// Static asset emission helpers.

#import "theme.typ"

// Emit authored CSS/JS assets and generated theme CSS.
#let emit-assets(config) = {
  asset("assets/css/base.css", read("../assets/css/base.css"))
  asset("assets/css/layout.css", read("../assets/css/layout.css"))
  asset("assets/css/navigation.css", read("../assets/css/navigation.css"))
  asset("assets/css/content.css", read("../assets/css/content.css"))
  asset("assets/css/components.css", read("../assets/css/components.css"))
  asset("assets/css/theme.css", theme.render-theme-css(theme: config.theme))
  asset("assets/js/site.js", read("../assets/js/site.js"))
}
