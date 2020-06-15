classdef conFigure
%conFigure - Arrange proPlots into a single figure
%	conFigure(proPlotArray, n, m, options) - Arranges the proPlot
%	objects in proPlotArray into a grid with n rows and m columns.
%	The options argument is optional, for examples of valid options see the
%	example.m and conFigureOptions.m files.
    
    properties
        fig
        
        proPlotArray
        columns
        rows
        tightInsetArray
        options
        
    end
    
    methods
        function obj = conFigure(proPlotArray, rows, columns, varargin)
            
            obj.fig = gcf;
            clf(obj.fig);
            obj.proPlotArray = proPlotArray;
            obj.columns = columns; 
            obj.rows = rows;
            
            % setting options
            if(numel(varargin)>0)
                if(strcmpi(varargin{1}, "Options"))
                    OptionName = varargin{2};
                else
                    OptionName = "Default";
                end
            end
            try
                obj = obj.loadOptionSet(OptionName);
            catch err
                obj = obj.loadOptionSet("Default");
            end
            
            obj.options = updateStruct(obj.options, varargin{1:end});
            
            obj.proPlotArray(1).fig = obj.fig;
            obj.proPlotArray(1).figOptions.Width = obj.options.Width;
            obj.proPlotArray(1).figOptions.Height = obj.options.Height;
            obj.proPlotArray(1).applyFigOptions();
            
            obj = obj.setPositions();
            obj = obj.plotProPlotArray();
            
            if(obj.options.UniformPlots)
                ti = max(obj.tightInsetArray);
                for ii = 1:numel(obj.proPlotArray)
                    obj.proPlotArray(ii).TightInset = ti;
                    for jj = 1:2
                        field = strcat("axis", num2str(jj));
                        if( numel(obj.proPlotArray(ii).(field) )>0 )
                            obj.proPlotArray(ii)=obj.proPlotArray(ii).axisFillPosition(obj.proPlotArray(ii).(field));
                        end
                    end
                    obj.proPlotArray(ii)=obj.proPlotArray(ii).plotAnnotations();
                    if(numel(obj.proPlotArray(ii).insetArray)>0)
                        obj.proPlotArray(ii)=obj.proPlotArray(ii).plotInsets();
                    end
                end
            end
            
        end
        
        function obj = loadOptionSet(obj, setName)
        %loadOptionSet(setName) - load options with name setName as
        %specified in conFigureOptions.m
            
            [ options_ ] = conFigureOptions(setName);
            
            obj.options = options_;
            
            if(~contains(setName, "Default", 'IgnoreCase', true))
                disp( strcat('Options loaded from set: "', setName, '"' ))
            end
        end
        
        
        function obj = plotProPlotArray(obj)
            % plotProPlotArray() - plots all the plots in the proPlotArray
            
            for ii = 1:numel(obj.proPlotArray)
                obj.proPlotArray(ii).axis1=[];
                obj.proPlotArray(ii).axis2=[];
                obj.proPlotArray(ii).fig = gcf;
                obj.proPlotArray(ii) = obj.proPlotArray(ii).plotData([], false, false);
%                 if(numel(obj.proPlotArray(ii).axis2Options())>0)
%                     obj.proPlotArray(ii).addAxis2();
%                     obj.proPlotArray(ii) = obj.proPlotArray(ii).plotData([], false, false);
%                 end
                if(obj.options.Labels)
                    LabelString = strcat(obj.options.LabelEnds(1), obj.options.LabelOrder(ii), obj.options.LabelEnds(2));
                    obj.proPlotArray(ii).addLabel(LabelString);
                end
                
                if(obj.options.UniformPlots)
                    for jj = 1:2
                        field = strcat("axis", num2str(jj));
                        if( numel(obj.proPlotArray(ii).(field) )>0 )
                            obj.tightInsetArray = [obj.tightInsetArray; obj.proPlotArray(ii).(field).TightInset];
                        end
                    end
                end
                
            end
        end
       
        function obj = setPositions(obj)
            %setPositions - Sets the positions of all the proPlots based on
            % given columns and rows
            
            set(obj.fig, 'Units', obj.options.Units);
            pos = get(obj.fig, 'Position');
            pos = [pos(1), pos(2), obj.options.Width, obj.options.Height];
            set(obj.fig, 'Position', pos);
            
            %apply FigPadding
            if(numel(obj.options.FigPadding)>0)
                pos = [obj.options.FigPadding(1),...
                       obj.options.FigPadding(2),...
                       pos(3) - (obj.options.FigPadding(1)+obj.options.FigPadding(3)),...
                       pos(4) - (obj.options.FigPadding(2)+obj.options.FigPadding(4))];
            end

            
            % work out the layout of the subplots
            separation = obj.options.Separation;
            if(numel(obj.options.XRatios)==0)
                XRatios = ones(1,obj.columns)/obj.columns;
            else
                XRatios = obj.options.XRatios;
            end
            if(numel(obj.options.YRatios)==0)
                YRatios = ones(1,obj.rows)/obj.rows;
            else
                YRatios = obj.options.YRatios;
            end
            w = (pos(3) - (obj.columns-1)*separation)*XRatios;
            h = (pos(4) - (obj.rows-1)*separation)*YRatios;
            
%             xSpacing = w+separation;
%             ySpacing = h+separation;
            X = pos(1);
            Y = pos(2)+sum(h(1:end))+separation*(obj.rows-1);
            
            plot = 1;
            for row = 1:obj.rows
                for col = 1:obj.columns
                    % the position of this subplot
                    newPos = [ X + sum(w(1:col-1)) + separation*(col-1),...
                               Y - sum(h(1:row)) - separation*(row-1),...
                               w(col),...
                               h(row)];
                    obj.proPlotArray(plot).pos = newPos;
                    
                    plot = plot + 1;
                    
                    if(plot> numel(obj.proPlotArray))
                        break;
                    end
                end
                
                if(plot> numel(obj.proPlotArray))
                        break;
                end
            end
            
        end
                
    end
end

