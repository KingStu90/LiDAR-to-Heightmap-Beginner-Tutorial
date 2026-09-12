#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

INPUT_DIR="$PROJECT_ROOT/02_data/05_heightmap_sor_filter"
GROUND_DIR="$PROJECT_ROOT/02_data/06_heightmap_csf_ground"
OFF_GROUND_DIR="$PROJECT_ROOT/02_data/06_heightmap_csf_offground"

if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Directory '$INPUT_DIR' does not exist."
    exit 1
fi

mkdir -p "$GROUND_DIR"
mkdir -p "$OFF_GROUND_DIR"

shopt -s nullglob
laz_files=("$INPUT_DIR"/*.laz)

if [ ${#laz_files[@]} -eq 0 ]; then
    echo "No .laz files found in '$INPUT_DIR'."
    exit 1
fi

for laz_file in "${laz_files[@]}"; do

    filename=$(basename "$laz_file")
    name_no_ext="${filename%.laz}"

    echo "Applying CSF filter: $filename"

    ground_check=("$GROUND_DIR/${name_no_ext}"*.las)
    offground_check=("$OFF_GROUND_DIR/${name_no_ext}"*.las)

    if [ ${#ground_check[@]} -gt 0 ] && [ ${#offground_check[@]} -gt 0 ]; then
        echo "Skipping: CSF outputs already exist for $name_no_ext."
        continue
    fi

    CloudCompare \
        -SILENT \
        -AUTO_SAVE OFF \
        -C_EXPORT_FMT LAS \
        -O -GLOBAL_SHIFT AUTO "$laz_file" \
        -CSF \
        -SCENES FLAT \
        -CLOTH_RESOLUTION 3.28 \
        -MAX_ITERATION 500 \
        -CLASS_THRESHOLD 1.64 \
        -REMOVE_ALL_SFS \
        -SAVE_CLOUDS

    status=$?

    if [ $status -ne 0 ]; then
        echo "ERROR: CloudCompare failed for $filename"
        exit $status
    fi
done

echo "Moving exported files..."

for f in "$INPUT_DIR"/*offground_points_*.las; do
    [ -e "$f" ] || continue
    filename=$(basename "$f")
    echo "Moving off-ground: $filename"
    mv "$f" "$OFF_GROUND_DIR/$filename"
done

for f in "$INPUT_DIR"/*ground_points_*.las; do
    [ -e "$f" ] || continue
    filename=$(basename "$f")
    echo "Moving ground: $filename"
    mv "$f" "$GROUND_DIR/$filename"
done

echo "------------------------------------------------"
echo "Finished: CSF Filter"
echo "Ground output: $GROUND_DIR"
echo "Off-Ground output: $OFF_GROUND_DIR"
