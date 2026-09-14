## Creating the Basemap via PDAL

***

### Overview

*This is the original method I used to create the basemap raster using PDAL*.

The current tutorial uses **CloudCompare's Rasterize tool** because it produces better results when there are gaps in the point cloud. I am keeping this **PDAL workflow as an alternative method** because it may be useful for other datasets or if you have trouble with CloudCompare CLI.

This method produces the **same type of basemap** used in the main workflow, so after finishing this step, continue with **Step 12**.

***

### Instructions

#### 1) Check RGB Values

```bash
docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/data" \
    -w /data \
    lidar-pipeline \
    pdal info 02_data/04_colorize/s60975w23675_COLOR.laz --stats
```

Look for the **Red**, **Green**, and **Blue** values in the output. The `maximum` value will indicate whether the RGB data is 8-bit or 16-bit.

| Type             | Size in Bits | Values    | Text Representations                   |
| ---------------- | ------------ | --------- | -------------------------------------- |
| Unsigned Integer | 8            | `0-255`   | `uint8`(*PDAL*) <br>`Byte` (*GDAL*)    |
| Unsigned Integer | 16           | `0-65535` | `uint16`(*PDAL*) <br>`UInt16` (*GDAL*) |

***

#### 2) Basemap Rasterization

- The **PDAL pipeline** below defines **how the point cloud is rasterized**. The **Bash script** then runs this pipeline for each point-cloud file.

**PDAL Pipeline**

<div align="center">
  <img src="../06_photos/99_pdal_pipeline_idw.webp" 
  alt="PDAL Pipeline Rasterize json"
  style="max-width: 60%; height: auto;">
</div>

- `resolution: 0.5` sets the pixel size to 0.5 × 0.5 units. 
  
	- `1.0` would produce one pixel per square unit.
	  
	- `0.5` produces **4× as many pixels**.

- `output_type: idw` blends nearby points to calculate each pixel. (*my recommendation for this tutorial/process*) 
  
	- `mean` is an another that averages the nearby points.

- `window_size: 3` controls how far PDAL looks when filling missing cells.
  
- `data_type`: outputs 8-Bit or 16-Bit  values

*The pipeline file `99_pipeline_rasterize.json` is located in the `04_resources` folder.*

***

**Bash Scripts**

- Choose **1 Tile** if you have limited RAM. Choose **4 Tiles** to process **four tiles in parallel**, which can significantly increase memory usage.

**Native Execution - 1 Tile**

```bash
#!/bin/bash
mkdir -p 02_data/11_basemap_raster

for file in 02_data/04_colorize/*.laz; do
    base="$(basename "${file%.laz}")"

    pdal pipeline 04_resources/99_pipeline_rasterize.json \
        --stage.reader_las.filename="$file" \
        --stage.write_red.filename="02_data/11_basemap_raster/${base}_RED.tif" \
        --stage.write_green.filename="02_data/11_basemap_raster/${base}_GREEN.tif" \
        --stage.write_blue.filename="02_data/11_basemap_raster/${base}_BLUE.tif"

    echo "Finished: ${base}"
done
```

**Native Execution - 4 Tiles**

```bash
#!/bin/bash
INPUT_DIR="02_data/04_colorize"
OUTPUT_DIR="02_data/11_basemap_raster"
PIPELINE="04_resources/99_pipeline_rasterize.json"

mkdir -p "$OUTPUT_DIR"

find "$INPUT_DIR" -maxdepth 1 -name "*_COLOR.laz" -print0 | \
xargs -0 -I {} -P 4 bash -c '
    file="$1"
    base="$(basename "${file%.laz}")"

    pdal pipeline "$2" \
        --stage.reader_las.filename="$file" \
        --stage.write_red.filename="$3/${base}_RED.tif" \
        --stage.write_green.filename="$3/${base}_GREEN.tif" \
        --stage.write_blue.filename="$3/${base}_BLUE.tif"

    echo "Finished: ${base}"
' _ {} "$PIPELINE" "$OUTPUT_DIR"
```

**Docker Execution - 1 Tile**

```bash
./run_pipeline.sh 99a_basemap_raster_1_tile.sh
```

**Docker Execution - 4 Tiles**

```bash
./run_pipeline.sh 99a_basemap_raster_4_tiles.sh
```

***

#### 3) Merging RGB Basemap Layers

- The only setting _**you may**_ have to change is `ot Byte`, the remaining settings are **recommended defaults** for this workflow and should not normally need to be changed.

**Native Execution**

```bash
#!/bin/bash
mkdir -p 02_data/11_basemap_raster

gdalbuildvrt \
    02_data/11_basemap_raster/red.vrt \
    02_data/11_basemap_raster/*_red.tif

gdalbuildvrt \
    02_data/11_basemap_raster/green.vrt \
    02_data/11_basemap_raster/*_green.tif

gdalbuildvrt \
    02_data/11_basemap_raster/blue.vrt \
    02_data/11_basemap_raster/*_blue.tif

gdalbuildvrt \
    -separate \
    02_data/11_basemap_raster/rgb.vrt \
    02_data/11_basemap_raster/red.vrt \
    02_data/11_basemap_raster/green.vrt \
    02_data/11_basemap_raster/blue.vrt

gdal_translate \
    -ot Byte \
    -co COMPRESS=DEFLATE \
    -co PREDICTOR=2 \
    -co TILED=YES \
    -co PHOTOMETRIC=RGB \
    -co INTERLEAVE=PIXEL \
    -co BIGTIFF=IF_NEEDED \
    02_data/11_basemap_raster/rgb.vrt \
    02_data/11_basemap_raster/basemap_MERGED.tif

rm \
    02_data/11_basemap_raster/red.vrt \
    02_data/11_basemap_raster/green.vrt \
    02_data/11_basemap_raster/blue.vrt \
    02_data/11_basemap_raster/rgb.vrt

echo "Finished: basemap_MERGED.tif"
```

**Docker Execution**

```bash
./run_pipeline.sh 99b_basemap_merge_rgb.sh
```

***

### Previous Step

[**Step 10: Finalizing the Heightmap**](../01_tutorial/10-finalizing-heightmap.md)  ←

### Next Step

[**Step 12: Finalizing the Basemap**](../01_tutorial/12-finalizing-basemap.md) →

***
