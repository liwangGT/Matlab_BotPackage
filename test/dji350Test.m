%% dji350Test
% The |dji350Test.m| script is used to test the dji350 class.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%
%   +bot
%
% AUTHOR:
%    Rowland O'Flaherty (http://rowlandoflaherty.com)
%
% VERSION: 
%   Created 29-MAY-2015

%% Clear
ccc

%% Import
import bot.*;
import bot.quad.*;

%% Parameters
simulate = true;
name = 'quad1';
id = 1;
optitrackHost = '192.168.2.145';
rosHost = '192.168.1.15';

%% Initialize robot
Q1 = dji350(simulate,name,id,optitrackHost,rosHost);
Q1.record = true;
Q1.init();

%% Initialize figure
figH = figure(1);
clf(figH);
set(1,'Position',getFigPos('side','top'));
axH = axes;
grid(axH,'on')
xlim(axH,[-8.5 8.5])
ylim(axH,[-5.5 5.5])
axis(axH,'equal')
set(axH,'XLimMode','manual')
set(axH,'YLimMode','manual')
set(axH,'NextPlot','add')

Q1.axisHandle = axH;

Q1.addGraphicToPlot();

%% Goto
Q1.goto([1;1;1],.1)