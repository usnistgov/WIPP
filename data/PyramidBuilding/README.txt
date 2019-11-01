IMAGE PROCESSING - PYRAMID BUILDING JOB

-- 1. Preparing the data --

- Create a new image collection named "pyramid-building-test-data-input"
  Upload the images from the folder inputCollection in this collection and lock it
-- Create a new stitching vector named "pyramid-building-test-data-stitching"
  (Go the Stitching Vectors -> Upload a sitching vector, and choose the file that is inside 
  the inputStitchingVector folder)

-- 2. Running the job --

Parameters:
    Stitching vector: pyramid-building-test-data-stitching
    Image collection: pyramid-building-test-data-input
    Input images pattern: img_r00{r}_c00{c}.ome.tif
    Stitching vector pattern: img_r00{r}_c00{c}.ome.tif