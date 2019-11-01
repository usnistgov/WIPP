# Sample datasets for testing WIPP

To test a fresh installation of WIPP, we provide three sample datasets with instructions on how to run test workflows using these datasets.

## Pre-requisites
- A running instance of the WIPP system ([installation instructions](../deployment/wipp-complete-single-node/README.md))
- Being familiar with the notions of images collections, plugins and workflows ([user guide](../user-guide/README.md))
- The following plugins are registered in the WIPP system being tested ([how to register a plugin](../user-guide/plugins/README.md)):
 - Thresholding ([link to plugin manifest](https://github.com/usnistgov/WIPP-thresholding-plugin/blob/master/plugin.json))
 - MIST - Microscopy Image Stitching Tool ([link to plugin manifest](https://github.com/usnistgov/MIST/blob/master/wipp-plugin.json))
 - Pyramid Building ([link to plugin manifest](https://github.com/usnistgov/WIPP-pyramid-plugin/blob/master/wipp-pyramid-plugin.json))
 - Image Assembling ([link to plugin manifest](https://github.com/usnistgov/WIPP-image-assembling-plugin/blob/master/wipp-image-assembling-plugin.json))
 - EGT Segmentation ([link to plugin manifest](https://github.com/usnistgov/WIPP-EGT-plugin/blob/master/wipp-egt-plugin.json))
 - Mask Labeling ([link to plugin manifest](https://github.com/usnistgov/WIPP-mask-labeling-plugin/blob/master/wipp-mask-labeling-plugin.json))
 - Feature Extraction ([link to plugin manifest](https://github.com/usnistgov/WIPP/blob/develop/plugins/wipp-feature2djava-plugin.json))

## Thresholding

Sample dataset of one image (~457KB), to be thresholded using the Otsu algorithm.

[Testing instructions](Thresholding/README.md)

## Pyramid Building

Sample dataset of 16 images (~3.8MB) and one stitching vector, to create a pyramid view of the 4x4 grid.

[Testing instructions](PyramidBuilding/README.md)

## Test Workflow

A multistep workflow including stitching, pyramid building, segmentation and feature extraction, using a small dataset of fluorescent images (~80MB).

[Testing instructions](Test-Workflow/README.md)
