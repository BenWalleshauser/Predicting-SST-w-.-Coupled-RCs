# Predicting-SST-w-.-Coupled-RCs

Summary: Reservoir computing is a type of neural net that uses randomly generated input and middle weights, which effectively reduces training time compared to a traditional RNN. In these files, coupled reservoir computers are utilized in order to predict global sea surface temperatures (SST). In order to create a trained model which will then subsequently forecast SSTs, simply open the file in the 'Code' folder titled 'Main' and hit run.

If you'd like to see previously collected results animated on a map or globe, download one of the MP4s above.

Files:
- Main: Use this file to run the model. This is the main code which contains the architecture of the RCs and also where metaparameters can be adjusted.
- ActualAreaRectangle: Input the index of an area on the flat map and the function outputs the actual area that the index covers on a sphere.  
- FindPackIndices: Finds the corresponding indices on the map that are to be contained in a pack and organizes them into a column.
- GenerateResevoir: Creates the middle weight matrix 'A' with a chosen density and spectral radius.
- LinReg: Performs a ridge regression to train the output matrix 'W_out' with a regularization parameter 'beta'.
- Neighbors: Finds the neighboring indices surrounding a given index on a map. 
- PlotError: Plots the average and maximum error of the forecast.
- PlotGlobe: Plots the forecasted and actual SST on a globe. The orientation of the globe can be changed within the file. This animation can also be saved as an AVI if desired.
- PlotMap: Plots the forecasted and actual SST on a flat map. This animation can also be saved as an AVI if desired.
- PlotTimeSeries: Plots the forecasted and actual SST over time for a chosen point on the map.
- ReturnCoords: Returns the coordinates of an index.
- ReturnInds: Returns the index of a point specified by coordinates.

Data:
[...]

Comments:
[...]
