#!/usr/bin/env bash
# Rebuild fonts/ from upstream Google Fonts sources.
#
# The upstream files are variable fonts. Typst does not interpolate variable
# axes, so it renders every weight at the font's default instance (Montserrat
# Thin). Each weight is therefore baked out to a static instance here, and the
# results are committed so rendering the cheatsheets needs only Quarto.
#
# Requires: curl, fonttools (pip install fonttools / brew install fonttools)

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="$root/fonts"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$out"

fetch() {
  curl -sfLo "$tmp/$1" "https://raw.githubusercontent.com/google/fonts/main/$2"
}

instance() {
  fonttools varLib.instancer --update-name-table "$tmp/$1" "${@:3}" -o "$out/$2" >/dev/null 2>&1
}

fetch Montserrat.ttf 'ofl/montserrat/Montserrat%5Bwght%5D.ttf'
fetch SourceSerif4.ttf 'ofl/sourceserif4/SourceSerif4%5Bopsz,wght%5D.ttf'
fetch FiraCode.ttf 'ofl/firacode/FiraCode%5Bwght%5D.ttf'

instance Montserrat.ttf Montserrat-Regular.ttf wght=400
instance Montserrat.ttf Montserrat-SemiBold.ttf wght=600
instance Montserrat.ttf Montserrat-Bold.ttf wght=700

instance SourceSerif4.ttf SourceSerif4-Regular.ttf wght=400
instance SourceSerif4.ttf SourceSerif4-SemiBold.ttf wght=600
instance SourceSerif4.ttf SourceSerif4-Bold.ttf wght=700

instance FiraCode.ttf FiraCode-Regular.ttf wght=400
instance FiraCode.ttf FiraCode-SemiBold.ttf wght=600
instance FiraCode.ttf FiraCode-Bold.ttf wght=700

curl -sfLo "$out/OFL-Montserrat.txt" \
  "https://raw.githubusercontent.com/google/fonts/main/ofl/montserrat/OFL.txt"
curl -sfLo "$out/OFL-SourceSerif4.txt" \
  "https://raw.githubusercontent.com/google/fonts/main/ofl/sourceserif4/OFL.txt"
curl -sfLo "$out/OFL-FiraCode.txt" \
  "https://raw.githubusercontent.com/google/fonts/main/ofl/firacode/OFL.txt"

echo "Fonts written to $out"
quarto typst fonts --font-path "$out" --ignore-system-fonts
