#!/usr/bin/env bash
#
# md-to-pdf.sh — converte un file Markdown in PDF seguendo lo stile dei
# documenti tecnici DGA (headless Chrome, Ubuntu Sans, palette navy/oro).
#
# Uso:
#   .scripts/md-to-pdf.sh <input.md> [output.pdf]
#
# Opzioni (env):
#   HEADER_LEFT   testo header sinistro (default: "DGA S.p.A.")
#   HEADER_RIGHT  testo header destro   (default: "Portale dga.it")
#   TITLE         titolo documento      (default: primo H1 del markdown, o nome file)
#   CHROME_BIN    binario Chrome/Chromium da usare
#
set -euo pipefail

usage() {
    sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
    exit "${1:-0}"
}

if [[ $# -lt 1 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage 0
fi

INPUT="$1"
OUTPUT="${2:-}"

if [[ ! -f "$INPUT" ]]; then
    echo "Errore: file non trovato: $INPUT" >&2
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    echo "Errore: python3 non trovato." >&2
    exit 1
fi

if ! python3 -c 'import markdown' >/dev/null 2>&1; then
    echo "Errore: modulo Python 'markdown' mancante (pip install markdown)." >&2
    exit 1
fi

INPUT_ABS="$(readlink -f "$INPUT")"
if [[ -z "$OUTPUT" ]]; then
    OUTPUT="${INPUT_ABS%.*}.pdf"
fi
OUTPUT_DIR="$(dirname "$OUTPUT")"
mkdir -p "$OUTPUT_DIR"
OUTPUT_ABS="$(readlink -f "$OUTPUT_DIR")/$(basename "$OUTPUT")"

HEADER_LEFT="${HEADER_LEFT:-DGA S.p.A.}"
HEADER_RIGHT="${HEADER_RIGHT:-Portale dga.it}"
TITLE="${TITLE:-}"

python3 - "$INPUT_ABS" "$OUTPUT_ABS" "$HEADER_LEFT" "$HEADER_RIGHT" "$TITLE" "${CHROME_BIN:-}" <<'PY'
import html
import pathlib
import shutil
import subprocess
import sys

import markdown

md_path = pathlib.Path(sys.argv[1])
out_pdf = pathlib.Path(sys.argv[2])
header_left = sys.argv[3]
header_right = sys.argv[4]
title_arg = sys.argv[5]
chrome_arg = sys.argv[6]

CSS = """
@page {
  size: A4;
  margin: 11mm 16mm 10mm 16mm;

  @top-left {
    content: "__HEADER_LEFT__";
    font-family: "Ubuntu Sans", sans-serif;
    font-size: 8.5pt;
    color: #6B7280;
    vertical-align: bottom;
    padding-bottom: 3mm;
  }
  @top-right {
    content: "__HEADER_RIGHT__";
    font-family: "Ubuntu Sans", sans-serif;
    font-size: 8.5pt;
    color: #6B7280;
    vertical-align: bottom;
    padding-bottom: 3mm;
  }
  @bottom-center {
    content: "Pagina " counter(page) " di " counter(pages);
    font-family: "Ubuntu Sans", sans-serif;
    font-size: 8.5pt;
    color: #6B7280;
    vertical-align: top;
    padding-top: 4mm;
  }
}

@page :first {
  @top-left { content: none; }
  @top-right { content: none; }
}

* { box-sizing: border-box; }

html {
  -webkit-print-color-adjust: exact;
  print-color-adjust: exact;
}

body {
  font-family: "Ubuntu Sans", "DejaVu Sans", sans-serif;
  font-size: 10.5pt;
  line-height: 1.5;
  color: #1F2937;
  margin: 0;
}

h1 {
  color: #1F4E79;
  font-size: 20pt;
  font-weight: 700;
  line-height: 1.2;
  border-bottom: 2.5px solid #B8860B;
  padding-bottom: 8px;
  margin: 0 0 22px;
}

h2 {
  color: #1F4E79;
  font-size: 13.5pt;
  font-weight: 700;
  line-height: 1.25;
  border-bottom: 1px solid #D1D5DB;
  padding-bottom: 5px;
  margin: 24px 0 12px;
  break-after: avoid;
}

h3 {
  color: #1F4E79;
  font-size: 11pt;
  font-weight: 700;
  margin: 18px 0 8px;
  break-after: avoid;
}

h1:first-child { margin-top: 0; }

p { margin: 0 0 10px; }

strong { color: #1F4E79; font-weight: 700; }
em { font-style: italic; }

a { color: #1F4E79; text-decoration: none; }

ul, ol { margin: 0 0 12px; padding-left: 22px; }
li { margin: 0 0 5px; }
li > ul, li > ol { margin-top: 5px; margin-bottom: 0; }
li::marker { color: #1F2937; }

code {
  font-family: "Courier New", "DejaVu Sans Mono", monospace;
  font-size: 9.5pt;
  color: #B8860B;
  background: #F5F0E1;
  padding: 1px 4px;
  border-radius: 2px;
}

pre {
  background: #F8F8F5;
  border: 1px solid #E5E7EB;
  border-radius: 2px;
  padding: 10px 12px;
  margin: 0 0 14px;
  overflow-x: auto;
  break-inside: avoid;
}

pre code {
  color: #B8860B;
  background: none;
  padding: 0;
  font-size: 9.5pt;
  line-height: 1.45;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin: 8px 0 16px;
  font-size: 10pt;
  break-inside: avoid;
}

thead th {
  background: #1F4E79;
  color: #FFFFFF;
  font-weight: 700;
  text-align: left;
  padding: 6px 10px;
  border: 1px solid #1F4E79;
}

tbody td {
  padding: 6px 10px;
  border: 1px solid #E5E7EB;
  vertical-align: top;
}

tbody tr:nth-child(even) { background: #F8FAFC; }

hr { border: none; border-top: 1px solid #D1D5DB; margin: 18px 0; }

blockquote {
  margin: 0 0 12px;
  padding: 4px 14px;
  border-left: 3px solid #B8860B;
  color: #4B5563;
}
"""

TEMPLATE = """<!DOCTYPE html>
<html lang="it">
<head>
<meta charset="utf-8">
<title>__TITLE__</title>
<style>
__CSS__
</style>
</head>
<body>
__BODY__
</body>
</html>
"""

text = md_path.read_text(encoding="utf-8")

title = title_arg.strip()
if not title:
    for line in text.splitlines():
        if line.startswith("# "):
            title = line[2:].strip()
            break
if not title:
    title = md_path.stem

body = markdown.Markdown(extensions=["extra", "sane_lists"]).convert(text)
css = (
    CSS.replace("__HEADER_LEFT__", html.escape(header_left))
    .replace("__HEADER_RIGHT__", html.escape(header_right))
)
page = (
    TEMPLATE.replace("__CSS__", css)
    .replace("__BODY__", body)
    .replace("__TITLE__", html.escape(title))
)

html_path = out_pdf.with_suffix(".html")
html_path.write_text(page, encoding="utf-8")

chrome = chrome_arg or shutil.which("google-chrome") or shutil.which("chromium") or shutil.which("chromium-browser")
if not chrome:
    sys.stderr.write("Errore: Chrome/Chromium non trovato (imposta CHROME_BIN).\n")
    sys.exit(1)

cmd = [
    chrome,
    "--headless=new",
    "--disable-gpu",
    "--no-sandbox",
    "--no-pdf-header-footer",
    "--run-all-compositor-stages-before-draw",
    "--virtual-time-budget=15000",
    f"--print-to-pdf={out_pdf}",
    html_path.as_uri(),
]
result = subprocess.run(cmd, capture_output=True, text=True)
if result.returncode != 0 or not out_pdf.exists():
    sys.stderr.write(result.stdout)
    sys.stderr.write(result.stderr)
    sys.exit(result.returncode or 1)

html_path.unlink(missing_ok=True)
print(f"OK -> {out_pdf}")
PY
