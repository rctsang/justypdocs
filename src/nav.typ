// Navigation traversal and lookup helpers.
//
// Helpers operate on the custom recursive `types.nav` value. They accept raw
// nav arrays as a convenience and cast them through `types.nav` first.

#import "@preview/elembic:1.1.1" as e
#import "types.typ"

#let normalized(nav) = {
  let (ok, value) = e.types.cast(nav, types.nav)
  assert(ok, message: "justypdocs.nav: invalid nav: " + repr(value))
  value
}

#let _nodes(nav) = normalized(nav).nodes

#let _pages-from-nodes(nodes) = {
  let pages = ()
  for node in nodes {
    if "children" in node {
      pages += _pages-from-nodes(node.children)
    } else {
      pages.push(node)
    }
  }
  pages
}

// Return all page nodes in site/nav order.
#let pages-from-nav(nav) = _pages-from-nodes(_nodes(nav))

#let _entry-by-id(id, nodes, trail: ()) = {
  for node in nodes {
    let next-trail = trail + (node.id,)

    if node.id == id {
      return (entry: node, trail: next-trail)
    }

    if "children" in node {
      let found = _entry-by-id(id, node.children, trail: next-trail)
      if found != none {
        return found
      }
    }
  }

  none
}

// Look up a page or section node by id.
// Returns `(entry: node, trail: ids)`, where `trail` contains only nav ids from
// the root to the matched node.
#let entry-by-id(id, nav) = {
  let found = _entry-by-id(id, _nodes(nav))
  assert(found != none, message: "justypdocs.nav: no nav entry with id " + repr(id))
  found
}

// Internal bundle document emission helper used by `jtd.site`.
#let emit-documents(nav) = {
  for page in pages-from-nav(nav) {
    document(page.path)[
      #metadata((kind: "jtd-current-page", id: page.id))
      #include page.src
    ]
  }
}
