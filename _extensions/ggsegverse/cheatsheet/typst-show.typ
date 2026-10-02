#show: doc => cheatsheet(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(by-author)$
  author: [$for(by-author)$$it.name.literal$$sep$, $endfor$],
$endif$
$if(sheet-version)$
  sheet-version: [$sheet-version$],
$endif$
$if(sheet-url)$
  url: [$sheet-url$],
$endif$
$if(sheet-license)$
  license: [$sheet-license$],
$endif$
$if(sheet-logo)$
  logo-path: [$sheet-logo$],
$endif$
$if(sheet-columns)$
  cols: $sheet-columns$,
$endif$
$if(sheet-base-size)$
  base-size: $sheet-base-size$,
$endif$
$if(sheet-primary)$
  primary: rgb("#$sheet-primary$"),
$endif$
$if(sheet-secondary)$
  secondary: rgb("#$sheet-secondary$"),
$endif$
$if(sheet-accent)$
  accent: rgb("#$sheet-accent$"),
$endif$
$if(sheet-muted)$
  muted: rgb("#$sheet-muted$"),
$endif$
$if(sheet-surface)$
  surface: rgb("#$sheet-surface$"),
$endif$
$if(sheet-foreground)$
  fg: rgb("#$sheet-foreground$"),
$endif$
$if(sheet-body-font)$
  body-font: "$sheet-body-font$",
$endif$
$if(sheet-heading-font)$
  head-font: "$sheet-heading-font$",
$endif$
$if(sheet-mono-font)$
  mono-font: "$sheet-mono-font$",
$endif$
  doc,
)
