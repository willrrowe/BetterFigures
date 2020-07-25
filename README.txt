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

- Saving figures
Once you have produced your figure you may want to save/export it as an image. BetterFigures doesn't do this but I would recommend using 'export_fig' which is available from https://github.com/altmany/export_fig.
A typical usage would be "export_fig("figure1.png") to save the current figure as figure1.png.
Add the option "-r600" for higher quality bitmaps, the number following the -r is the dpi (default is 300dpi)
If you find the figure doesn't save exactly as you expect try using differend renderer using one of "-painters", "-opengl" or "-zbuffer" options as seen if this improves things.
