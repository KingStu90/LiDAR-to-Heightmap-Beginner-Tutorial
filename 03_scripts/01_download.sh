#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

OUTPUT_DIR="$PROJECT_ROOT/02_data/01_download"

mkdir -p "$OUTPUT_DIR"

wget -nv -c -nc \
  -i "$PROJECT_ROOT/04_resources/downloadlist.txt" \
  -P "$OUTPUT_DIR" \
  --wait=30 \
  --random-wait \
  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

echo "------------------------------------------------"
echo "Finished: Downloading"
echo "Output: $OUTPUT_DIR"
