close all;
clear all;
clc;

%% Example 1
% Figure of a single axis with 1 data set plotted as a line and 1 data set
% as a scatter plot.
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
                        
figure(1);
pp1.plotData();

%% Example 2
% Figure of a colormap - The map is down-sampled, this can be done to speed
% up plotting when large datasets are in use.
x=-500:500;
y=x(1:2:end);
z=peaks(numel(x));
z=z(1:2:end,:);
pp2=proPlot(x,y,z,'PlotType','pcolor');
pp2=pp2.changeAxisOptions('ColorMap', 'hot',...
                          'CAxis', [-1,1]*10,...
                          'XLabelText', '$x$ displacement [mm]',...
                          'YLabelText', '$y$ displacement [mm]');
                      
figure(2)
pp2.plotData();

%% Example 3
% The same data as in example 2 plots a surface plot. In this case the data
% is not downsampled
pp3=proPlot(x,y,z,'PlotType','surf');
pp3=pp3.changeAxisOptions('XLabelText', '$x$ displacement [km]',...
                          'YLabelText', '$y$ displacement [km]',...
                          'ZLabelText', 'Hight above sea level [km]');
                      
figure(3)
pp3.plotData();
%% Example 4
% Fill
x = [1,2,3,4,5,4,3,2,1];
y = [1,2,3,4,5,6,7,8,9];
pp4 = proPlot(x, y, [], 'PlotType','Fill', 'FaceAlpha', 0.8);
pp4 = pp4.addData(x, y+1, [], 'PlotType','Fill', 'FaceAlpha', 0.8);
pp4 = pp4.addData(x, y+2, [], 'PlotType','Fill', 'FaceAlpha', 0.8);
pp4 = pp4.addData(x, y+3, [], 'PlotType','Fill', 'FaceAlpha', 0.8);
pp4 = pp4.addData(x, y+4, [], 'PlotType','Fill', 'FaceAlpha', 0.8);
pp4 = pp4.addData(x, y+5, [], 'PlotType','Fill', 'FaceAlpha', 0.8);
pp4 = pp4.addData(x, y+6, [], 'PlotType','Fill', 'FaceAlpha', 0.8);

figure(4)
pp4.plotData();

%% Example 5
% Image
pp5 = proPlot([], [], [], 'PlotType','Image', 'ImageFile', 'betterFigures\testImage.jpg');
% Change the aspect ratio to that of the image so that it fills the figure
pp5.changeFigOptions('Height',12,...
                     'Width',16);
                 
figure(5)
pp5.plotData();
%% Example 6
% Annotations
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

figure(6);
pp6.plotData();
%% Example 7
% One figure with two axes 
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
                      
figure(7);
pp7.plotData();
%% Example 8
% One plot with two x-axes 
% (so that you can put two different units on each axis)
x = [1,2,3,4,5];
y = [1,2,3,4,5];
pp8 = proPlot(x, y);
pp8 = pp8.addData(x,y+1);
pp8 = pp8.addData(x,y-1);
pp8 = pp8.addData(x+1,y+0.5);
pp8 = pp8.changeAxisOptions('Axis',2,...
                      'YAxisLocation','right',...
                      'XAxisLocation','top',...
                      'XLabelText', 'top $x$ label',...
                      'YColor','none',...
                      'XLim',[1/6,1],... % ensure the limts you set here correspond exactly to the limits on axis1 (but converted to the new units)
                      'XDir', 'Reverse' );

figure(8);
pp8.plotData();
%% Example 9
% Plot with data plotted on two y-axes but with the same x-axis
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

figure(9);
pp9.plotData();          
%% Example 10
% Adding insets to plots
x = [1,2,3,4,5];
y = [1,2,3,4,5];
pp10 = proPlot(x, y);
pp10 = pp10.addData(x,y+1);
pp10 = pp10.addData(x,y-1);

% Inset position given as [x,y,w,h]
pp10=pp10.addInset(pp4, [1,3.5,1.5,2.5]);
pp10=pp10.addInset(pp5, [3.5,0,1.5,2.5]);
figure(10);
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
% Line plot with scattered data and error bars
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
                        
figure(14);
pp14.plotData();


%% Example 15
% Specific example for Physics/Photonics
% A graph with two x-axes, one showing frequency, the other wavelength
c = 3*10^8; % Speed of light in a vacuum [m/s]
lam = (0.5:0.01:2)*10^-6; % lambda, wavelength [m]
om = 2*pi*c./lam; % omega, angular frequency [rad/s]

% Define Selmeirs eqn for bulk fused silica (Agrawal Nonlinear Fibre
% Optics) 
B_j = transpose([0.6961663, 0.4079426, 0.8974794]);
lam_j = transpose([0.0684043, 0.1162414, 9.896161])*10^-6; % resonance wavelengths
om_j = 2*pi*c./lam_j; % resonances angular frequencies
n = sqrt(1 + sum(  B_j.*om_j.^2./(om_j.^2 - om.^2 ), 1  )   ); % refractive index

% Both x-axes will be in units of wavelength with the same limits. 
% On axis 2 we will define the positions for tick marks in freq and convert
% them to wavelength to position them on the axis. The labels for these 
% ticks will be set using the in frequency. The result will be an axis with
% ticks marked in frequency but correctly positioned in wavelength
x_lim = [lam(1), lam(end)]*10^9; % x limits for both axes
x_ticks_freq = (5:-1:1)*10^14;   % define the x ticks you want in freq
x_tick_labels = string(x_ticks_freq*10^-12); % tick labels as strings
x_ticks_lam = (c./x_ticks_freq)*10^9; % convert x ticks to wavelength

% Plot refractive index against wavelength
pp15 = proPlot(lam*10^9, n);
pp15 = pp15.changeAxisOptions('XLabelText', 'Wavelength, $\lambda$ (nm)',...
                              'YLabelText', 'Refractive index, $n$',...
                              'XLim', x_lim);
pp15 = pp15.changeAxisOptions('Axis', 2,...
                              'XAxisLocation', 'Top',...
                              'YColor','none',... % hide the second y-axis as we do not require it
                              'XLim', x_lim,... 
                              'XTick', x_ticks_lam,...
                              'XTickLabel', x_tick_labels,...
                              'XLabelText', 'Frequency, $f$ (THz)');

figure(15)
pp15.plotData();



