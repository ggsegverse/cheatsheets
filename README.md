# ggsegverse cheatsheets

Quick-reference sheets for the [ggsegverse](https://ggsegverse.github.io)
brain-atlas plotting ecosystem.

Each sheet is written once as a Quarto document and rendered to two things:

- a two-page **PDF** laid out in three columns for printing, via a Typst
  format extension
- an accessible **HTML** page on the website

Every R example is executed at render time against the installed packages, so
a renamed function breaks the build rather than rotting quietly in a slide
deck.

| Sheet               | Covers                                                 |
| ------------------- | ------------------------------------------------------ |
| `ggseg.qmd`         | `geom_brain()`, view arrangement, palettes, themes     |
| `ggseg3d.qmd`       | `ggseg3d()`, cameras, surfaces, widget options, Shiny  |
| `ggseg-atlases.qmd` | installing atlases, `ggseg_atlas` objects, atlas verbs |

## Building

```bash
quarto render
```

That writes the website to `docs/`, copies the PDFs to `pdf/` and, where
ImageMagick has PDF support, page-one thumbnails to `pngs/`.

To work on one sheet:

```bash
quarto render ggseg.qmd --to cheatsheet-typst   # the PDF
quarto render ggseg.qmd --to html               # the web page
quarto preview                                  # the whole site, live
```

### Requirements

- Quarto 1.5 or newer (Typst is bundled)
- R, with `ggseg`, `ggseg3d`, `ggseg.formats` and `ggplot2` installed

Fonts are committed under `fonts/` and found through `font-paths`, so nothing
needs installing system-wide. `tools/get-fonts.sh` rebuilds them from upstream
Google Fonts; it needs `fonttools`. The upstream files are variable fonts and
Typst does not interpolate variable axes, so the script bakes out one static
file per weight.

## Writing a sheet

Heading levels drive the PDF layout:

| Markdown | Renders as                      |
| -------- | ------------------------------- |
| `#`      | dark banner, one per major part |
| `##`     | section bar                     |
| `###`    | subsection with a rule          |
| `####`   | run-in label                    |

Guidelines, mostly borrowed from the
[Posit cheatsheets](https://github.com/rstudio/cheatsheets):

- A cheatsheet is a visual reference, not documentation. Prefer a short
  working example to a paragraph.
- Keep code lines under about 45 characters. Columns are narrow and Typst
  wraps long lines without indenting them.
- Set `execute: output: false` in the front matter and turn output back on
  per chunk with `#| output: true` where a figure earns its place.
- Give figures `fig-width: 3.3` so they fill a column.
- Use `#| eval: false` for code that needs something not installed in CI.
- Wrap HTML-only content in `::: {.content-visible when-format="html"}`.

## Layout

```
_extensions/ggsegverse/cheatsheet/   Typst format extension
_brand.yml                           ggsegverse colours and fonts
_metadata.yml                        sheet-* options read by the template
fonts/                               static font instances
images/                              logos
tools/get-fonts.sh                   rebuild fonts/
tools/collect-pdfs.R                 post-render: PDFs and thumbnails
```

## Licence

Content is [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
The bundled fonts (Montserrat, Source Serif 4, Fira Code) are under the SIL
Open Font License; their licences are in `fonts/`.
