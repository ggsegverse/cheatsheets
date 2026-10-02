// ggsegverse cheatsheet format
//
// Multi-column reference sheet in the style of the Posit cheatsheets, built on
// the ggsegverse brand. Heading levels map to layout:
//   #   part banner (one per sheet page)
//   ##  section bar
//   ### subsection
//   #### run-in label

#let luminance(c) = {
  let comps = c.components()
  let linearize(v) = {
    let x = v / 100%
    if x <= 0.03928 { x / 12.92 } else { calc.pow((x + 0.055) / 1.055, 2.4) }
  }
  (
    0.2126 * linearize(comps.at(0))
      + 0.7152 * linearize(comps.at(1))
      + 0.0722 * linearize(comps.at(2))
  )
}

#let contrast-ratio(c1, c2) = {
  let l1 = calc.max(luminance(c1), luminance(c2))
  let l2 = calc.min(luminance(c1), luminance(c2))
  (l1 + 0.05) / (l2 + 0.05)
}

#let ensure-contrast(fg, bg, min-ratio: 4.5) = {
  if contrast-ratio(fg, bg) >= min-ratio { fg }
  else if luminance(bg) > 0.5 { fg.darken(45%) }
  else { fg.lighten(55%) }
}

// Palette shared between the template function and the Skylighting override
// below. Pandoc emits highlighted code as `Skylighting(..)` wrapping inline
// `raw()` tokens, not as a raw block, so the code-block styling has to live in
// a redefinition of that function rather than in a `show raw` rule.

#let cs-theme = state("cs-theme", (
  surface: rgb("#f2f0ef"),
  accent: rgb("#a8c5cb"),
  mono-font: "Fira Code",
  code-size: 6.7pt,
))

#let Skylighting(fill: none, number: false, start: 1, sourcelines) = context {
  let t = cs-theme.get()
  let lines = []
  for ln in sourcelines {
    lines = lines + ln + raw("\n")
  }
  block(
    width: 100%,
    fill: t.surface,
    stroke: (left: 2pt + t.accent),
    radius: (right: 2.5pt),
    inset: (x: 5pt, y: 4.5pt),
    above: 5pt,
    below: 7pt,
    breakable: false,
    {
      // tokens are inline raw; cancel the inline-code box styling inside here
      show raw.where(block: false): it => it
      // Fira Code renders `|>` as a single arrow glyph through `calt`;
      // turned off so R code reads as it is typed.
      set text(font: t.mono-font, size: t.code-size, features: ("calt": 0))
      set par(leading: 0.5em, justify: false, spacing: 0.5em)
      lines
    },
  )
}

