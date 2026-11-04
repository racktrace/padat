#!/usr/bin/env bash
# Cek bobot homepage (tanpa kompresi) terhadap budget.
# Menghitung index.html + semua aset lokal yang direferensikan (css, js, gambar, ikon, font).
set -euo pipefail

BUDGET=${BUDGET:-102400}   # 100 KB = batas tim hijau 512KB Club
PUBLIC=${PUBLIC:-public}
INDEX="$PUBLIC/index.html"
ASSET_EXT='css|js|mjs|svg|png|jpe?g|webp|avif|gif|ico|woff2?'

if [[ ! -f "$INDEX" ]]; then
  echo "ERROR: $INDEX not found. Run 'hugo build --minify' first." >&2
  exit 2
fi

files=("$INDEX")

# Ambil href/src lokal (dengan atau tanpa kutip), saring ekstensi aset, buang duplikat
while IFS= read -r ref; do
  path="$PUBLIC$ref"
  if [[ ! -f "$path" ]]; then
    echo "ERROR: referenced file missing: $path" >&2
    exit 2
  fi
  files+=("$path")
done < <(
  grep -oE '(href|src)="?/[^" >]+' "$INDEX" \
    | sed -E 's/^(href|src)="?//' \
    | grep -E "\.(${ASSET_EXT})$" \
    | sort -u
)

for f in "${files[@]}"; do
  printf '%8d  %s\n' "$(stat -c %s "$f")" "$f"
done

total=$(du -cb "${files[@]}" | tail -n1 | cut -f1)
echo "Homepage weight: ${total} bytes (budget: ${BUDGET} bytes)"

if (( total > BUDGET )); then
  echo "FAIL: over budget by $(( total - BUDGET )) bytes" >&2
  exit 1
fi

echo "OK: $(( BUDGET - total )) bytes remaining"
