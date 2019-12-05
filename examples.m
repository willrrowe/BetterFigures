close all;
clear all;
clc;

%% Example 1
% Figure of a single axis with 1 data set plotted as a line and 1 data set
% as a scatter plot.
figure(1);
x = 0.1:0.05:10*pi;
y = sin(x)./x;
pp1 = proPlot(x, y);
pp1 = pp1.addData(x(1:10:end),y(1:10:end), [], 'PlotType', 'scatter', 'CData', [238, 102, 119]/255);

% Axis labels and tick marks are changed from their defaults
pp1 = pp1.changeAxisOptions('XLabelText', 'Phase, $\phi$ [rad]',...
                            'YLabelText', 'Amplitude, $A$ [a.u.]',...
                            'XTick', [0,2*pi,4*pi,6*pi,8*pi,10*pi],...
                            'XTickLabel', ["0","$2\pi$","$4\pi$","$6\pi$","$8\pi$","$10\pi$"],...
                            'XLim',[0,10*pi]);
pp1.plotData();

%% Example 2
% Figure of a colormap - The map is down-sampled, this can be done to speed
% up plotting when large datasets are in use.
figure(2)
x=-500:500;
y=x(1:2:end);
z=peaks(numel(x));
z=z(1:2:end,:);
pp2=proPlot(x,y,z,'PlotType','pcolor');
pp2=pp2.changeAxisOptions('ColorMap', 'hot',...
                          'CAxis', [-1,1]*10,...
                          'XLabelText', '$x$ displacement [mm]',...
                          'YLabelText', '$y$ displacement [mm]');
pp2.plotData();

%% Example 3
% The same data as in example 2 plots a surface plot. In this case the data
% is not downsampled
figure(3)
pp3=proPlot(x,y,z,'PlotType','surf');
pp3=pp3.changeAxisOptions('XLabelText', '$x$ displacement [mm]',...
                          'YLabelText', '$y$ displacement [mm]',...
                          'ZLabelText', 'Hight above sea level [km]');
pp3.plotData();
%% Example 4
% Fill
figure(4)
x = [1,2,3,4,5,4,3,2,1];
y = [1,2,3,4,5,6,7,8,9];
pp4 = proPlot(x, y, [], 'PlotType','Fill', 'FaceAlpha', 0.8);
pp4 = pp4.addData(x, y+1, [], 'PlotType','Fill', 'FaceAlpha', 0.8);
pp4 = pp4.addData(x, y+2, [], 'PlotType','Fill', 'FaceAlpha', 0.8);
pp4 = pp4.addData(x, y+3, [], 'PlotType','Fill', 'FaceAlpha', 0.8);
pp4 = pp4.addData(x, y+4, [], 'PlotType','Fill', 'FaceAlpha', 0.8);
pp4 = pp4.addData(x, y+5, [], 'PlotType','Fill', 'FaceAlpha', 0.8);
pp4 = pp4.addData(x, y+6, [], 'PlotType','Fill', 'FaceAlpha', 0.8);
pp4.plotData();

%% Example 5
% Image
figure(5)
pp5 = proPlot([], [], [], 'PlotType','Image', 'ImageFile', 'proPlot\testImage.jpg');
% Change the aspect ratio to that of the image so that it fills the figure
pp5.changeFigOptions('Height',12,...
                     'Width',16);
pp5.plotData();
%% Example 6
% Annotations
figure(6);
x = [1,2,3,4,5];
y = [1,2,3,4,5];
pp6 = proPlot(x, y);
pp6 = pp6.addData(x,y+1);
% for a rectangle, elipse or textbox: first input is a position [x,y,w,h]
pp6 = pp6.addData([2,4,0.5,0.5], [], [], 'PlotType', 'Annotation', 'AnnotationType', 'rectangle');
pp6 = pp6.addData([4,2,0.5,0.5], [], [], 'PlotType', 'Annotation', 'AnnotationType', 'ellipse');
pp6 = pp6.addData([3,4,0,0], [], [], 'PlotType', 'Annotation', 'AnnotationType', 'textbox', 'String', 'down');
% for arrow, line, textarrow and doublearrow: input x and y coords for
% start and end points, i.e. [x1, x2], [y1, y2]
pp6 = pp6.addData([3,3],[4,3], [], 'PlotType', 'Annotation', 'AnnotationType', 'arrow');
pp6 = pp6.addData([1.5,2.5],[2.5,2.5], [], 'PlotType', 'Annotation', 'AnnotationType', 'doublearrow');
pp6 = pp6.addData([4,5],[5,5], [], 'PlotType', 'Annotation', 'AnnotationType', 'textarrow', 'String', 'across ');

