%% diffdriveTest
% The |diffdriveTest.m| script is used to test the diffdrive class.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%
%   +bot
%
% AUTHORS:
%    <http://rowlandoflaherty.com Rowland O'Flaherty>
%
% CREATED: 
%    17-FEB-2015 (Rowland O'Flaherty)
%
% MODIFIED:
%    17-FEB-2015 (Rowland O'Flaherty)

%% Clear
ccc

%% Import
import bot.*;
import bot.diffdrive.*

%% Initialize robot
DD = DiffDrive();
DD.simulate = true;
DD.record = true;

% DD.input = [40; 60];
DD.desiredState.x = 5;
DD.desiredState.y = 5;

%% Initialize figure
figH = figure(1);
clf(figH);
set(1,'Position',figPos('top','full'));
axH = axes;
grid(axH,'on')
xlim(axH,[-8.5 8.5])
ylim(axH,[-5.5 5.5])
axis(axH,'equal')
set(axH,'XLimMode','manual')
set(axH,'YLimMode','manual')
set(axH,'NextPlot','add')

DD.axisHandle = axH;

%% 
T = 100;
traj = @(t_) [(3*t_/T+1).*cos(2*pi*5*t_/T); (3*t_/T+1).*sin(2*pi*5*t_/T)];
point = traj(DD.time);

pointH = plot(axH,point(1),point(2),'xr');

%%
while round(DD.time,5) < T
    point = traj(DD.time);
    DD.desiredState.position(1:2) = point;
    DD.update();
    DD.plot();
    set(pointH,'XData',point(1))
    set(pointH,'YData',point(2))
    drawnow
end
