classdef proPlot
%proPlot - A better way to plot
%   proPlot( x, y, z, options) - plots the given x, y, z data with the
%   options specified. 
%   To specify no z data use [].
%   Default type of plot is a line.
%   For more information on valid options see examples.m and
%   proPlotOptions.m > dataOptions
   
    properties
        
        fig
        pos
        axis1
        axis2
        data
        TightInset
        
        InstaPlot
        
        insetArray
        insetPos
        
        label;

        dataOptions
        axis1Options
        axis2Options
        figOptions

    end
    
    methods
        function obj = proPlot( x, y, z, varargin)
            %proPlot Construct an instance of this class
            if(nargin<3)
                z=[];
            end
            [x, y, z, varargin] = checkXYZ(x, y, z, varargin{:});

            if(numel(varargin)>0)
                if(strcmpi(varargin{1}, "PlotType"))
                    PlotType = varargin{2};
                    setName = strcat("Default",PlotType);
                else
                    setName = "Default";
                end
            end
            try
                obj = obj.loadOptionSet(setName);
            catch err
                obj = obj.loadOptionSet("Default");
            end

            obj = obj.addData(x, y, z, varargin{1:end});
        end
        
        function obj = applyFigOptions(obj)
            set(obj.fig, 'Units', obj.figOptions.Units);
            
            pos_ = get(obj.fig, 'Position');
            
            set(0, 'Units', obj.figOptions.Units);
            ss = get(0, 'screensize');
            adj = [ss(3) - pos_(1) - obj.figOptions.Width; ss(4) - pos_(2) - obj.figOptions.Height - 2];
            
            set(obj.fig,'Position', [pos_(1)+min([0,adj(1)]), pos_(2)+min([0,adj(2)]), obj.figOptions.Width, obj.figOptions.Height]);
            obj.pos = [];
            set(obj.fig,'PaperPositionMode','auto');
            set(obj.fig, 'PaperSize', [obj.figOptions.Width obj.figOptions.Height]);
            
            set(obj.fig,'Color', obj.figOptions.Color);
            
            obj.InstaPlot = obj.figOptions.InstaPlot;
            
        end
        
        function obj = loadOptionSet(obj, setName)
            %loadOptionSet(setName) - load options with name setName from
            %   proPlotOptions.m
            
            [ figOpts, axis1Opts, dataOpts, axis2Opts] = proPlotOptions(setName);
            
            obj.figOptions = figOpts;
            obj.axis1Options = axis1Opts;
            obj.dataOptions = dataOpts;
            obj.axis2Options = axis2Opts;
            
            if(~contains(setName, "Default", 'IgnoreCase', true))
                disp( strcat('Options loaded from set: "', setName, '"' ))
            end
        end
        
        
        function obj = changeAxisOptions(obj, varargin)
            % changeAxisOptions(options) - Any option that can be set on
            %   the axis object can be set here. Use name;value pairs.
            %
            %   For more details see examples.m and
            %   proPlotOptions.m>axis1Options
            %
            %   examples.m>Example 8 - For how to set options on a second
            %   axis
            
            
            if(strcmpi(varargin{1}, "axis"))
                axisInd = varargin{2};
                varargin = varargin(3:end);
            else
                axisInd = 1;
            end
            
            if(axisInd==1)
                obj.axis1Options = updateStruct(obj.axis1Options, varargin{1:end});
            elseif(axisInd==2)
                if(numel(obj.axis2Options)>0)
                    obj.axis2Options = updateStruct(obj.axis2Options, varargin{1:end});
                else
                    obj.axis2Options = updateStruct(obj.axis1Options, varargin{1:end});
                end
            end
            
            if(obj.InstaPlot)
                obj = obj.plotData();
            end
        end
        
        function obj = changeFigOptions(obj, varargin)
            %changeFigOptions(options) - Any option that can be set on
            %   the figure object can be set here. Use name;value pairs.
            %   For more details see examples.m and
            %   proPlotOptions.m>figOptions

            obj.figOptions = updateStruct(obj.figOptions, varargin{1:end});
            