#let cheatsheet(
  title: none,
  subtitle: none,
  author: none,
  sheet-version: none,
  url: none,
  license: "CC BY-SA 4.0",
  logo-path: none,
  cols: 3,
  base-size: 7.6pt,
  primary: rgb("#29393e"),
  secondary: rgb("#5e3c58"),
  accent: rgb("#a8c5cb"),
  muted: rgb("#cec4cc"),
  surface: rgb("#f2f0ef"),
  fg: rgb("#1a2a2e"),
  body-font: "Source Serif 4",
  head-font: "Montserrat",
  mono-font: "Fira Code",
  doc,
) = {
  cs-theme.update((
    surface: surface,
    accent: accent,
    mono-font: mono-font,
    code-size: base-size - 0.9pt,
  ))

  // `url` and `logo-path` arrive as content, not strings: Pandoc escapes
  // metadata values for markdown, so "a_b.png" would reach a string parameter
  // as "a\_b.png". Converting from content strips the escapes.
  let url-str = if url != none { content-to-string(url) } else { none }
  let logo-str = if logo-path != none { content-to-string(logo-path) } else { none }

  set document(
    title: if title != none { content-to-string(title) } else { "ggsegverse cheatsheet" },
    author: if author != none { content-to-string(author) } else { "" },
  )

  // `fill` and `background` are set explicitly because Quarto emits a
  // top-level `set page(fill: ..., background: <brand logo>)` from _brand.yml
  // before this template runs; without these the brand submark is stamped on
  // every sheet as a watermark.
  set page(
    paper: "a4",
    flipped: true,
    margin: (x: 1cm, top: 1cm, bottom: 1.15cm),
    columns: cols,
    fill: white,
    background: none,
    numbering: none,
    footer: context {
      line(length: 100%, stroke: 0.6pt + accent)
      v(2.5pt)
      grid(
        columns: (1fr, auto, 1fr),
        align: (left + horizon, center + horizon, right + horizon),
        text(size: 6.2pt, fill: primary, weight: 600, font: head-font)[
          #if title != none { title }
        ],
        text(size: 6.2pt, fill: luma(110))[
          #license
          #if author != none [ · #author ]
          #if sheet-version != none [ · #sheet-version ]
        ],
        text(size: 6.2pt, fill: luma(110))[
          #if url-str != none [ #link(url-str)[#url-str.replace("https://", "")] · ]
          #counter(page).display("1 / 1", both: true)
        ],
      )
    },
  )

  set text(
    font: body-font,
    size: base-size,
    fill: fg,
    lang: "en",
    hyphenate: false,
  )
  set par(justify: false, leading: 0.55em, spacing: 0.72em)

  set list(indent: 2pt, body-indent: 4pt, spacing: 0.62em, tight: true)
  set enum(indent: 2pt, body-indent: 4pt, spacing: 0.62em, tight: true)
  show list: set block(spacing: 0.7em)

  // --- headings -------------------------------------------------------------

  show heading: set block(breakable: false)
  set heading(numbering: none, outlined: false)

  show heading.where(level: 1): it => block(
    width: 100%,
    fill: primary,
    radius: 2.5pt,
    inset: (x: 6pt, y: 5pt),
    above: 12pt,
    below: 7pt,
    text(
      font: head-font,
      size: base-size + 2.6pt,
      weight: 700,
      fill: ensure-contrast(surface, primary),
      it.body,
    ),
  )

  show heading.where(level: 2): it => block(
    width: 100%,
    fill: accent.lighten(35%),
    stroke: (left: 2.5pt + primary),
    radius: (right: 2.5pt),
    inset: (x: 5pt, y: 3.5pt),
    above: 11pt,
    below: 6pt,
    text(
      font: head-font,
      size: base-size + 1.1pt,
      weight: 600,
      fill: primary,
      it.body,
    ),
  )

  show heading.where(level: 3): it => block(
    width: 100%,
    above: 9pt,
    below: 4.5pt,
    stack(
      text(font: head-font, size: base-size + 0.2pt, weight: 600, fill: secondary, it.body),
      v(2pt),
      line(length: 100%, stroke: 0.5pt + muted),
    ),
  )

  show heading.where(level: 4): it => block(
    above: 7pt,
    below: 3pt,
    text(font: head-font, size: base-size - 0.4pt, weight: 600, fill: fg, it.body),
  )

  // --- code -----------------------------------------------------------------

  // Inline code is emitted by Pandoc as the same `raw()` tokens that make up
  // highlighted code blocks, so it cannot be given a box or background here --
  // the rule would also fire on every token inside a block, and a boxed
  // newline token stops breaking the line. Only the font is set.
  show raw: set text(
    font: mono-font,
    size: base-size - 0.9pt,
    features: ("calt": 0),
  )

  show raw.where(block: true): it => block(
    width: 100%,
    fill: surface,
    stroke: (left: 2pt + accent),
    radius: (right: 2.5pt),
    inset: (x: 5pt, y: 4.5pt),
    above: 5pt,
    below: 7pt,
    breakable: false,
    it,
  )

  // --- blocks ---------------------------------------------------------------

  show link: set text(fill: secondary)
  show strong: set text(fill: primary, weight: 700)

  show quote: it => block(
    width: 100%,
    fill: muted.lighten(65%),
    stroke: (left: 2pt + secondary),
    radius: (right: 2.5pt),
    inset: (x: 5pt, y: 4pt),
    above: 6pt,
    below: 7pt,
    it.body,
  )

  set table(stroke: none, inset: (x: 4pt, y: 2.6pt))
  show table.cell.where(y: 0): set text(
    font: head-font,
    weight: 600,
    size: base-size - 0.6pt,
    fill: primary,
  )
  show table: it => block(above: 5pt, below: 7pt, it)

  show figure: set block(breakable: false, above: 6pt, below: 8pt)
  show figure.caption: set text(size: base-size - 1.2pt, fill: luma(110))
  set image(width: 100%)

  // --- title banner ---------------------------------------------------------

  place(
    top,
    scope: "parent",
    float: true,
    block(width: 100%, below: 10pt)[
      #grid(
        columns: (1fr, auto),
        column-gutter: 12pt,
        align: (bottom + left, bottom + right),
        [
          #text(font: head-font, size: 18pt, weight: 700, fill: primary, title)
          #if subtitle != none [
            #v(2.5pt)
            #text(font: body-font, size: 8.4pt, fill: luma(95), subtitle)
          ]
        ],
        if logo-str != none { image(logo-str, height: 26pt, width: auto) },
      )
      #v(4pt)
      #line(length: 100%, stroke: 2.5pt + primary)
    ],
  )

  doc
}
