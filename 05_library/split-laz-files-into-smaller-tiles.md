## Split .laz Files Into Smaller Tiles

Splits each `.laz` file in the current folder into a configurable grid of smaller tiles. The `GRID_SIZE` setting controls how many tiles are created along each side (for example, `5` creates a 5×5 grid with 25 tiles).

```bash
#!/bin/bash

# Number of tiles per side.
# 2 = 2x2 = 4 tiles
# 4 = 4x4 = 16 tiles
# 8 = 8x8 = 64 tiles
GRID_SIZE=5

# Output folder one level above the current directory
OUTPUT_DIR="../output_split"

# Create output folder if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Make sure GRID_SIZE is a positive integer
if ! [[ "$GRID_SIZE" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: GRID_SIZE must be a positive integer."
    exit 1
fi

echo "Splitting each LAZ into ${GRID_SIZE}x${GRID_SIZE} = $((GRID_SIZE * GRID_SIZE)) tiles..."
echo "Output folder: $OUTPUT_DIR"
echo

for file in *.laz; do
    # Skip files that have already been split
    [[ "$file" == *"_tile_"* ]] && continue

    echo "Processing $file..."

    # Get PDAL summary
    if ! summary=$(pdal info --summary "$file" 2>/dev/null); then
        echo "Error: Failed to read summary for $file. Skipping."
        continue
    fi

    # Extract bounds
    minx=$(echo "$summary" | grep -m 1 -o '"minx"[[:space:]]*:[[:space:]]*[-0-9.]*' | sed 's/.*:[[:space:]]*//')
    maxx=$(echo "$summary" | grep -m 1 -o '"maxx"[[:space:]]*:[[:space:]]*[-0-9.]*' | sed 's/.*:[[:space:]]*//')
    miny=$(echo "$summary" | grep -m 1 -o '"miny"[[:space:]]*:[[:space:]]*[-0-9.]*' | sed 's/.*:[[:space:]]*//')
    maxy=$(echo "$summary" | grep -m 1 -o '"maxy"[[:space:]]*:[[:space:]]*[-0-9.]*' | sed 's/.*:[[:space:]]*//')

    if [[ -z "$minx" || -z "$maxx" || -z "$miny" || -z "$maxy" ]]; then
        echo "Error: Could not parse bounds for $file. Skipping."
        continue
    fi

    # Calculate tile dimensions
    tile_width=$(awk "BEGIN {printf \"%.6f\", ($maxx - $minx) / $GRID_SIZE}")
    tile_height=$(awk "BEGIN {printf \"%.6f\", ($maxy - $miny) / $GRID_SIZE}")

    base="${file%.laz}"

    tile=1

    # Create GRID_SIZE x GRID_SIZE tiles
    for ((row=0; row<GRID_SIZE; row++)); do
        for ((col=0; col<GRID_SIZE; col++)); do

            tile_minx=$(awk "BEGIN {printf \"%.6f\", $minx + $col * $tile_width}")
            tile_maxx=$(awk "BEGIN {printf \"%.6f\", $minx + ($col + 1) * $tile_width}")
            tile_miny=$(awk "BEGIN {printf \"%.6f\", $miny + $row * $tile_height}")
            tile_maxy=$(awk "BEGIN {printf \"%.6f\", $miny + ($row + 1) * $tile_height}")

            output="$OUTPUT_DIR/${base}_tile_${tile}.laz"

            echo "  Creating $output"

            pdal translate \
                "$file" \
                "$output" \
                crop \
                --filters.crop.bounds="([$tile_minx, $tile_maxx], [$tile_miny, $tile_maxy])"

            ((tile++))
        done
    done

    echo "Finished $file"
    echo
done

echo "Finished splitting all files!"
```
