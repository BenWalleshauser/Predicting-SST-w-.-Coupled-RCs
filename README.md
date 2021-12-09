# Predicting Sea Surface Temperatures with Coupled Reservoir Computers

Reservoir computing is a type of neural net that uses randomly generated input and middle weights, which effectively reduces training time compared to a traditional RNN. In these files, coupled reservoir computers are utilized in order to predict global sea surface temperatures (SST). In order to create a trained model which will then subsequently forecast SSTs around the globe, download the processed dataset (see section below) then simply open the file in the `Code` folder titled `Main` and hit run.

If you'd like to see previously collected results, watch the video below!

https://user-images.githubusercontent.com/72924413/145119884-32123d9f-e023-4d77-91f6-43837da5d24d.mp4

# **Code:**
- `Main`: Use this file to run the model. This is the main code which contains the architecture of the RCs and also where metaparameters can be adjusted.
- `ActualAreaRectangle`: Input the index of an area on the flat map and the function outputs the actual area that the index covers on a sphere.  
- `FindPackIndices`: Finds the corresponding indices on the map that are to be contained in a pack and organizes them into a column.
- `GenerateResevoir`: Creates the middle weight matrix 'A' with a chosen density and spectral radius.
- `LinReg`: Performs a ridge regression to train the output matrix 'W_out' with a regularization parameter 'beta'.
- `Neighbors`: Finds the neighboring indices surrounding a given index on a map. 
- `ReturnCoords`: Returns the coordinates of an index.
- `ReturnInds`: Returns the index of a point specified by coordinates.
- `PlotError`: Plots the average and maximum error of the forecast. Uses MATLAB's [Mapping Toolbox](https://www.mathworks.com/products/mapping.html).
- `PlotGlobe`: Plots the forecasted and actual SST on a globe. The orientation of the globe can be changed within the file. This animation can also be saved as an AVI if      desired. Uses the [Climate Data Toolbox](https://www.chadagreene.com/CDT/CDT_Getting_Started.html).
- `PlotMap`: Plots the forecasted and actual SST on a flat map. This animation can also be saved as an AVI if desired. Uses the [Climate Data Toolbox](https://www.chadagreene.com/CDT/CDT_Getting_Started.html).
- `PlotTimeSeries`: Plots the forecasted and actual SST over time for a chosen point on the map.
- `PlotGlobe_V2`: Plots the forecasted and actual SST on a globe. The orientation of the globe can be changed within the file. This animation can also be saved as an AVI if desired. Does not require the Climate Data Toolbox.
- `PlotMap_V2`: Plots the forecasted and actual SST on a flat map. This animation can also be saved as an AVI if desired. Does not require the Climate Data Toolbox.

# **Data**:\
The dataset used to train and validate the model is titled “GHRSST Level 4 MUR 0.25deg Global Foundation Sea Surface Temperature Analysis (v4.2)” which
contains sea surface temperature data in degrees Kelvin on a global 0.25° grid from 2002 to 2021 in one day increments. This version is based on nighttime
GHRSST L2P skin and sub skin SST observations from several instruments, and is publicly available online via PODAAC [1]. The data was downloaded with the use of OPENDAP on 10/10/2021. The years 2003 to 2020 of the dataset were selected to form the training and validation dataset. The data is given in an equirectangular format, which is used throughout the modelling process for simplification purposes even though this implicitly leads to a more refined mesh near the pole. 

The dataset was downloaded and then processed such that the grid-size was now 1.50°x1.50°. The files used to download and discretize the data are found above in the `DataProcessing` folder, though these are only important if one wishes to re-process the data to their own liking.

*To download the processed dataset:*\
Go to the shared Google Drive folder [here](https://drive.google.com/drive/folders/1cQlzee6pGvgV4Ght5c5QYSn3I--r9Zm9?usp=sharing), and download the file titled `SST_Data.mat`, which you could then save to the same path as `Main`.

# **References:**\
[1]:  JPL MUR MEaSUREs Project. 2019. GHRSST
Level 4 MUR 0.25 deg Global Foundation
Sea Surface Temperature Analysis. Ver. 4.2.
PO.DAAC, CA, USA. Dataset accessed [2021-
10-10] at https://doi.org/10.5067/GHM25-4FJ42.
