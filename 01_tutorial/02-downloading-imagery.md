## Step 2: Downloading Imagery

### Overview

There are many ways to obtain satellite or aerial imagery for colorizing point clouds. For this tutorial, I will focus on downloading imagery from the **National Oceanic and Atmospheric Administration** (NOAA) [**Data Access Viewer**](https://coast.noaa.gov/dataviewer/#/imagery/search).  

My original method for downloading imagery was through **QGIS**. However, this method is a little more complex and tedious. Instead of going in-depth, I will direct you to the tutorial I learned from [**Point Clouds and Blender by Emory Beck**](https://www.maphustle.co.nz/blogs/pc-blender), and add just a few tips of my own.

For downloading imagery outside the U.S., I will only briefly cover the QGIS method. 

<table>
  <tr>
    <th colspan="2">Example A</th>
  </tr>
  <tr>
    <td align="center" width="50%">
      <strong>Downloaded through QGIS</strong><br>
      <img src="../06_photos/02a_esri_basemap.webp" 
      alt="ESRI imagery"
      width="80%"><br>
      <strong>Environmental Systems Research Institute (ESRI)</strong><br>
      Commercially Licensed Imagery<br>
      often newer, higher-resolution imagery
    </td>
    <td align="center" width="50%">
      <strong>Downloaded through NOAA</strong><br>
      <img src="../06_photos/02b_naip_basemap.webp" 
      alt="NAIP imagery"
      width="80%"><br>
      <strong>National Agriculture Imagery Program (NAIP)</strong><br>
      Public-use US aerial imagery<br>
      government imagery, updated periodically
    </td>
  </tr>
</table>

>[!WARNING]  
>If you plan on sharing your map, make sure the imagery you use is **licensed for public use, redistribution, and derivative works**.

### Instructions

#### NOAA Download Method

<div align="center">
  <img src="../06_photos/02c_noaa_download.webp" 
  alt="NOAA download page"
  style="max-width: 60%; height: auto;">
</div>

**A)** Select the **Area of Interest** (*AOI*).
  
**B)** On the desired imagery, click the **Shopping Cart** icon (*not shown*).
  
**C)** Select the **Projection and Datum Options** for your area, then **Add to Cart**. The imagery will be reprojected to match the point cloud's coordinate reference system (CRS) later.

**D)** Click the **Cart** on left sidebar to **Checkout** (*Requires email address to receive download link*).

>[!NOTE]
>To find out which **Projection and Datum Options** to select, use `pdal info --summary` on the `.laz` file. The output will be a huge wall of text and may be overwhelming at first. Look for the **EPSG code** located here (**A**). Once you have the EPSG code, enter it into [**EPSG.io**](https://epsg.io/6424) to make the information easier to read. On the EPSG.io page, scroll down to **Export** and select the **ESRI WKT** tab.

<div align="center">
  <img src="../06_photos/02e_pdal_info.webp" 
  alt="PDAL info - terminal output"
  style="max-width: 60%; height: auto;">
</div>

##### Native Execution 

```bash
pdal info 02_data/01_download/s60975w23650.laz --summary
```

##### Docker Execution

```bash
docker run --rm \
   --user "$(id -u):$(id -g)" \
   -v "$PWD:/data" \
   -w /data \
   lidar-pipeline \
   pdal info 02_data/01_download/s60975w23650.laz --summary
```

#### QGIS Download Method

<div align="center">
  <img src="../06_photos/02d_qgis_download.webp" 
  alt="QGIS download page"
  style="max-width: 80%; height: auto;">
</div>

**A)** ***WMS, XYZ Tiles, and ArcGIS REST Server*** are possible sources for imagery (*right-click > New Connection...*). 
  
- Curated list of ArcGIS REST Servers by [**Joseph Elfelt**](https://mappingsupport.com/p/surf_gis/list-federal-state-county-city-GIS-servers.pdf).
  
**B)** Make sure the **point-cloud tiles are unchecked** and the **imagery layer is above the point-cloud layers**.
  
**C)** Zoom in to a larger map scale to access **higher-resolution imagery** (*e.g. 1:5000 → 1:2500*). Once you reach the **maximum zoom level**, zooming in further the image will just get blurrier rather than provide more detail.
  
**D)** **Select the point-cloud tile from the "Calculate from" menu.** QGIS will then download imagery covering exactly the same area as the point cloud.
  
**E)** **Higher DPI produces a higher-resolution exported image, with more pixels covering the same area.** This gives the point cloud, which is often denser than the imagery, more detailed color information to sample from. This usually results in a sharper-looking basemap. ***NOTE: There is a limit for the download file size on some servers, and the imagery may be blank if the download exceeds this limit***.

### Previous Step

[**Step 1: Downloading Point Cloud Data**](01-downloading-point-cloud-data.md) ←

### Next Step

[**Step 3: Reprojecting Imagery**](03-reprojecting-imagery.md) →