%             obj = obj.applyFigOptions();
            if(obj.InstaPlot)
                obj = obj.plotData();
            end
        end
        
        
        function obj = addData(obj, x, y, z, varargin)
           % addData( x, y, z, options) - Add data to an existing proPlot
           % object. Arguements are identical to those of proPlot
           %   For more details see examples.m and proPlotOptions.m
           
           if(nargin<4)
               z=[];
           end
            [x, y, z, varargin] = checkXYZ(x, y, z, varargin{:});
           
           newData = obj.dataOptions;
           
           newData.x = x;
           newData.y = y;
           newData.z = z;
                          
           newData = updateStruct(newData, varargin{1:end});
           
           obj.data{numel(obj.data)+1} = newData;
                 
           if(obj.InstaPlot)
                obj = obj.plotData( numel(obj.data));
            end
                      
        end
        
        function obj = plotData(obj, range, plotInsets, plotAnnotations)
            % plotData(range, plotInsets) - Plots the data sets given by 
            % range, plots all data sets if no range given.
            % plotInsets - boolean - default true - whether to plot any
            % insets that have been specified
            
            if(numel(obj.fig)==0)
                obj.fig = gcf;
                clf(obj.fig);
                obj = obj.applyFigOptions();
            end            

            if(nargin<2||numel(range)==0)
                range = 1:numel(obj.data);
            end
            if(nargin<3)
                plotInsets=true;
            end
            if(nargin<4)
                plotAnnotations=true;
            end
            
            for ind = range
                
                % load the correct axis (create one if needed)
                for ii=1:2
                    ax = strcat("axis",num2str(ii));
                    if( obj.data{ind}.Axis ==ii)
                        if(numel(obj.(ax))==0)
                            obj.(ax) = axes();
                            set(obj.(ax), 'Units', get(obj.fig, 'Units') );
                        else
                            axes(obj.(ax));
                        end
                        obj = obj.applyAxisOptions( ii );
                    end
                end
                if(ind==1)
                    set(gca, 'NextPlot', 'replacechildren');
                else
                    set(gca, 'NextPlot', 'add');
                end
                obj = obj.axisFillPosition(gca);
               
               PlotType = obj.data{ind}.PlotType;
               p=[]; %clear the old plot - incase one doesn't get plotted 
                     % we don't want to change the options of the one
                     % before
               if( isfield(obj.data{ind},'DownSample2DPlot') && any(strcmpi(PlotType, ["pcolor", "surf"])) )
                   downSampleX = 1:max(floor(numel(obj.data{ind}.x)/obj.data{ind}.DownSample2DPlot), 1):numel(obj.data{ind}.x);
                   downSampleY = 1:max(floor(numel(obj.data{ind}.y)/obj.data{ind}.DownSample2DPlot), 1):numel(obj.data{ind}.y);
               else
                   downSampleX = 1:numel(obj.data{ind}.x);
                   downSampleY = 1:numel(obj.data{ind}.y);
               end

               if(strcmpi(PlotType, "line"))
                   p=plot(obj.data{ind}.x,obj.data{ind}.y);
               elseif(strcmpi(PlotType, "scatter"))
                   p=scatter(obj.data{ind}.x,obj.data{ind}.y, 'x');
               elseif(strcmpi(PlotType, "fill"))
                   if(isfield(obj.data{ind},'Color'))
                       color = obj.data{ind}.Color;
                   else
                       co = get(gca, 'ColorOrder');
                       index = max(mod(ind-1, numel(obj.data))+1,1);
                       color = co(index,:);
                   end
                   p=fill(obj.data{ind}.x,obj.data{ind}.y, color );
               elseif(strcmpi(PlotType, "pcolor"))
                   p=pcolor(obj.data{ind}.x(downSampleX),obj.data{ind}.y(downSampleY),obj.data{ind}.z(downSampleY,downSampleX));
               elseif(strcmpi(PlotType, "surf"))
                   p=surf(obj.data{ind}.x(downSampleX),obj.data{ind}.y(downSampleY),obj.data{ind}.z(downSampleY,downSampleX));
               elseif(strcmpi(PlotType, "annotation") && plotAnnotations)
                   annType = obj.data{ind}.AnnotationType;
                   if(any(strcmpi(annType, ["rectangle", "ellipse"])))
                       % x is positon of box relative to axis units [x,y,w,h]
                        p=annotation(annType, axis2FigRelativePos(obj.data{ind}.x ));
                   elseif(strcmpi(annType, "textbox"))
                       % x is positon of box relative to axis units [x,y,w,h]
                        p=annotation(annType, axis2FigRelativePos(obj.data{ind}.x ), 'String', obj.data{ind}.String, 'Interpreter', obj.figOptions.LabelInterpreter);
                   elseif(any(strcmpi(annType, ["line", "arrow", "doublearrow"])))
                       % x and y are beginign/end coords for lines
                       [X, Y] = axis2FigRelativeXY(obj.data{ind}.x, obj.data{ind}.y, [], obj.(strcat('axis',num2str(obj.data{ind}.Axis)) ) );
                        p=annotation(annType, X, Y);
                   elseif(strcmpi(annType, "textarrow"))
                       % x and y are beginign/end coords for lines
                       [X, Y] = axis2FigRelativeXY(obj.data{ind}.x, obj.data{ind}.y, [], obj.(strcat('axis',num2str(obj.data{ind}.Axis)) ) );
                        p=annotation(annType, X, Y, 'String', obj.data{ind}.String, 'Interpreter', obj.figOptions.LabelInterpreter);
                   end
               elseif(strcmpi(PlotType, "image"))
                   if( numel(obj.data{ind}.x)>0)
                        p=image(flipud(obj.data{ind}.x));
                   else 
                        [imageData,cm]=imread(obj.data{ind}.ImageFile);
                        p=image(flipud(imageData));
                        colormap(cm);
                   end
                    axis image
               else
                   % Plotting for any other plotType not explicitly given
                   % above
                   try
                        fh = str2func(PlotType);
                        if(numel(obj.data{ind}.y)>0)
                           if(numel(obj.data{ind}.z)>0)
                                p = fh(obj.data{ind}.x, obj.data{ind}.y, obj.data{ind}.z);
                           else
                               p = fh(obj.data{ind}.x, obj.data{ind}.y);
                           end
                       else
                           p = fh(obj.data{ind}.x);
                       end
                   catch e
                       if(~strcmp(PlotType, "Annotation") )
                            warning(e.identifier, '%s', e.message);
                       end
                   end
                   
               end

               if(numel(p)>0)
                    obj = obj.applyPlotOptions( ind, p);
               end
            end            
            
            % make all axes fill the set positon
            for jj=1:2
            for ii=1:2
                ax = strcat("axis",num2str(ii),"Options");
                if(numel(obj.(ax))>0)
                    obj = obj.applyAxisOptions( ii );
                    obj = obj.axisFillPosition(obj.(strcat("axis",num2str(ii))));
                end
            end
            end
            
            if(plotInsets)
                obj.plotInsets();
            end
        end
        
        
        function obj = applyPlotOptions(obj, ind, p)
        % applyPlotOptions(ind, p) - Applies the dataOptions from the
        % data set specified by ind to plot object p
        
            DataFields = fieldnames(obj.data{ind});
            
            for ii = 5:numel(DataFields) % remove any initial data fields that aren't simple axes options
                field = DataFields{ii};
                if(any(strcmp(properties(p), field)))
                    set(p, char(field), obj.data{ind}.(field));
                end
                if(strcmpi(field,'UIStack'))
                    uistack(p, obj.data{ind}.(field));
                end
            end
        end
        
        
         function obj = applyAxisOptions(obj, axisInd)
            % applyOptions(axisInd) - Applies the axis options to the axis
            % specified by axisInd
            
            axisField = strcat("axis", num2str(axisInd));
            if(axisInd == 2 && numel(obj.(axisField)) == 0)
                obj = obj.addAxis2();
            end
            ax = obj.(axisField);
            
            set(ax, 'XTickMode', 'auto');
            set(ax, 'YTickMode', 'auto');
            set(ax, 'ZTickMode', 'auto');
            
            if(axisInd==1)
                options_ = obj.axis1Options;
            elseif(axisInd==2)
                if( numel(obj.axis2Options) == 0)
                    options_ = obj.axis1Options;
                else
                    options_ = obj.axis2Options;
                end
            end
            
            % make axis visible over plotted data
            set(ax,'Layer','top');% 
            
            OptionsFields = fieldnames(options_);
            
            % for all the options
            for ii = 1:numel(OptionsFields)
                field = OptionsFields{ii};
                
                % check that the field exists on the axis
                if(any(strcmp(properties(ax), field)))
                    % if it exists, apply the option
                    set(ax, char(field), options_.(field));
                end
            end
            
            
            % set a few options specificially to also set the interpreter.
            if( isfield( options_, 'Interpreter' ) )
                Interpreter_ = options_.Interpreter;
            else
                Interpreter_ = 'tex';
            end
            
            if( isfield( options_, 'TitleText' ) )
                title(ax,options_.TitleText, 'Interpreter', Interpreter_);
            end
            if( isfield( options_, 'LegendLabels' ) )
                %Only set the legends if all the data is plotted otherwise
                %a warning message is displayed
                n_plotted = numel(get(ax, 'Children'));
                if(n_plotted >= numel(obj.data))
                    legend(ax,options_.LegendLabels, 'Interpreter', Interpreter_);
                end
            end
            if( isfield( options_, 'XLabelText' ) )
                xlabel(ax,options_.XLabelText, 'Interpreter', Interpreter_);
            end
            if( isfield( options_, 'YLabelText' ) )
                ylabel(ax,options_.YLabelText, 'Interpreter', Interpreter_);
            end
            if( isfield( options_, 'ZLabelText' ) )
                zlabel(ax,options_.ZLabelText, 'Interpreter', Interpreter_);
            end
            
            
            if(isfield( options_, 'CAxis' ))
                caxis(ax,options_.CAxis);
            end
            if(isfield( options_, 'ColorMap' ))
                colormap(ax,options_.ColorMap);
            end
            
            % Any TickModes that are still auto have not been changed.
            % Too many ticks can be set, so if there are a lot, reduce them
            % by half.
            Ticks = {'XTick','YTick','ZTick'};
            for ii = 1:numel(Ticks)
                field = Ticks{ii};
                if(strcmp(ax.(strcat(field,'Mode')), 'auto'))
                    if(numel(ax.(field)) >= 6)
                        ax.(field) = ax.(field)(1:2:end);
                    end
                end
            end
                
         end
         
        
         function obj = addAxis2(obj)
             % addAxis2() - Adds a second axis to the plot without
             % requiring any data to be plotted on it.
             % This is useful if you want to plot some data with two x-axes
             % (i.e. with difference scales) see examples.m>Example8.
             
            figure(obj.fig);
            obj.axis2 = axes();
            set(obj.axis2, 'Units', obj.figOptions.Units);
         end
         
         function obj = addLabel(obj, string)
            % addLabel(string) - Adds string as a label to the plot

            if(nargin>=2)
                obj.figOptions.LabelString = string;
            end
            
            if(numel(obj.label)==0)
                obj.label = annotation(obj.fig,'textbox',[0, 0, 0.1, 0.1],'String',obj.figOptions.LabelString,'EdgeColor','none');
            else
                obj.label.String = obj.figOptions.LabelString;
            end
            set(obj.label, 'FontSize', obj.figOptions.LabelFontSize);
            set(obj.label, 'FontUnits', get(gca, 'Units'));
            fontHeight = get(obj.label, 'FontSize');
            set(obj.label, 'FontUnits', 'point');
            set(obj.label, 'Units', get(obj.fig, 'Units'));
            pos_ = [obj.pos(1), obj.pos(2)+obj.pos(4)-fontHeight*1.1, fontHeight*0.1, fontHeight];
            set(obj.label, 'Position', pos_);
            set(obj.label, 'Margin', 0);
            if(isfield(obj.figOptions, 'Interpreter'))
                set(obj.label, 'Interpreter', obj.figOptions.LabelInterpreter);
            end
            if(isfield(obj.figOptions, 'LabelColor'))
                set(obj.label, 'Color', obj.figOptions.LabelColor);
            end
            

         end
         
        function obj = axisFillPosition(obj, ax)
             %axesFillPosition(ax) - Adjusts ax to completely fill the
             %position specified by the pos property of this proPlot object

             if(numel(obj.pos)==0)
                 pos_ = get(obj.fig, 'Position');
                 obj.pos = [0, 0, pos_(3), pos_(4)];
             end

             if(numel(obj.TightInset)>0)
                 % if a TightInset has been defined then use it
                 ti = obj.TightInset;
             elseif(numel(obj.axis1)>0 && numel(obj.axis2)>0)
                % otherwise want the maximum TightInset of the 2 axis
                ti = max([get(obj.axis1, 'TightInset'); get(obj.axis2, 'TightInset')] );
             else
                 % if only one axis then only use ax
                 ti=get(ax, 'TightInset');
             end
             

             left = obj.pos(1) + ti(1) + obj.figOptions.Padding(1);
             bottom = obj.pos(2) + ti(2) + obj.figOptions.Padding(2);
             ax_width = obj.pos(3) - ti(1) - ti(3) - (obj.figOptions.Padding(1)+obj.figOptions.Padding(3));
             ax_height = obj.pos(4) - ti(2) - ti(4) - (obj.figOptions.Padding(2)+obj.figOptions.Padding(4));
             ax.Position = [left bottom ax_width ax_height];

        end
            
        function obj = plotAnnotations(obj)
        % plotAnnotations - Plots only the annotations
            for ind = 1:numel(obj.data)
                if(strcmpi(obj.data{ind}.PlotType,'Annotation'))
                    
