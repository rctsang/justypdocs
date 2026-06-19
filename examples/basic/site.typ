#import "../../src/lib.typ" as jtd

#let config = (
  title: "Justypdocs Example",
  description: "A basic justypdocs example site.",
  base-url: "/",
  footer: [Built with justypdocs],
)

#let nav = (
  (
    id: "home",
    title: "Home",
    src: "pages/home.typ",
    path: "index.html",
  ),
  (
    id: "guide",
    title: "Guide",
    children: (
      (
        id: "guide-install",
        title: "Install",
        src: "pages/guide/install.typ",
        path: "guide/install.html",
      ),
    ),
  ),
)

// TODO: Enable once jtd.site(...) is implemented.
// #jtd.site(config: config, nav: nav)
