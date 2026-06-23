#import "../../src/lib.typ" as jtd

#let config = (
  title: "Justypdocs Example",
  description: "A basic justypdocs example site.",
  base-url: "/",
  footer: [Built with justypdocs],
  theme: jtd.themes.light,
)

#let nav = (
  (
    id: "home",
    title: "Home",
    src: "/examples/basic/pages/home.typ",
    path: "index.html",
  ),
  (
    id: "guide",
    title: "Guide",
    children: (
      (
        id: "guide-install",
        title: "Install",
        src: "/examples/basic/pages/guide/install.typ",
        path: "guide/install.html",
      ),
    ),
  ),
)

#jtd.site(config: config, nav: nav)