%                     if(obj.InstaPlot)
                        obj = obj.plotData(ind, false, true);
%                     end
                end
            end
        end
        
        function obj = addInset(obj, inset, position)
        % addInset(inset, pos) - Adds an inset to the plot
        % inset - The proPlot instance to add as the inset
        % positon - [x y w h] The position of the inset relative to axis1
        %           of the parent plot. x and y are the coordinates of the
        %           lower left corner of the inset. w and h are the width
        %           and height of the inset in the axis units.

            inset.insetPos = position;
            
            obj.insetArray = [obj.insetArray, inset];
            
            if(obj.InstaPlot)
                obj = obj.plotData();
            end
        end
        
        function obj = plotInsets(obj)
        % plotInsets - Plots all insets associated with this proPlot
        % object.
            ax = obj.axis1;
            for ii = 1:numel(obj.insetArray)
                obj.insetArray(ii).fig = obj.fig;
                set(gcf, 'CurrentAxes', ax);
                obj.insetArray(ii).axis1 = [];
                obj.insetArray(ii).axis2 = [];
                obj.insetArray(ii).pos = axis2FigRelativePos( obj.insetArray(ii).insetPos, obj.figOptions.Units);

                obj.insetArray(ii).plotData();
            end
        end

    end
end

function [x, y, z, varargin] = checkXYZ(x, y, z, varargin)
    % If user doesn't input x y or z and just puts options
    if( ~isnumeric(z) )
        varargin = {z, varargin{:}};
        z=[];
    end
    if( ~isnumeric(y) )
        varargin = {y, varargin{:}};
        y=[];
    end
    if( ~isnumeric(x) )
        varargin = {x, varargin{:}};
        x=[];
    end
