// Shared layout helpers.

#import "../assets.typ"

#let classes(..items) = {
  items.pos()
    .filter(item => item != none and item != "")
    .join(" ")
}

#let base-url(ctx) = if ctx != none {
  ctx.config.base-url
} else { "" }

#let rooted-url(ctx, path) = {
  let base = base-url(ctx)
  if base == "" {
    return path
  }

  let base = if base.ends-with("/") { base } else { base + "/" }
  let path = if path.starts-with("/") { path.slice(1) } else { path }
  base + path
}

#let asset-config(ctx) = if ctx != none {
  ctx.config
} else {
  (theme: (:))
}

#let shared-assets(ctx) = [
  #for item in assets.manifest(asset-config(ctx)) {
    if item.path.ends-with(".css") {
      html.elem("link", attrs: (rel: "stylesheet", href: rooted-url(ctx, item.path)))
    } else if item.path.ends-with(".js") {
      html.elem("script", attrs: (src: rooted-url(ctx, item.path)))[]
    }
  }
]

#let page-href(ctx, path) = rooted-url(ctx, path)

#let site-title(ctx) = if ctx != none {
  ctx.config.title
} else { "" }

#let site-footer(ctx) = if ctx != none and ctx.config.footer != none {
  ctx.config.footer
} else { none }
