# Predicting-SST-w-.-Coupled-RCs

Summary: Reservoir computing is a type of neural net that uses randomly generated input and middle weights, which reduces training time compared to a traditional RNN. In these files, coupled reservoir computers are utilized in order to predict global sea surface temperatures (SST). In order to create a trained model which will then subsequently forecast SSTs, simply open the file in the 'Code' folder titled 'Main' and hit run.

Files:
- Main: Use this file to run the model. This is the main code which contains the architecture of the RCs and also where metaparameters can be adjusted.
- ActualAreaRectangle: Input the index of an area on the flat map and the function outputs the actual area that the index covers on a sphere.  
- FindPackIndices: Finds the corresponding indices on the map that are to be contained in a pack and organizes them into a column.
- GenerateResevoir: Creates the middle weight matrix 'A' with a chosen density and spectral radius.
- LinReg: Performs a ridge regression to train the output matrix 'W_out' with a regularization parameter 'beta'.
- Neighbors: Finds the neighboring indices surrounding a given index on a map. 

Data:
[...]

Comments:
[...]
