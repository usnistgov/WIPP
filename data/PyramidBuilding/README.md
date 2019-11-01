# Pyramid Building test

## Pre-requisites

- A running instance of the WIPP system ([installation instructions](../deployment/wipp-complete-single-node/README.md))
- Being familiar with the notions of images collections, plugins and workflows ([user guide](../user-guide/README.md))
- The following plugin is registered in the WIPP system being tested ([how to register a plugin](../user-guide/plugins/README.md)):
 - Pyramid Building ([link to plugin manifest](https://github.com/usnistgov/WIPP-pyramid-plugin/blob/master/wipp-pyramid-plugin.json))
 
## Upload images collection

Go to "Data" -> "Images collections".  

![](screenshots/images-collections.png)  


Click on "New images collection", fill in the Name field as "pyramid-small-dataset" and click on "Save".  

![](screenshots/new-images-collection.png)  


Upload the images located in the folder "inputCollection", wait for all images to be converted and lock the collection by clicking on the lock icon on the right.  

![](screenshots/images-collection-detail.png)

Input images:

![](screenshots/input.png)

## Upload stitching vector

Go to "Data" -> "Stitching vectors".  

![](screenshots/stitching-vectors.png)  


Click on "New stitching vector", fill in the Name field as "pyramid-small-dataset-sv", choose file "img-global-positions-1.txt" located in the "inputStitchingVector" folder and click on "Save".  

![](screenshots/new-stitching-vector.png)  


The stitching vector will appear in the list, and the detail view can be accessed by clicking on the "pyramid-small-dataset-sv" row in the table. 

![](screenshots/stitching-vector-details.png)

Input stitching vector:

![](screenshots/input-sv.png)

 
## Create the workflow

Go to "Workflows".  

![](screenshots/workflows.png)


Click on "New workflow", fill in the Name field as "pyramid-test" and click on "Save".  

![](screenshots/new-workflow.png)


Click on "Add task" and choose "WIPP Pyramid plugin 0.0.2" in the dropdown list.  

![](screenshots/add-task.png)

Configure the task as follow:
- Task name: grid
- Input Images: start typing "pyramid-small-dataset" and select this collection from the list
- Input Stitching Vector: start typing "pyramid-small-dataset-sv" and select this stitching vector from the list
- Blending method: select "overlay"
- Image depth: select "16U"

Click on "Add task"

![](screenshots/configure-task.png)

Click on "submit workflow" to submit the workflow.

![](screenshots/submit.png)

Click on "Monitor in Argo" the monitor the workflow execution.

![](screenshots/monitor-argo.png)

Go to "Data" -> "Pyramids"

![](screenshots/pyramids.png)

The pyramid will appear in the list as "pyramid-test-grid-output".

Output pyramid:

![](screenshots/pyramid-output.png)

