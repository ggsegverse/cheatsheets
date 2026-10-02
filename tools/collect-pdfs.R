#!/usr/bin/env Rscript

# Post-render step: copy the rendered cheatsheet PDFs out of the website output
# into pdf/, and write a page-one thumbnail into pngs/ for each one.
#
# Thumbnails use poppler's pdftoppm when it is on the path, falling back to a
# magick build with PDF (Ghostscript) support. Where neither is available the
# PDFs are still collected and only the thumbnails are skipped.

output_dir <- Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR", "docs")
pdf_dir <- "pdf"
png_dir <- "pngs"
thumb_width <- 1100

pdfs <- list.files(output_dir, pattern = "\\.pdf$", full.names = TRUE)
pdfs <- pdfs[basename(pdfs) != "index.pdf"]

if (length(pdfs) == 0) {
  message("collect-pdfs: no cheatsheet PDFs in ", output_dir)
  quit(save = "no")
}

dir.create(pdf_dir, showWarnings = FALSE)
file.copy(pdfs, file.path(pdf_dir, basename(pdfs)), overwrite = TRUE)
message("collect-pdfs: copied ", length(pdfs), " PDF(s) to ", pdf_dir, "/")

pdftoppm <- Sys.which("pdftoppm")

has_magick_pdf <- requireNamespace("magick", quietly = TRUE) &&
  "pdf" %in% tolower(magick::magick_config()$delegates)

if (!nzchar(pdftoppm) && !has_magick_pdf) {
  message(
    "collect-pdfs: no pdftoppm and no PDF-capable magick, ",
    "skipping thumbnails"
  )
  quit(save = "no")
}

dir.create(png_dir, showWarnings = FALSE)

thumbnail <- function(pdf, out) {
  if (nzchar(pdftoppm)) {
    system2(
      pdftoppm,
      c(
        "-png",
        "-f",
        "1",
        "-l",
        "1",
        "-singlefile",
        "-scale-to-x",
        thumb_width,
        "-scale-to-y",
        "-1",
        shQuote(pdf),
        shQuote(tools::file_path_sans_ext(out))
      )
    )
  } else {
    img <- magick::image_read_pdf(pdf, pages = 1, density = 150)
    img <- magick::image_background(
      magick::image_resize(img, paste0(thumb_width, "x")),
      "white"
    )
    magick::image_write(img, out)
  }
}

site_png_dir <- file.path(output_dir, png_dir)
dir.create(site_png_dir, showWarnings = FALSE)

for (pdf in pdfs) {
  sheet <- tools::file_path_sans_ext(basename(pdf))
  out <- file.path(png_dir, paste0(sheet, ".png"))
  thumbnail(pdf, out)
  # The HTML pages link to pngs/ relative to themselves, so the site needs
  # its own copy; docs/ is wiped on a clean render.
  file.copy(out, file.path(site_png_dir, basename(out)), overwrite = TRUE)
  message("collect-pdfs: thumbnail for ", sheet)
}
