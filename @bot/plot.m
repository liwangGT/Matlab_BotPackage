function plot(botObj)
% The "plot" method ... TODO: Add description
%
% SYNTAX: TODO: Add syntax
%   botObj = botObj.plot(arg1)
%
% INPUTS: TODO: Add inputs
%   botObj - (1 x 1 trackable.trackable)
%       An instance of the "trackable.trackable" class.
%
%   arg1 - (size type) [defaultArgumentValue] 
%       Description.
%
% OUTPUTS: TODO: Add outputs
%   botObj - (1 x 1 trackable.trackable)
%       An instance of the "trackable.trackable" class ... ???.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +trackable, someFile.m
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com) 03-NOV-2012
%-------------------------------------------------------------------------------

%% Parameters
plotSize = 20;
plotPath = true;
l = .1;
axisNum = 1;

%% Variables
t = botObj.time;
H = botObj.state.transform;

%% Initialize
% % Create Figure
% if isempty(botObj.figHandle) || ~ishghandle(botObj.figHandle) || isempty(botObj.axisHandle) || ~ishghandle(botObj.axisHandle(axisNum))
%     if isempty(botObj.figHandle)
%         botObj.figHandle = figure;
%     else
%         figure(botObj.figHandle);
%     end
% end

% Create Axis
if isempty(botObj.axisHandle) || ~ishghandle(botObj.axisHandle(axisNum))
    % Create Axis
%     figure(botObj.figHandle);
    botObj.axisHandle(axisNum) = gca;
    cla(botObj.axisHandle(axisNum))
%     set(botObj.axisHandle(axisNum),'DrawMode','normal')
%     set(botObj.axisHandle(axisNum),'NextPlot','add')
    axis(botObj.axisHandle(axisNum),equal)
    
    xlim(botObj.axisHandle(axisNum),1/2*[-plotSize,plotSize])
    ylim(botObj.axisHandle(axisNum),1/2*[-plotSize,plotSize])
    zlim(botObj.axisHandle(axisNum),[0,plotSize])
    grid(botObj.axisHandle(axisNum),'on')
else
    botObj.figHandle = get(botObj.axisHandle,'Parent');
%     XLim = get(botObj.axisHandle(axisNum),'XLim');
%     YLim = get(botObj.axisHandle(axisNum),'YLim');
%     plotSize = 
end
title(botObj.axisHandle(axisNum),[botObj.name ' (Time = ' num2str(t,'%.1f') ')'])

%% Plot

% Initialize plot
% if isempty(botObj.graphicsHandles) || all(~ishghandle(botObj.graphicsHandles))
%     % Set properties
%     
%     
%     % Create static objects
%     
% end

% Update plot
if isempty(botObj.graphicsHandles) || ...
        any(~ismember(botObj.graphicsHandles,get(botObj.axisHandle(axisNum),'Children')))
    
    % Create dynamic objects
    botObj.graphicsHandles(1) = line('Parent',botObj.axisHandle(axisNum),...
        'XData',[H(1,4) l*H(1,1)+H(1,4)],...
        'YData',[H(2,4) l*H(2,1)+H(2,4)],...
        'ZData',[H(3,4) l*H(3,1)+H(3,4)],...
        'Color','b',...
        'LineWidth',2);
    
    botObj.graphicsHandles(2) = line('Parent',botObj.axisHandle(axisNum),...
        'XData',[H(1,4) l*H(1,2)+H(1,4)],...
        'YData',[H(2,4) l*H(2,2)+H(2,4)],...
        'ZData',[H(3,4) l*H(3,2)+H(3,4)],...
        'Color','g',...
        'LineWidth',2);
    
    botObj.graphicsHandles(3) = line('Parent',botObj.axisHandle(axisNum),...
        'XData',[H(1,4) l*H(1,3)+H(1,4)],...
        'YData',[H(2,4) l*H(2,3)+H(2,4)],...
        'ZData',[H(3,4) l*H(3,3)+H(3,4)],...
        'Color','r',...
        'LineWidth',2);
    
    if plotPath
        botObj.graphicsHandles(4) = line('Parent',botObj.axisHandle(axisNum),...
            'XData',botObj.tape.x,...
            'YData',[botObj.tape.y],...
            'ZData',[botObj.tape.z],...
            'Color','m',...
            'LineStyle',':',...
            'LineWidth',1);
    end
    
else
    
    % Update dynamic objects
    set(botObj.graphicsHandles(1),...
        'XData',[H(1,4) l*H(1,1)+H(1,4)],...
        'YData',[H(2,4) l*H(2,1)+H(2,4)],...
        'ZData',[H(3,4) l*H(3,1)+H(3,4)]);
    
    set(botObj.graphicsHandles(2),...
        'XData',[H(1,4) l*H(1,2)+H(1,4)],...
        'YData',[H(2,4) l*H(2,2)+H(2,4)],...
        'ZData',[H(3,4) l*H(3,2)+H(3,4)]);
    
    set(botObj.graphicsHandles(3),...
        'XData',[H(1,4) l*H(1,3)+H(1,4)],...
        'YData',[H(2,4) l*H(2,3)+H(2,4)],...
        'ZData',[H(3,4) l*H(3,3)+H(3,4)]);
    
    if plotPath
    set(botObj.graphicsHandles(4),...
        'XData',botObj.tape.x,...
        'YData',botObj.tape.y,...
        'ZData',botObj.tape.z);
    end
    
%     % Recenter plot
%     XLim = get(botObj.axisHandle(axisNum),'XLim');
%     YLim = get(botObj.axisHandle(axisNum),'YLim');
%     if H(1,4) <= XLim(1) + 1 || H(1,4) >= XLim(2) - 1 || ...
%         H(2,4) <= YLim(1) + 1 || H(2,4) >= YLim(2) - 1
%     
%         set(botObj.axisHandle(axisNum),...
%             'XLim',H(1,4)+1/2*[-plotSize,plotSize],...
%             'YLim',H(2,4)+1/2*[-plotSize,plotSize]);
%     end
        

end
