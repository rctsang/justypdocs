#import "../../../../src/lib.typ" as jtd

#show: jtd.page.with(
  id: "demo-minimal",
  title: "Minimal Layout Demo",
  layout: "minimal",
  description: "A page that demonstrates the minimal layout shell.",
  tags: ("minimal", "layout"),
  categories: ("demos",),
)

= Minimal Layout

This page intentionally uses the `minimal` layout. It keeps shared assets, typography, breadcrumbs, and content styling, but omits the sidebar navigation.
