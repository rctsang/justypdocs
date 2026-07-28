#!/usr/bin/env python3
"""Black-box verification tests for justypdocs.

The tests compile the example sites and inspect generated HTML/assets. They are
intentionally stdlib-only and organized as small test functions so new checks can
be added by appending another `@test` function.
"""

from __future__ import annotations

import re
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


@dataclass
class Context:
    tmp: Path
    basic: Path
    custom: Path


TESTS = []


def test(fn):
    TESTS.append(fn)
    return fn


def run(cmd: list[str], *, root: Path = ROOT, expect_fail: bool = False) -> subprocess.CompletedProcess[str]:
    proc = subprocess.run(
        cmd,
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if expect_fail:
      if proc.returncode == 0:
          raise AssertionError(f"command unexpectedly passed: {' '.join(cmd)}")
    elif proc.returncode != 0:
        raise AssertionError(
            "command failed:\n"
            f"  {' '.join(cmd)}\n"
            f"stdout:\n{proc.stdout}\n"
            f"stderr:\n{proc.stderr}"
        )
    return proc


def compile_bundle(source: str, out: Path) -> None:
    if out.exists():
        shutil.rmtree(out)
    run([
        "typst", "compile",
        "--root", ".",
        "--features", "bundle,html",
        "--format", "bundle",
        source,
        str(out),
    ])


def compile_pdf(source: str, out: Path) -> None:
    if out.exists():
        out.unlink()
    run([
        "typst", "compile",
        "--root", ".",
        source,
        str(out),
    ])


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def assert_exists(path: Path) -> None:
    if not path.exists():
        raise AssertionError(f"missing expected path: {path}")


def assert_contains(text: str, needle: str, label: str) -> None:
    if needle not in text:
        raise AssertionError(f"missing {label}: {needle}")


def assert_not_contains(text: str, needle: str, label: str) -> None:
    if needle in text:
        raise AssertionError(f"unexpected {label}: {needle}")


def assert_regex(text: str, pattern: str, label: str) -> None:
    if not re.search(pattern, text):
        raise AssertionError(f"missing {label}: {pattern}")


def prepare() -> Context:
    tmp = Path(tempfile.mkdtemp(prefix="justypdocs-verify-"))
    ctx = Context(
        tmp=tmp,
        basic=tmp / "basic",
        custom=tmp / "custom",
    )

    # Package import smoke test setup: examples should exercise the installed
    # `@local/justypdocs:0.0.1` package, not source-relative imports.
    run(["python3", "install.py", "--link", "--force", "-y"])
    compile_bundle("examples/basic/site.typ", ctx.basic)
    compile_bundle("examples/custom/site.typ", ctx.custom)
    return ctx


@test
def examples_use_package_imports(ctx: Context) -> None:
    # Keep examples representative of package consumers by rejecting direct
    # imports from `src/lib.typ` and requiring the local package import.
    examples = list((ROOT / "examples").rglob("*.typ"))
    if not examples:
        raise AssertionError("no example Typst files found")

    direct_imports = []
    package_imports = []
    for path in examples:
        text = read(path)
        if "src/lib.typ" in text:
            direct_imports.append(path)
        if '@local/justypdocs:0.0.1' in text:
            package_imports.append(path)

    if direct_imports:
        raise AssertionError("examples import src/lib.typ directly: " + ", ".join(map(str, direct_imports)))
    if len(package_imports) != len(examples):
        raise AssertionError("not all examples import @local/justypdocs:0.0.1")


@test
def bundle_output_structure(ctx: Context) -> None:
    # Site generation is nav-driven. These paths prove the basic example emitted
    # every nav page plus shared CSS/JS/icon assets.
    expected = [
        "index.html",
        "guide/install.html",
        "guide/components.html",
        "reference/metadata.html",
        "demo/minimal.html",
        "assets/css/base.css",
        "assets/css/layout.css",
        "assets/css/navigation.css",
        "assets/css/content.css",
        "assets/css/components.css",
        "assets/css/theme.css",
        "assets/js/site.js",
        "assets/icons/symbols.svg",
        "assets/icons/flowbite.svg",
        "guide/assets/component-demo.css",
        "guide/assets/component-demo.js",
        "guide/assets/component-demo.svg",
        "assets/root-demo.css",
        "assets/root-demo.txt",
    ]
    for rel in expected:
        assert_exists(ctx.basic / rel)


@test
def default_layout_html(ctx: Context) -> None:
    # The default layout should render the documentation shell: sidebar title,
    # main-header mobile control, active nav, breadcrumbs, and page title. It
    # should not render the removed `.main-header-title` duplicate title.
    html = read(ctx.basic / "guide/install.html")
    assert_contains(html, 'class="side-bar"', "sidebar")
    assert_contains(html, 'class="site-title"', "sidebar site title")
    assert_contains(html, 'id="menu-button"', "main-header menu button")
    assert_contains(html, 'jtd-icon-menu', "menu icon")
    assert_contains(html, 'class="header-links"', "default header links")
    assert_contains(html, 'class="header-link header-link-icon"', "custom header link class")
    assert_contains(html, 'aria-label="GitHub"', "custom header link aria label")
    assert_contains(html, 'target="_blank"', "custom header link target")
    assert_contains(html, 'symbols.svg#external-link', "custom header link SVG content")
    assert_contains(html, '<a class="header-link" href="/reference/metadata.html">Reference</a>', "rooted header link")
    assert_not_contains(html, 'Skip to main content', "removed skip link")
    assert_not_contains(html, '<span class="site-button-label">Menu</span>', "visible menu button text")
    assert_contains(html, 'jtd-nav-link active', "active nav link")
    assert_contains(html, 'breadcrumb-nav-root', "breadcrumb root item")
    assert_contains(html, '<a href="/">Home</a>', "breadcrumb home link")
    assert_contains(html, 'Installing Justypdocs', "page title")
    assert_contains(html, '>Install</a>', "nav title")
    assert_contains(html, 'symbols.svg#chevron-right', "nav chevron symbol")
    assert_not_contains(html, 'main-header-title', "duplicate main-header title")


@test
def minimal_layout_html(ctx: Context) -> None:
    # Minimal layout keeps shared assets/content/breadcrumbs but must not include
    # nav-only chrome such as the sidebar, menu button, or main header title.
    html = read(ctx.basic / "demo/minimal.html")
    assert_contains(html, 'class="main-header main-header-minimal"', "minimal main header")
    assert_contains(html, 'jtd-page-minimal', "minimal page class")
    assert_contains(html, 'breadcrumb-nav-root', "minimal breadcrumb root")
    assert_contains(html, 'class="header-links"', "minimal header links")
    assert_not_contains(html, 'Skip to main content', "minimal removed skip link")
    assert_not_contains(html, 'class="side-bar"', "minimal sidebar")
    assert_not_contains(html, 'id="menu-button"', "minimal menu button")
    assert_not_contains(html, 'main-header-title', "minimal duplicate header title")


@test
def html_shell_asset_placement(ctx: Context) -> None:
    # Layouts own the HTML shell so shared styles live in <head> and shared
    # scripts load at the end of <body>, leaving room for page-specific assets.
    html = read(ctx.basic / "guide/install.html")
    head_start = html.index("<head>")
    head_end = html.index("</head>")
    body_start = html.index("<body>")
    body_end = html.rindex("</body>")
    css_pos = html.index('/assets/css/base.css')
    js_pos = html.index('/assets/js/site.js')
    main_pos = html.index('class="main"')
    assert head_start < css_pos < head_end < body_start
    assert body_start < main_pos < js_pos < body_end


@test
def page_asset_paths_and_tags(ctx: Context) -> None:
    html = read(ctx.basic / "guide/components.html")
    head_start = html.index("<head>")
    head_end = html.index("</head>")
    body_start = html.index("<body>")
    body_end = html.rindex("</body>")
    page_css_pos = html.index('href="assets/component-demo.css"')
    root_css_pos = html.index('href="/assets/root-demo.css"')
    page_js_pos = html.index('src="assets/component-demo.js"')
    shared_js_pos = html.index('/assets/js/site.js')
    main_pos = html.index('class="main"')
    assert head_start < page_css_pos < head_end < body_start
    assert head_start < root_css_pos < head_end < body_start
    assert body_start < main_pos < shared_js_pos < page_js_pos < body_end
    assert_not_contains(html, "/guide/assets/component-demo.css", "rooted page stylesheet URL")
    assert_contains(read(ctx.basic / "assets/root-demo.css"), "--component-root-demo", "root stylesheet contents")
    assert_contains(read(ctx.basic / "assets/root-demo.txt"), "Root-scoped asset fixture.", "root asset contents")
    assert_contains(read(ctx.basic / "guide/assets/component-demo.css"), ".component-demo-note", "page CSS asset contents")
    assert_contains(read(ctx.basic / "guide/assets/component-demo.js"), "componentDemo", "page JS asset contents")
    assert_contains(read(ctx.basic / "guide/assets/component-demo.svg"), "Component demo", "page raw asset contents")


@test
def flowbite_icon_output(ctx: Context) -> None:
    sprite = read(ctx.basic / "assets/icons/flowbite.svg")
    html = read(ctx.basic / "guide/components.html")
    assert_contains(html, "jtd.icon", "icon demo heading text")
    assert_contains(sprite, '<symbol id="flowbite-user-outline" viewBox="0 0 24 24">', "flowbite sprite symbol")
    assert_contains(sprite, 'stroke="currentColor"', "flowbite sprite currentColor")
    assert_contains(html, 'class="jtd-icon jtd-icon-flowbite-user-outline component-demo-icon"', "flowbite icon classes")
    assert_contains(html, 'role="img"', "flowbite icon role")
    assert_contains(html, 'aria-label="User"', "flowbite icon label")
    assert_contains(html, 'style="width: 1.25em; height: 1.25em;"', "flowbite icon sizing")
    assert_contains(html, 'href="/assets/icons/flowbite.svg#flowbite-user-outline"', "flowbite sprite href")
    assert_contains(html, '<inline-svg src="assets/component-demo.svg" class="component-demo-inline-svg" data-example="inline-svg-demo"></inline-svg>', "inline-svg demo markup")


@test
def layout_css_regressions(ctx: Context) -> None:
    # These checks protect visual layout fixes that are easier to assert in CSS:
    # section containers should not look selected, callouts should use a border
    # treatment instead of a darker fill, and sidebar title hover should be solid.
    layout = read(ctx.basic / "assets/css/layout.css")
    navigation = read(ctx.basic / "assets/css/navigation.css")
    components = read(ctx.basic / "assets/css/components.css")
    assert_not_contains(navigation, ".jtd-nav .active", "section-wide active selector")
    assert_contains(components, "background: transparent;", "transparent callout background")
    assert_contains(components, "border-color: var(--jtd-callout-color);", "highlight-colored callout border")
    assert_contains(components, "--jtd-button-hover-filter: brightness(0.96);", "darker default button hover")
    assert_contains(components, "--jtd-button-hover-filter: brightness(1.08);", "lighter solid button hover")
    assert_contains(layout, ".site-title:hover {\n  background: var(--jtd-feedback);", "solid title hover")
    assert_contains(layout, ".main:not(.main-minimal) {\n    margin-left: var(--jtd-nav-width);", "sidebar offset excludes minimal layout")
    assert_contains(layout, ".site-header {\n  display: flex;", "mobile sidebar header")
    assert_contains(layout, "list-style: none !important;", "unbulleted header links")
    assert_contains(layout, ".header-links-item + .header-links-item {\n  margin-top: 0;", "horizontal header link spacing")
    assert_contains(layout, "padding: 0 0.5rem;", "header link edge spacing")
    assert_contains(layout, ".header-links-item {\n  display: block;\n  margin: 0;\n  padding: 0;", "header list item reset")
    assert_not_contains(layout, "gap: var(--jtd-spacing-unit);", "header link hover gaps")
    assert_contains(layout, "@media (min-width: 66.5rem)", "sidebar appears at content plus nav width")
    assert_contains(layout, "margin-left: var(--jtd-nav-width);", "main starts after sidebar")
    assert_contains(layout, "margin-bottom: 32px;", "sidebar title spacing")
    assert_contains(layout, "font-size: 1.125rem;", "larger sidebar title")
    assert_contains(layout, ".site-button {\n  display: inline-flex;", "site button rule")
    assert_contains(layout, "margin-left: 0;", "menu button stays after header links")
    assert_contains(layout, "flex: 0 1 auto;", "header links stay right aligned before menu")
    assert_contains(layout, ".main-header-default {\n    display: none;", "default main header hidden on mobile")
    assert_contains(layout, ".side-bar .site-footer {\n    display: none;", "mobile sidebar footer hidden")
    assert_contains(layout, ".jtd-js .side-bar:not(.nav-open) > .header-links", "mobile sidebar header links collapsed")
    assert_contains(layout, ".header-link:hover {\n  background: var(--jtd-feedback);", "shaded header link hover")
    assert_contains(navigation, "font-weight: 600;", "bold active page link")
    assert_not_contains(navigation, ".jtd-nav-section-toggle:hover", "section header hover fill")


@test
def javascript_initializes_after_markup(ctx: Context) -> None:
    # Shared scripts are emitted before layout markup, so DOM-dependent behavior
    # must initialize after DOMContentLoaded. Otherwise nav section collapse and
    # mobile menu bindings silently miss their target elements.
    js = read(ctx.basic / "assets/js/site.js")
    assert_contains(js, "DOMContentLoaded", "deferred DOM initialization")
    assert_contains(js, "document.readyState", "ready-state guard")
    assert_contains(js, "is-collapsed", "section collapse class")
    assert_contains(js, 'customElements.define("inline-svg"', "inline-svg custom element")
    assert_contains(js, "var svgCache = new Map();", "inline-svg fetch cache")
    assert_contains(js, "svg.cloneNode(true)", "inline-svg cloned cached svg")


@test
def component_variants(ctx: Context) -> None:
    # Components expose visual options through existing `kind`/`variant` element
    # fields. The authored CSS and theme output should include representative
    # variants, and the example page should emit the expected variant classes.
    css = read(ctx.basic / "assets/css/components.css")
    theme = read(ctx.basic / "assets/css/theme.css")
    html = read(ctx.basic / "guide/components.html")
    for selector in [
        ".jtd-callout-warning",
        ".jtd-callout-danger",
        ".jtd-button-outline",
        ".jtd-button-green",
        ".jtd-label-yellow",
        ".jtd-image",
    ]:
        assert_contains(css, selector, f"component selector {selector}")
    for token in [
        "--jtd-component-blue:",
        "--jtd-component-green:",
        "--jtd-component-yellow:",
        "--jtd-theme-accent:",
        "--jtd-button-primary:",
    ]:
        assert_contains(theme, token, f"theme token {token}")
    assert_contains(css, "--jtd-callout-color: var(--jtd-theme-accent);", "accent default callout")
    assert_contains(css, "--jtd-button-fg: var(--jtd-theme-accent);", "accent default button foreground")
    assert_contains(css, "--jtd-label-bg: var(--jtd-theme-accent);", "accent default label")
    assert_contains(theme, "--jtd-theme-accent: #15aabf", "cyan accent color")
    assert_contains(theme, "--jtd-link: #15aabf", "cyan default link color")
    assert_contains(theme, "--jtd-button-primary: #15aabf", "cyan primary button color")
    for klass in [
        "jtd-callout-warning",
        "jtd-callout-danger",
        "jtd-button-outline",
        "jtd-button-green",
        "jtd-label-yellow",
    ]:
        assert_contains(html, klass, f"example class {klass}")
    assert_contains(html, '<img class="jtd-image component-demo-image" data-example="target-aware-image" src="assets/component-demo.svg" alt="Component demo graphic" style="width: 80%; object-fit: contain;">', "target-aware image html")
    assert_contains(html, 'id="jump-to-component-target"', "component custom id")
    assert_contains(html, 'class="jtd-button jtd-button-outline js-scroll-link"', "component custom class merged")
    assert_contains(html, 'data-scroll-to="component-target"', "component custom data attr")
    assert_contains(html, 'id="component-target"', "callout custom id")
    assert_contains(html, 'data-example="attribute-pass-through"', "callout custom data attr")


@test
def pdf_smoke_tests(ctx: Context) -> None:
    # Paged/PDF support is target-dispatched through Bullseye. These smoke tests
    # ensure representative pages compile without HTML site chrome or CSS assets.
    outputs = [
        ("examples/basic/pages/guide/components.typ", ctx.tmp / "components.pdf"),
        ("examples/basic/pages/home.typ", ctx.tmp / "home.pdf"),
    ]
    for source, out in outputs:
        compile_pdf(source, out)
        assert_exists(out)
        if out.stat().st_size == 0:
            raise AssertionError(f"empty generated PDF: {out}")


@test
def nested_path_asset_urls(ctx: Context) -> None:
    # Nested output pages must use base-url-rooted asset references, not fragile
    # relative paths like `../assets/...`.
    html = read(ctx.basic / "guide/install.html")
    for asset in [
        '/assets/css/base.css',
        '/assets/css/layout.css',
        '/assets/js/site.js',
        '/assets/icons/symbols.svg#chevron-right',
    ]:
        assert_contains(html, asset, f"rooted asset {asset}")
    assert_not_contains(html, '../assets/', "relative nested asset path")


@test
def custom_theme_override(ctx: Context) -> None:
    # The custom example proves theme token overrides flow into generated
    # `assets/css/theme.css` rather than only the default light theme.
    css = read(ctx.custom / "assets/css/theme.css")
    assert_contains(css, "color-scheme: dark", "dark color scheme")
    assert_contains(css, "--jtd-theme-accent: #9cdcfe", "custom accent color")
    assert_contains(css, "--jtd-link: #9cdcfe", "custom link color")
    assert_contains(css, "--jtd-button-primary: #9cdcfe", "custom primary color")
    assert_contains(css, "--jtd-feedback: #243447", "custom feedback color")


def typst_fixture(tmp: Path, name: str, body: str) -> Path:
    path = tmp / name
    path.write_text(body, encoding="utf-8")
    return path


@test
def validation_failures(ctx: Context) -> None:
    # These negative tests preserve the main user-facing validation guarantees:
    # duplicate nav ids, missing page ids, and unknown page ids fail clearly.
    dup = typst_fixture(ctx.tmp, "duplicate-id.typ", '''
#import "@local/justypdocs:0.0.1" as jtd
#let config = (title: "Duplicate", base-url: "/", theme: jtd.themes.light)
#let nav = (
  (id: "dup", title: "One", body: [One], path: "one.html"),
  (id: "dup", title: "Two", body: [Two], path: "two.html"),
)
#jtd.site(config: config, nav: nav)
''')
    missing = typst_fixture(ctx.tmp, "missing-id.typ", '''
#import "@local/justypdocs:0.0.1" as jtd
#show: jtd.page.with(title: "Missing ID")
= Missing ID
''')
    unknown_page = typst_fixture(ctx.tmp, "unknown-page.typ", '''
#import "@local/justypdocs:0.0.1" as jtd
#show: jtd.page.with(id: "unknown-page", title: "Unknown Page")
= Unknown Page
''')
    unknown_site = typst_fixture(ctx.tmp, "unknown-site.typ", f'''
#import "@local/justypdocs:0.0.1" as jtd
#let config = (title: "Unknown", base-url: "/", theme: jtd.themes.light)
#let nav = ((id: "known-page", title: "Known", body: include "{unknown_page}", path: "known.html"),)
#jtd.site(config: config, nav: nav)
''')

    checks = [
        (
            ["typst", "compile", "--root", "/", "--features", "bundle,html", "--format", "bundle", str(dup), str(ctx.tmp / "dup-out")],
            "duplicate nav node id",
        ),
        (
            ["typst", "compile", "--root", "/", "--features", "html", str(missing), str(ctx.tmp / "missing.html")],
            "missing required named field 'id'",
        ),
        (
            ["typst", "compile", "--root", "/", "--features", "bundle,html", "--format", "bundle", str(unknown_site), str(ctx.tmp / "unknown-out")],
            "no nav entry with id",
        ),
    ]
    for cmd, message in checks:
        proc = run(cmd, expect_fail=True)
        combined = proc.stdout + proc.stderr
        assert_contains(combined, message, f"validation message {message}")


def main() -> int:
    ctx = prepare()
    failures = []
    for fn in TESTS:
        name = fn.__name__
        try:
            fn(ctx)
            print(f"PASS {name}")
        except Exception as exc:  # noqa: BLE001 - keep script dependency-free.
            failures.append((name, exc))
            print(f"FAIL {name}: {exc}", file=sys.stderr)

    print(f"\nverified output in {ctx.tmp}")
    if failures:
        print("\nfailures:", file=sys.stderr)
        for name, exc in failures:
            print(f"- {name}: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
