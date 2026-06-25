// Static asset manifest.
// `jtd.site` emits every entry into the bundle, and layouts use the same
// manifest to link the authored CSS/JS files plus generated theme CSS.

#import "theme.typ"

// Enumerate required asset data.
#let manifest(config) = (
  (
    path: "assets/css/base.css",
    data: read("../assets/css/base.css"),
  ),
  (
    path: "assets/css/layout.css",
    data: read("../assets/css/layout.css"),
  ),
  (
    path: "assets/css/navigation.css",
    data: read("../assets/css/navigation.css"),
  ),
  (
    path: "assets/css/content.css",
    data: read("../assets/css/content.css"),
  ),
  (
    path: "assets/css/components.css",
    data: read("../assets/css/components.css"),
  ),
  (
    path: "assets/css/theme.css",
    data: theme.render-theme-css(theme: config.theme),
  ),
  (
    path: "assets/js/site.js",
    data: read("../assets/js/site.js"),
  ),
)
