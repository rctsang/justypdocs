#import "@local/justypdocs:0.0.1" as jtd

// Build this example with:
// typst compile --root "." --features bundle,html --format bundle examples/custom/site.typ dist-custom

#let config = (
  title: "Justypdocs Custom Theme",
  description: "A custom-theme justypdocs example site.",
  base-url: "/",
  footer: [Custom theme example],
  theme: jtd.themes.dark.with(
    link: "#9cdcfe",
    feedback: "#243447",
  ),
)

#let nav = (
  (
    id: "custom-home",
    title: "Custom Theme",
    src: "/examples/custom/pages/home.typ",
    path: "index.html",
  ),
)

#jtd.site(config: config, nav: nav)