end

function [Pos] = axis2FigRelativePos( Pos, Units)
% Changes a pos object given relative to axis coordinates to be relative to
% a figures coordinates. Units are the units of the figure.
if(nargin<2)
    Units="normalized";
end

X = [ Pos(1), Pos(1) + Pos(3)];
Y = [ Pos(2), Pos(2) + Pos(4)];
[Xtmp, Ytmp] = axis2FigRelativeXY( X,Y, Units);
Pos = [Xtmp(1), Ytmp(1), Xtmp(2)-Xtmp(1), Ytmp(2)-Ytmp(1)]; 

end

function [X, Y] = axis2FigRelativeXY(Xdata, Ydata, units, ax )
% Changes X and Y coordinates relative to an axis to be relative to
% a figures coordinates. Units are the units of the figure.
if(nargin<3 || numel(units)==0)
    units="normalized";
end
if(nargin<4)
    ax = gca;
end

oldunits = get(ax, 'Units');
set(ax, 'Units', units);
axpos = get(ax,'Position');
set(ax, 'Units', oldunits);
%get axes drawing area in data units
ax_xlim = get(ax,'XLim');
ax_ylim = get(ax,'YLim');
ax_per_xdata = axpos(3) ./ diff(ax_xlim);
ax_per_ydata = axpos(4) ./ diff(ax_ylim);
%these are figure-relative
X = (Xdata - ax_xlim(1)) .* ax_per_xdata + axpos(1);
Y = (Ydata - ax_ylim(1)) .* ax_per_ydata + axpos(2);
end