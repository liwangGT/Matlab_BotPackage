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
simulate = false;
name = 'quad1';
id = 1;
optitrackHost = '192.168.2.145';
rosHost = '192.168.2.141';
% rosHost = '10.0.1.6';

%% Initialize robot
Q1 = dji350(simulate,name,id,optitrackHost,rosHost);
Q1.record = true;
Q1.init();

% fopen(Q1.udpObj);
% Q1.quadInitialized = true;

%% Initialize figure
figH = figure(1);
clf(figH);
set(1,'Position',getFigPos('main','left'));
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

%----
% Q1.goto([1;1;1],.1)
%----
% Q1.desiredState.position = [1.5;0.0;1.75];
% ballSize = .1; 
% while norm(Q1.desiredState.position - Q1.state.position) > ballSize
%     Q1.update();
%     Q1.send();
%     pause(Q1.timeStep);
% end
%---
desiredHeight = 1.75;
tBar = 20;
t0 = Q1.time;
t = Q1.time - t0;

x0 = [Q1.state.position(1:2); desiredHeight];
xBar = [0;0.0;desiredHeight];
xDel = xBar - x0;

while t <= tBar
   Q1.desiredState.position = t / tBar * xDel + x0;
   Q1.update();
   Q1.send();
   pause(Q1.timeStep);
   t = Q1.time - t0;
end