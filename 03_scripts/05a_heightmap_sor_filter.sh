#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

INPUT_DIR="$PROJECT_ROOT/02_data/04_colorize"
OUTPUT_DIR="$PROJECT_ROOT/02_data/05_heightmap_sor_filter"

if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Directory '$INPUT_DIR' does not exist."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

shopt -s nullglob
laz_files=("$INPUT_DIR"/*.laz)

if [ ${#laz_files[@]} -eq 0 ]; then
    echo "No .laz files found in '$INPUT_DIR'."
    exit 1
fi

RUNTIME_DIR="$(mktemp -d)"
trap 'rm -rf "$RUNTIME_DIR"' EXIT

export QT_QPA_PLATFORM=offscreen
export XDG_RUNTIME_DIR="$RUNTIME_DIR"

for laz_file in "${laz_files[@]}"; do

    filename=$(basename "$laz_file")
    name_no_ext="${filename%.laz}"

    echo "Applying SOR filter: $filename"

    existing_files=("$OUTPUT_DIR/${name_no_ext}"*.las)

    if [ ${#existing_files[@]} -gt 0 ]; then
        echo "Skipping: SOR output already exists."
        continue
    fi

    CloudCompare \
        -SILENT \
        -AUTO_SAVE OFF \
        -C_EXPORT_FMT LAS \
        -O -GLOBAL_SHIFT AUTO "$laz_file" \
        -SOR 12 2.5 \
        -REMOVE_ALL_SFS \
        -SAVE_CLOUDS

    status=$?

    if [ $status -ne 0 ]; then
        echo "ERROR: CloudCompare failed for $filename"
        exit $status
    fi

    # CloudCompare saves the automatically file
    # in the same directory as the input file.
    sor_files=("$INPUT_DIR/${name_no_ext}"*.las)

    if [ ${#sor_files[@]} -eq 0 ]; then
        echo "ERROR: Expected SOR output was not created for $filename"
        exit 1
    fi

    for sor_file in "${sor_files[@]}"; do
        mv "$sor_file" "$OUTPUT_DIR/"
        echo "Moved: $(basename "$sor_file")"
    done

done

echo "------------------------------------------------"
echo "Finished: SOR filter"
echo "Output: $OUTPUT_DIR"
