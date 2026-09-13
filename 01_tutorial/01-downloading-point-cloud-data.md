## Step 1: Downloading Point Cloud Data

### Overview

Provided with this project is a `downloadlist.txt` file from the [**U.S. Geological Survey LidarExplorer (USGS)**](https://apps.nationalmap.gov/lidar-explorer/#/). It contains the download links for **9 point cloud tiles** covering **Buttonwillow Raceway Park in California**.

While the USGS covers much of the United States, **additional LiDAR datasets** may be available through the individual states' LiDAR [**portals**](../07_credits_and_resources/02-lidar-data-and-other-resources.md).

>[!TIP]
>*First project recommendation:* The [**Netherlands**](../07_credits_and_resources/02-lidar-data-and-other-resources.md) provides relatively consistent LiDAR datasets, and the datasets I used already had color information included in the point cloud.<br> 
>Imagery is also available through Web Map Services (WMS) in multiple coordinate reference systems (CRS), making it easy to get imagery for coloring point clouds.

***

### Instructions

<table>
  <tr>
    <td width="50%" align="center">
      <img src="../06_photos/01a_usgs_download.webp"
      alt="USGS download page">      
      <br>
      <strong>USGS LiDAR Explorer</strong>
    </td>
    <td width="50%" align="center">
      <img src="../06_photos/01b_folder_structure.webp"
      alt="Folder structure layout">
      <br>
      <strong>Project Directory Structure</strong>
    </td>
  </tr>
</table>

**A)** Download the `downloadlist.txt` file from **USGS LidarExplorer**.

**B)** *Preprocessed LiDAR products are also available*, but they are **not used** in this tutorial. We need the **full point cloud** because it will later be colorized with aerial imagery and used to create the basemap raster.

**C)** All of the `.laz` and `.tif` files used by this tutorial are **stored and processed** in `02_data`.

**D)** The `downloadlist.txt` file should be **saved in** `04_resources`.

> [!IMPORTANT]
> **E)** This entire workflow is set up so all the **commands are run from the project root** `lidar-to-heightmap-tutorial`.

***

**This script uses** `wget` **to download everything listed in** `downloadlist.txt`. It resumes incomplete downloads, skips files that already exist, and spaces out requests with randomized delays.

#### Native Execution 

```bash
wget -v -c -nc \
  -i "04_resources/downloadlist.txt" \
  -P "02_data/01_download" \
  --wait=30 \
  --random-wait \
  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
```

#### Docker Execution 

```bash
./run_pipeline.sh 01_download.sh
```

***

####  *(Optional)* Shorten File Names

Once you run this `echo` version, **check the printed preview** to make sure the 12-character slice from the right side of the filename looks correct. Then **swap** `echo mv` for `mv` to actually rename the files.

```bash
docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/data" \
    -w /data \
    lidar-pipeline \
    /bin/bash -c '
        for file in 02_data/01_download/*.laz; do
            [ -e "$file" ] || continue

            base="$(basename "${file%.laz}")"
            echo mv -v "$file" "02_data/01_download/${base: -12}.laz"
        done
    '
```

***

### Next Step

[**Step 2: Downloading Satellite Imagery**](02-downloading-imagery.md) →

### *Skip Colorization Process*

[**Step 5: Cleaning Point Cloud**](05-cleaning-point-cloud.md) →

***

### Project Overview

[**README**](../README.md) ←

***
