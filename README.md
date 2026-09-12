# LiDAR-to-Heightmap Beginner Tutorial

A beginner-friendly, reproducible workflow for turning **LiDAR data into heightmaps, basemaps, and tree placement maps for BeamNG.drive**. Additional **screenshots and download links** for maps can be found [**here**](07_credits_and_resources/01-downloads-and-more-examples.md). 

The complete **project files** used for this tutorial are available on GitHub. The repository includes **scripts for each step of the workflow**, so you can follow along by copying the commands provided and executing them as you work through the tutorial. You can run the workflow either **natively on your computer** or using **Docker**. [**View the project repository**](https://github.com/KingStu90/LiDAR-to-Heightmap-Beginner-Tutorial).

<table>
  <thead>
    <tr>
      <th colspan="2" style="text-align: center;">Examples: In-Game Screenshots</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: center; width: 50%;">
        <img src="06_photos/98_dirtfish_1.webp" alt="DirtFish Rally School, WA" style="width: 100%;">
        <br><em>DirtFish Rally School, WA</em>
      </td>
      <td style="text-align: center; width: 50%;">
        <img src="06_photos/99_swing_arm_city_1.webp" alt="Swing Arm City, UT" style="width: 100%;">
        <br><em>Swing Arm City, UT</em>
      </td>
    </tr>
    <tr>
      <td style="text-align: center; width: 50%;">
        <img src="06_photos/98_seattle_golf_club_1.webp" alt="Seattle Golf Club, WA" style="width: 100%;">
        <br><em>Seattle Golf Club, WA</em>
      </td>
      <td style="text-align: center; width: 50%;">
        <img src="06_photos/99_crater_lake_1.webp" alt="Crater Lake, OR" style="width: 100%;">
        <br><em>Crater Lake, OR</em>
      </td>
    </tr>
    <tr>
      <td style="text-align: center; width: 50%;">
        <img src="06_photos/99_eureka_dunes_scaled_1.webp" alt="Eureka Dunes, CA" style="width: 100%;">
        <br><em>Eureka Dunes, CA</em>
      </td>
      <td style="text-align: center; width: 50%;">
        <img src="06_photos/98_old_dominion_university_1.webp" alt="Old Dominion University, VA" style="width: 100%;">
        <br><em>Old Dominion University, VA</em>
      </td>
    </tr>
  </tbody>
</table>

## Why I Made This

I originally got interested in making **a track from LiDAR data** a couple of years ago after coming across this [**tutorial**](https://assettocorsamods.net/threads/track-building-series.1796/) for Assetto Corsa. Following the tutorial, I managed to get some roads imported into the driving sim. However, **the majority of the actual map creation was done in Blender**, and I didn't have the time or motivation to learn Blender just to drive around a local track.

Fast forward to this year: I made the switch to Linux, and BeamNG.drive is one of the few driving sims I own that is supported on Linux, so it became my main driving sim. After finding out that BeamNG has its own **World Editor, where you can do the map building in-game**, I decided to take another go at making a map from LiDAR data. With the help of this [**tutorial**](https://www.beamng.com/threads/tutorial-level-building-with-lidar.39370/), I got a heightmap made and imported into the World Editor. After **spending 100+ hours** on my first map (*shown below*), manually placing the roads and trees, and hand-painting all the terrain, **the map was still far from finished**. 

<table>
  <tr>
    <th colspan="2" align="center">Initial Manual Approach (100+ hrs)</th>
  </tr>
  <tr>
    <td align="center" width="50%">
      <img src="06_photos/00_ridge_motorsports_park_1.webp"  
      alt="Ridge Motorsports Park, WA — initial manual approach"
      width="100%">
    </td>
    <td align="center" width="50%">
      <img src="06_photos/00_ridge_motorsports_park_3.webp" 
      alt="Ridge Motorsports Park, WA — initial manual approach"
      width="100%">
    </td>
  </tr>
</table>

<table>
  <tr>
    <th colspan="2" align="center">Final Results: Ridge Motorsports Park, WA</th>
  </tr>
  <tr>
    <td align="center" width="50%">
      <img src="06_photos/00_ridge_motorsports_park_5.webp" 
      alt="Final Results: Ridge Motorsports Park, WA"
      width="100%">
    </td>
    <td align="center" width="50%">
      <img src="06_photos/00_ridge_motorsports_park_6.webp" 
      alt="Final Results: Ridge Motorsports Park, WA"
      width="100%">
    </td>
  </tr>
  <tr>
    <td colspan="2" align="center">
      <em>Trees placed with BeamNG.drive Biome Tool</em>
    </td>
  </tr>
</table>

## What This Tutorial Does

The part I found most frustrating was spending so much time **manually recreating things that were already present in LiDAR data**. Manually placing trees was especially time-consuming, and using roads as a method to smooth the terrain didn't seem like the ideal way to make a track that was accurate to real life, because it is very difficult to preserve the original camber and elevation when manually working on the terrain.

Discovering the [**Biome Tool**](https://documentation.beamng.com/world_editor/tools/biome_tool/) in the World Editor was the **starting point for this project**. It allows you to place objects and vegetation based on a grayscale mask. After a lot of experimentation with different LiDAR processing software, **I developed a repeatable method for extracting tree locations from the LiDAR data and creating a tree placement map**  that could be used with the Biome Tool ([**detailed explanation**](01_tutorial/13-isolating-trees.md)). 

**I also needed a way to reduce the force feedback noise in a way that didn't require manually smoothing the terrain.** My solution was to scale the LiDAR data to **50%** before generating the heightmap, and then bring the terrain back to its original scale in the BeamNG World Editor ([**detailed explanation**](01_tutorial/08-scale-50.md)).

**Finally, I wanted to eliminate the need to hand-paint the terrain**. The main problem I ran into when trying to use imagery like Google Maps for a basemap is that the imagery and heightmap become increasingly misaligned over a large area. **To solve this, I colorize the point cloud with the imagery and then create the basemap from the colorized point cloud** ([**detailed explanation**](01_tutorial/11-creating-the-basemap-cloudcompare.md)).

One ***potential*** way this project could be expanded is by using **LiDAR data to place material layers** (*grass, dirt, asphalt, etc.*). I know that the World Editor can **export layer maps** for each material (*shown below*). I haven't figured out a way to import layer maps, but depending on the dataset it **can be possible to extract information from the LiDAR data that could be used to paint different materials**.

<figure style="text-align: center; margin: auto;">
  <img
    src="06_photos/00_layermap_grass.webp"
    alt="Hand painted grass layer"
    style="max-width: 50%; height: auto;"
  >
  <figcaption style="margin-top: 8px; font-style: italic;">
    Hand Painted Grass Layer
  </figcaption>
</figure>

>[!NOTE]
>**Point cloud** in this tutorial refers to `.laz` or `.las` files.
>
>**Imagery** or **raster** refers to `.tif`, `.tiff`, or `.geotiff` files.

<div align="center">
  <img
    src="06_photos/00_workflow.svg"
    alt="Workflow mermaid chart"
    style="max-width: 100%; height: auto;"
  >
</div>

## Who This Is For

**I did my best to write this tutorial for the person I was when I started**. Because of this, the tutorial is fairly in-depth. There are a lot of tutorials about Geographic Information Systems (GIS) and processing LiDAR data, **but it can be difficult to know what to search for when you don't know the basic terminology**. 

My goal with this tutorial is to **provide a reproducible workflow** while introducing the GIS concepts along the way. This is **not intended to be the definitive way** to process LiDAR data. It is the workflow that worked for me, and different datasets may require different tools, settings, or approaches. The tutorial provides **downloadable example data** so you can follow along **step-by-step**, while also showing how the **same workflow and code** can be adapted to your own project.

## Software Prerequisites 

*Disclaimer: This project has been a great experience in **learning to write and understand code**. The majority of the scripts were written using using the free ChatGPT model without an account. **However, it took considerable planning, modifying, and testing to get this tutorial to work with multiple workflows**. I have purposely kept the "Native Execution" commands as simple as possible to help other non-technical users understand what the script is accomplishing*.

>[!IMPORTANT]
>All of the steps in the tutorial provide a “**Native Execution**” command which **requires the user to have the program used by that step installed on their PC**.
>
>There is also a “**Docker Execution**” command which requires **Docker**. The advantage of using Docker is that all the programs and their dependencies are installed in a self-contained environment, **so you don’t have to install and configure each program separately**.

### Software Prerequisites

#### Native Execution - Software Prerequisites

***All of the software listed are free to download***

- [**CloudCompare**](https://www.cloudcompare.org/) (*Required*) - 3D point cloud and mesh analysis tool 

- [**PDAL**](https://pdal.io/) (*Required*) - Point cloud processing and translation software

- [**GDAL**](https://gdal.org/en/stable/download.html) (*Required*) - Geospatial raster and vector data library

- [**Miniconda**](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html) (*Highly Recommended)* - Used to install the dependencies required by PDAL and GDAL 

- [**QGIS**](https://www.qgis.org/download/) (*Recommended*) - Desktop GIS and mapping software

- [**GIMP**](https://www.gimp.org/downloads/) or **Photoshop** - (*Highly Recommended*) - Image editor 

- [**LAStools**](https://rapidlasso.de/downloads/) (*Optional*) - LiDAR processing software with a mix of **free and paid tools**. I only used it as an alternative for merging large datasets (*more efficient than PDAL*).

*Depending on your operating system and what dependencies are installed, you may need to do some troubleshooting to get all the programs working correctly*.

#### Docker Execution - Software Prerequisites

**Docker** - [**Download link**](https://www.docker.com/get-started/)

After installing Docker, **open a terminal** in the `lidar-to-heightmap-tutorial` folder and run:

```bash
docker build -t lidar-pipeline .
```

This builds the Docker image used by the tutorial. *You only need to do this once, unless the `dockerfile` is changed*.

Before using `run_pipeline.sh`, make sure the script is **executable**:

```bash
chmod +x run_pipeline.sh
```

The tutorial uses `run_pipeline.sh` to run the processing scripts inside the Docker environment. For example:

```bash
./run_pipeline.sh 01_download.sh
```

The `run_pipeline.sh` script handles starting the Docker container and makes the project folder available to it. This allows the container to read from and write to the normal project folders.

>[!NOTE]
>To run the 'Docker Execution' commands **for your project**, edit the `.sh` text files found in the `03_scripts` directory.

## Start Tutorial

[**Step 1: Downloading LiDAR Data**](01_tutorial/01-downloading-point-cloud-data.md) →

## Map Downloads & More Examples 

[**Final Results**](07_credits_and_resources/01-downloads-and-more-examples.md) →

## LiDAR Data and Other Resources

[**Useful Resources**](07_credits_and_resources/02-lidar-data-and-other-resources.md) →

## Citations and Attribution

[**Sources**](07_credits_and_resources/03-citations-and-attribution.md) →

***

## About Me

I enjoy building things, figuring out how they work, and finding ways to solve problems with the tools and information available.

When I first started working with LiDAR data, my goal was simply to create a heightmap for a BeamNG.Drive map. I saw this project as a way to give something back to the modding and open-source communities that I've benefited from over the years. As I built the project, I realized how much I enjoyed working with LiDAR data. I found it interesting how much information could be extracted from a single dataset and how that information could be used to solve different problems. Rather than manually deciding where things like trees should go or how terrain should be shaped, I found it much more interesting to figure out how the data could make those decisions for me.

My interest in LiDAR also connects with my interest in drones. I originally got my Part 107 License to do FPV filming. While I enjoyed building and flying drones, I found that the artistic side of planning shots and editing footage wasn't as interesting to me as experimenting with different drone builds. Discovering the GIS field and learning to build pipelines to process LiDAR data has given me another way to explore my interest in drones beyond filming.

### Feedback & Support

If you find an issue with the tutorial, have a question, or have feedback on the workflow, I'd be happy to hear from you at <b>kingstuart75@gmail.com</b>.

If the tutorial helped you out and you'd like to support the project, the easiest way is to **share the link** with someone who might find it useful. You can also [**buy me a coffee**](https://buymeacoffee.com/stuartking).
