sheet_name <- function() {
  tools::file_path_sans_ext(basename(knitr::current_input()))
}

# Emitted unconditionally rather than guarded by file.exists(): the thumbnail
# is written by tools/collect-pdfs.R after the render, and this chunk's output
# is frozen, so a guard would stick at "missing" from the first ever build.
pdf_download_link <- function(sheet = sheet_name()) {
  cat(sprintf(
    paste0(
      '<a href="%s.pdf" class="sheet-pdf-link">',
      '<p>Download PDF</p>',
      '<img src="pngs/%s.png" width="240" alt="" />',
      "</a>\n\n"
    ),
    sheet,
    sheet
  ))
}
