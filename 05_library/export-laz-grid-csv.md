## Export .laz Tile Grid

A Python script that reads LAZ files from a folder, determines their spatial positions, organizes them into an Easting/Northing grid, and exports the resulting tile layout as a CSV.

Helpful for seeing what tiles you have download/missing.

*Requires laspy and pandas*

```python
from pathlib import Path
import laspy
import pandas as pd

# Look in the same folder as this script
folder = Path(__file__).resolve().parent

tiles = []

# ---------------------------------------------------------
# Read every LAZ file and get its lower-left coordinates
# ---------------------------------------------------------

for file in folder.glob("*.laz"):
    las = laspy.read(file)

    tiles.append({
        "file": file.stem,
        "easting": las.header.x_min,
        "northing": las.header.y_min,
    })


if not tiles:
    print("No LAZ files found.")
    raise SystemExit


# ---------------------------------------------------------
# Get unique Easting and Northing positions
# ---------------------------------------------------------

eastings = sorted(set(tile["easting"] for tile in tiles))
northings = sorted(
    set(tile["northing"] for tile in tiles),
    reverse=True
)


# ---------------------------------------------------------
# Create lookup table
# ---------------------------------------------------------

grid = {}

for tile in tiles:
    key = (tile["easting"], tile["northing"])
    grid[key] = tile["file"]


# ---------------------------------------------------------
# Build the table
# ---------------------------------------------------------

rows = []

for northing in northings:

    row = [northing]

    for easting in eastings:
        tile = grid.get((easting, northing), "")
        row.append(tile)

    rows.append(row)


# ---------------------------------------------------------
# Create Pandas DataFrame
# ---------------------------------------------------------

columns = ["NORTHING"] + [str(e) for e in eastings]

df = pd.DataFrame(rows, columns=columns)


# ---------------------------------------------------------
# Export CSV
# ---------------------------------------------------------

output = folder / "laz_grid.csv"

# Write the EASTING title separately so the CSV has
# the visual layout we want.
with open(output, "w") as f:

    # Blank space + EASTING
    f.write("," + ",".join([""] * (len(eastings) - 1)) + ",EASTING\n")

    # Easting coordinates
    f.write("NORTHING," + ",".join(str(e) for e in eastings) + "\n")

    # Grid
    for _, row in df.iterrows():
        f.write(",".join(str(x) for x in row) + "\n")


print(f"Created: {output}")

```
