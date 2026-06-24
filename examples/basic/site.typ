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
      (
        id: "guide-components",
        title: "Components",
        src: "/examples/basic/pages/guide/components.typ",
        path: "guide/components.html",
      ),
    ),
  ),
  (
    id: "reference",
    title: "Reference",
    children: (
      (
        id: "reference-metadata",
        title: "Metadata",
        src: "/examples/basic/pages/reference/metadata.typ",
        path: "reference/metadata.html",
      ),
    ),
  ),
  (
    id: "demo",
    title: "Demos",
    children: (
      (
        id: "demo-minimal",
        title: "Minimal layout",
        src: "/examples/basic/pages/demo/minimal.typ",
        path: "demo/minimal.html",
      ),
    ),
  ),
)

#jtd.site(config: config, nav: nav)
