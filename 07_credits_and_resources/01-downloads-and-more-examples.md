## Map Downloads and Setup Information

*The BeamNG.drive setup portion of the process is not covered in detail in this guide. Setting up everything in BeamNG.drive can be a process on its own and would make this guide considerably longer.*

- Included are the **original** and the **edited versions** of the heightmap and basemap, along with the tree placement map where applicable.
 
  - The **edited versions** are located under `mapname` > `terrain` > `materialname`.

 **Download Link:** [**Google Drive**](https://drive.google.com/drive/folders/1HLpHrmBgWncCEFOW96CuQhYWVRa4fMVH?usp=drive_link)
 
>[!NOTE]
>**Feel free to modify and use these maps in your own projects**.
>
>If you find the maps or this tutorial useful, please consider sharing the link with others who might find it helpful. **A link back to this tutorial is always appreciated!**

***

### BeamNG.drive Import Settings

>[!WARNING]  
>I recommend that the original heightmap **not be resized or resampled in a image editor** if it is being used as elevation data. Changes to the pixel values can alter the resulting terrain. 
>
>**Heightmap modifications** may be appropriate for **visual purposes**, such as generating normal maps or other PBR textures.

|           File           |      Purpose       |   Color   | Bit Depth |
| :----------------------: | :----------------: | :-------: | :-------: |
| `heightmap_mapname.png`  | Terrain elevation  | Grayscale |  16-bit   |
| `tree_placement_map.png` |   Tree placement   | Grayscale |   8-bit   |
|  `t_terrain_base_b.png`  |      Basemap       |    RGB    |   8-bit   |
| `t_terrain_base_nm.png`  |  Surface normals   |    RGB    |   8-bit   |
|  `t_terrain_base_h.png`  | Height information | Grayscale |   8-bit   |
| `t_terrain_base_ao.png`  | Ambient occlusion  | Grayscale |   8-bit   |
|  `t_terrain_base_r.png`  | Surface roughness  | Grayscale |   8-bit   |

- All the `t_terrain_base_` files should be the **same dimension** as the **basemap**

- No **Alpha Channels**

| Meters Per Pixel | Heightmap Dimension | Tree Placement Map Dimension | Basemap Dimension |
| :--------------: | :-----------------: | :--------------------------: | :---------------: |
|        1         |         1x          |              1x              |        1x         |
|        2         |         1x          |              1x              |        2x         |
|        4         |         1x          |              1x              |        4x         |

<div style="text-align: center;">
  <figure style="display: inline-block; margin: 0; text-align: left;">
    <img src="../06_photos/19_beamng_import_settings.webp" 
         alt="BeamNG import settings" 
         style="max-width: 100%; height: auto;">
    <figcaption style="margin-top: 8px; font-style: italic; color: #666; text-align: center;">
      Swing Arm City, UT
    </figcaption>
  </figure>
</div>

<div style="text-align: center;">
  <figure style="display: inline-block; margin: 0; text-align: left;">
    <img src="../06_photos/19_basemap_import_settings.webp" 
         alt="BeamNG import settings" 
         style="max-width: 100%; height: auto;">
    <figcaption style="margin-top: 8px; font-style: italic; color: #666; text-align: center;">
      Swing Arm City, UT
    </figcaption>
  </figure>
</div>

***

## Downloadable Maps

### Swing Arm City, Utah

Map size: 8192 x 8192 

***BeamNG Settings:*** 

- Meters Per Pixel: 2

- Max Height: 523.8 m

<table>
  <tr>
    <td colspan="2" align="center">
      <img src="../06_photos/99_swing_arm_city_1.webp"
      alt="Swing Arm City in-game screenshot">
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="../06_photos/99_swing_arm_city_2.webp"
      alt="Swing Arm City in-game screenshot">
    </td>
    <td align="center">
      <img src="../06_photos/99_swing_arm_city_kb.webp"
      alt="Swing Arm City in-game screenshot">
    </td>
  </tr>
</table>

*Aerial Imagery Credit:* [**USDA-FSA Aerial Photography Field office**](https://www.fisheries.noaa.gov/inport/item/68235)

*Photo Credit:* [**Jeremy Jones**](https://www.thejeremyjones.com/index/kenblockterrakhana-32twe)

***

### Eureka Dunes, California

Map size: 8192 x 8192

***BeamNG Settings:*** 

- Meters Per Pixel: 2

- Max Height: 1047.5 m

<table>
  <tr>
    <td>
      <img src="../06_photos/99_eureka_dunes_1.webp"
      alt="Eureka Dunes in-game screenshot">
    </td>
    <td>
      <img src="../06_photos/99_eureka_dunes_2.webp"
      alt="Eureka Dunes in-game screenshot">
    </td>
  </tr>
</table>

*Aerial Imagery Credit:* [**USDA-FSA Aerial Photography Field office**](https://www.fisheries.noaa.gov/inport/item/70527)

***

### Eureka Dunes, California (1:4 scale)

Map size: 4096 x 4096

***BeamNG Settings:*** 

- Meters Per Pixel: 2

- Max Height: 237.5 m

>[!NOTE]
>I originally made this for **Cities: Skylines**, which reduces an 18 km × 18 km area to a 1081 × 1081 heightmap, so much of the fine detail is lost. I found that the results weren't worth the effort of downloading and processing hundreds of point cloud tiles.

<table>
  <tr>
    <td>
      <img src="../06_photos/99_eureka_dunes_scaled_1.webp"
      alt="Eureka Dunes 1:4 scale in-game screenshot">
    </td>
    <td>
      <img src="../06_photos/99_eureka_dunes_scaled_2.webp"
      alt="Eureka Dunes 1:4 scale in-game screenshot">
    </td>
  </tr>
</table>

*Aerial Imagery Credit:* [**USDA-FSA Aerial Photography Field office**](https://www.fisheries.noaa.gov/inport/item/70527)

***

### Crater Lake, Oregon (~1:3 scale)

Map size: 8192 x 8192

***BeamNG Settings:*** 

- Meters Per Pixel: 2

- Max Height: 489.6 m

<table>
  <tr>
    <td>
      <img src="../06_photos/99_crater_lake_1.webp"
      alt="Crater Lake in-game screenshot">
    </td>
    <td>
      <img src="../06_photos/99_crater_lake_2.webp"
      alt="Crater Lake in-game screenshot">
    </td>
  </tr>
</table>

*Aerial Imagery Credit:* **USGS National Map - NAIP Imagery, Natural Color** [**(WMS)**](https://imagery.nationalmap.gov/arcgis/services/USGSNAIPImagery/ImageServer/WMSServer)

***

### Yosemite (El Capitan), California

Map size: 4096 x 4096

***BeamNG Settings:*** 

- Meters Per Pixel: 2

- Max Height: 1299.2 m

<table>
  <tr>
    <td>
      <img src="../06_photos/99_el_capitan_ca_1.webp"
      alt="El Capitan in-game screenshot">
    </td>
    <td>
      <img src="../06_photos/99_el_capitan_ca_2.webp"
      alt="El Capitan in-game screenshot">
    </td>
  </tr>
</table>

*Aerial Imagery Credit:* **USGS National Map - NAIP Imagery, Natural Color** [**(WMS)**](https://imagery.nationalmap.gov/arcgis/services/USGSNAIPImagery/ImageServer/WMSServer)

***

### Ridge Motorsports Park, Washington

Map size: 4096 x 4096 

***BeamNG Settings:*** 

- Meters Per Pixel: 2

- Max Height: 47.6 m

<table>
  <tr>
    <td>
      <img src="../06_photos/99_ridge_motorsports_park_2.webp"
      alt="Ridge Motorsports Park in-game screenshot">
    </td>
    <td>
      <img src="../06_photos/99_ridge_motorsports_park_4.webp"
      alt="Ridge Motorsports Park in-game screenshot">
    </td>
  </tr>
</table>

*Aerial Imagery Credit:* **USGS National Map - NAIP Imagery, Natural Color** [**(WMS)**](https://imagery.nationalmap.gov/arcgis/services/USGSNAIPImagery/ImageServer/WMSServer)

***

## More Examples 

>[!warning]
>If you plan on sharing your map, make sure the imagery you use is **licensed for public use, redistribution, and derivative works**. Some imagery may be free to view or use but still restrict you from distributing the resulting map. **The maps below are not downloadable for that reason**.

***

### DirtFish Rally School, Washington

Map size: 4096 x 4096 

<table>
  <tr>
    <td>
      <img src="../06_photos/98_dirtfish_1.webp"
      alt="DirtFish in-game screenshot">
    </td>
    <td>
      <img src="../06_photos/98_dirtfish_2.webp"
      alt="DirtFish in-game screenshot">
    </td>
  </tr>
</table>

*Aerial Imagery Credit:* **EagleView Technology licensed to King County** [**Aerial 2023**](https://gismaps.kingcounty.gov/arcgis/rest/services/BaseMaps/KingCo_Aerial_2023/MapServer)

***

### Old Dominion University, Virginia

Map size: 1024 x 1024 

*Point cloud colorized using drone orthomosaic imagery*

<table>
  <tr>
    <td>
      <img src="../06_photos/98_old_dominion_university_1.webp"
      alt="Old Dominion University in-game screenshot">
    </td>
    <td>
      <img src="../06_photos/98_old_dominion_university_2.webp"
      alt="Old Dominion University in-game screenshot">
    </td>
  </tr>
</table>

*Aerial Imagery Credit:* **Geospatial Education, Spatial, and Analystics (GeoSEA) Team -** [**ODU Summer 2023 Drone Orthomosaic Imagery**](https://www.arcgis.com/apps/mapviewer/index.html?basemapUrl=https://tiles.arcgis.com/tiles/2DbqGRRQS9wbBetw/arcgis/rest/services/ODU_Summer_2023/MapServer?cacheKey=a6e40766af777cc3)

***

### Seattle Golf Club, Washington

Map size: 2048 x 2048 

<table>
  <tr>
    <td>
      <img src="../06_photos/98_seattle_golf_club_1.webp"
      alt="Seattle Golf Club in-game screenshot">
    </td>
    <td>
      <img src="../06_photos/98_seattle_golf_club_2.webp"
      alt="Seattle Golf Club in-game screenshot">
    </td>
  </tr>
</table>

*Aerial Imagery Credit:* **EagleView Technology licensed to King County** [**Aerial 2023**](https://gismaps.kingcounty.gov/arcgis/rest/services/BaseMaps/KingCo_Aerial_2023/MapServer)

***

### Tail of the Dragon, Tennessee

Map size: 4096 x 4096 

<table>
  <tr>
    <td colspan="2" align="center">
      <img src="../06_photos/98_tail_of_the_dragon_1.webp"
      alt="Tail of the Dragon OSM in-game screenshot">
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="../06_photos/98_tail_of_the_dragon_2.webp"
      alt="Tail of the Dragon in-game screenshot">
    </td>
    <td align="center">
      <img src="../06_photos/98_tail_of_the_dragon_3.webp"
      alt="Tail of the Dragon in-game screenshot">
    </td>
  </tr>
</table>

*Aerial Imagery Credit:* **Tennessee Department of Transportation(TDOT) -** [**ArcGIS Rest Server**](https://tnmap.tn.gov/arcgis/rest/services/BASEMAPS/IMAGERY_WEB_MERCATOR/MapServer)

*Imagery Credit:* [**OpenStreetMap**](https://www.openstreetmap.org/copyright)

***

### Diamond Head, Hawaii

Map size: 2048 x 2048 

<div align="center">
  <img src="../06_photos/98_diamond_head.webp"
  alt="Diamond Head in-game screenshot">
</div>

*Aerial Imagery Credit:* **USDA-FPAC-BC-GEO / Maxar-DigitalGlobe -** [**Hawaiian Islands Vivid Standard Satellite Orthoimagery**](https://geodata.hawaii.gov/arcgis/rest/services/SoH_Imagery/Vivid_2022/ImageServer)

***

## Project Overview

[**README**](../README.md) ←

***

## LiDAR Data and Other Resources

[**Useful Resources**](02-lidar-data-and-other-resources.md) →

## Citations and Attribution

[**Sources**](03-citations-and-attribution.md) →

***
