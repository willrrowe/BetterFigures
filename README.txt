--- README – BetterFigures ---
Make figures for publication (in MATLAB)

- Installation:	
Download the files and add them to the MATLAB path.

- Step-by-step installation:
1 - Download zip folder from https://github.com/willrrowe/betterFigures > click “Code” > click “Download Zip”
2 - Unzip and copy the “BetterFigures” folder to a suitable location. “Documents/MATLAB” is a sensible choice.
3- Add BetterFigures to the MATLAB path. 
To do this permanently, in the MATLAB command window run the command “edit startup”. The MATLAB startup.m file should open in the editor. Add the line “addpath(PATH)” where PATH is a string containing the path to the BetterFigures folder. For me this line look like “addpath('C:\Users\Will\Documents\MATLAB\betterFigures')”. Save the startup.m file and restart MATLAB. 
4 - You are now ready to use BetterFigures.

- Usage:
The basic structure of BetterFigures works with two parts proPlot and conFigure. 
The proPlot class is used to make a single plot. 
The conFigure class is used to combine many proPlot instances displaying them in array of panels in a single figure.

See example.m in the BetterFigures folder for practical examples of how to use both proPlot and conFigure.
Use the MATLAB help command followed by function names for more information.
proPlotOptions and conFigureOptions are functions that can be edited by the user to set their own default settings for proPlot and conFigure respectively. The help text for these functions explains the usage of the most common options for proPlot and conFigure.