pp6.plotData();
%% Example 7
% One figure with two axes 
figure(7);
x = [1,2,3,4,5];
y = [1,2,3,4,5];
pp7 = proPlot(x, y);
pp7 = pp7.addData(x,y+1);
pp7 = pp7.addData(x,y-1);
pp7 = pp7.addData(x+1,y+0.5, [], 'Axis',2, 'Color', [238, 102, 119]/255);
pp7 = pp7.changeAxisOptions('Axis',2,...
                          'YAxisLocation','right',...
                          'XAxisLocation','top',...
                          'XLabelText', 'top $x$ label',...
                          'YLabelText', 'right $y$ label',...
                          'YColor', [238, 102, 119]/255,...
                          'XColor', [238, 102, 119]/255);
pp7.plotData();
%% Example 8
% One plot with two x-axes 
% (so that you can put two different units on each axis)
figure(8);
x = [1,2,3,4,5];
y = [1,2,3,4,5];
pp8 = proPlot(x, y);
pp8 = pp8.addData(x,y+1);
pp8 = pp8.addData(x,y-1);
pp8 = pp8.addData(x+1,y+0.5);
pp8 = pp8.addAxis2();
pp8 = pp8.changeAxisOptions('Axis',2,...
                      'YAxisLocation','right',...
                      'XAxisLocation','top',...
                      'XLabelText', 'top $x$ label',...
                      'YColor','none',...
                      'XLim',[1/6,1],... % ensure the limts you set here correspond exactly to the limits on axis1 (but converted to the new units)
                      'XDir', 'Reverse' );

pp8.plotData();
%% Example 9
% Plot with data plotted on two y-axes but with the same x-axis
figure(9);
x = [1,2,3,4,5];
y = [1,2,3,4,5];
pp9 = proPlot(x, y);
pp9 = pp9.addData(x,y+1);
pp9 = pp9.addData(x,y-1);
pp9 = pp9.addData(x+1,y+0.5, [],'Axis', 2, 'Color', 'k');
pp9 = pp9.changeAxisOptions('Axis',2,...
                      'YAxisLocation','right',...
                      'YLabelText', 'right $y$ label',...
                      'XColor','none',... % hide the second x-axis as it will match the first
                      'XLim',[1,6] ); % ensure xlim are the same on both axes
pp9 = pp9.changeAxisOptions('Axis',1,...
                      'XLim',[1,6] ); %ensure xlim are the same on both axes

pp9.plotData();          
%% Example 10
% Adding insets to plots
figure(10);
x = [1,2,3,4,5];
y = [1,2,3,4,5];
pp10 = proPlot(x, y);
pp10 = pp10.addData(x,y+1);
pp10 = pp10.addData(x,y-1);

% Inset position given as [x,y,w,h]
pp10=pp10.addInset(pp4, [1,3.5,1.5,2.5]);
pp10=pp10.addInset(pp5, [3.5,0,1.5,2.5]);
pp10.plotData();
%% Example 11

figure(11)
CF = conFigure([pp1,pp4,pp5,pp10],2,2, 'UniformPlots', true, 'Width', 20);

%% Example 12

figure(12)
cf = conFigure([pp4,pp4,pp4,pp4], 1,4, 'Height', 5, 'Width', 20, 'separation', 0);

%% Example 13

figure(13)
CF = conFigure([pp7,pp4,pp5,pp10],2,2, 'UniformPlots', true, 'Width', 20);


%% Example 14
figure(14);
x = 0.1:0.05:10*pi;
y = sin(x)./x;
pp14 = proPlot(x, y);
pp14 = pp14.addData(x(1:10:end),y(1:10:end), [],...
                    'PlotType', 'scatter',...
                    'CData', [238, 102, 119]/255);
pp14 = pp14.addData(x(1:10:end),y(1:10:end), y(1:10:end)*0.1,...
                    'PlotType', 'errorbar', ...
                    'Color', [238, 102, 119]/255,...
                    'LineStyle', 'none',...
                    'UIStack','bottom');

% Axis labels and tick marks are changed from their defaults
pp14 = pp14.changeAxisOptions('XLabelText', 'Phase, $\phi$ [rad]',...
                            'YLabelText', 'Amplitude, $A$ [a.u.]',...
                            'XTick', [0,2*pi,4*pi,6*pi,8*pi,10*pi],...
                            'XTickLabel', ["0","$2\pi$","$4\pi$","$6\pi$","$8\pi$","$10\pi$"],...
                            'XLim',[0,10*pi]);
pp14.plotData();



