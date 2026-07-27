// Page-scoped asset declarations.
//
// These elements are intended for use inside page files. Each declaration emits
// metadata that `jtd.site` uses for bundle `asset(...)` entries and HTML layouts
// use to place stylesheet/script tags in the document shell.

#import "@preview/elembic:1.1.1" as e
#import "types.typ": prefix

#let page-dir(path) = {
  if path == none or not path.contains("/") {
    return ""
  }

  let parts = path.split("/")
  parts.slice(0, parts.len() - 1).join("/")
}

#let root-url(page, path) = {
  let base = if "config" in page { page.config.base-url } else { "" }
  let path = path.slice(1)
  if base == "" {
    return path
  }

  let base = if base.ends-with("/") { base } else { base + "/" }
  base + path
}

#let asset-paths(path, page) = {
  if path.starts-with("/") {
    return (
      output: path.slice(1),
      url: root-url(page, path),
    )
  }

  let dir = page-dir(page.path)
  (
    output: if dir == "" { path } else { dir + "/" + path },
    url: path,
  )
}

#let current-page() = {
  let pages = query(selector(<jtd-current-page>).before(here()))
  if pages != () {
    return pages.last().value
  }

  let pages = query(selector(<jtd-page>).before(here()))
  if pages != () {
    return pages.last().value
  }

    panic("jtd page assets must be declared inside a jtd.page")
}

#let emit(kind, path, data) = context {
  let page = current-page()
  let paths = asset-paths(path, page)
  [
    #metadata((
      kind: "justypdocs-page-asset",
      asset-kind: kind,
      page-id: page.id,
      path: path,
      output-path: paths.output,
      url: paths.url,
      data: data,
    )) <jtd-page-asset>
  ]
}

#let declare(name, kind, doc) = e.element.declare(
  name,
  prefix: prefix,
  doc: doc,
  fields: (
    e.field("path", str, required: true, named: true,
      doc: "Output path. Leading slash targets the site root; otherwise page-relative."),
    e.field("data", e.types.any, required: true, named: true,
      doc: "Asset data, usually loaded with read(...)."),
  ),
  display: it => emit(kind, it.path, it.data),
)

#let asset = declare("asset", "asset", "Emits a page-scoped static asset.")
#let stylesheet = declare("stylesheet", "stylesheet", "Emits and links a page-scoped stylesheet.")
#let script = declare("script", "script", "Emits and links a page-scoped script.")
