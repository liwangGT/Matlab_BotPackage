%% kheperaTest
% The |kheperaTest.m| script is used to test the khepera class.
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
% javaaddpath('/Users/Rowland/Dropbox/Matlab/Packages/+bot/+diffdrive/kheperaJavaDriver');

%% Parameters
name = 'K13';
id = 13;

%% Initialize robot
KK = khepera(name,id);
KK.simulate = false;
KK.record = true;
KK.init()


%% Goto
KK.goto([1;1],.1)


%%

KK.desiredState.x = 1;
KK.desiredState.y = 1;

%% Initialize figure
figH = figure(1);
clf(figH);
set(1,'Position',getFigPos('top','full'));
axH = axes;
grid(axH,'on')
xlim(axH,[-8.5 8.5])
ylim(axH,[-5.5 5.5])
axis(axH,'equal')
set(axH,'XLimMode','manual')
set(axH,'YLimMode','manual')
set(axH,'NextPlot','add')

KK.axisHandle = axH;

%% 
T = 100;
traj = @(t_) [(3*t_/T+1).*cos(2*pi*2*t_/T); (3*t_/T+1).*sin(2*pi*2*t_/T)];
point = traj(KK.time);

pointH = plot(axH,point(1),point(2),'xr');

%%
while round(KK.time,5) < 10
%     point = traj(KK.time);
%     KK.desiredState.position(1:2) = point;
    KK.update();
%     KK.plot();
%     set(pointH,'XData',point(1))
%     set(pointH,'YData',point(2))
%     drawnow
end

%%
KK.desiredState.x = -1;
KK.desiredState.y = -1;

KK.d = .01;
KK.Q = diag([10,10]);
KK.R = diag([20;1]);

while norm(KK.state.position(1:2) - KK.desiredState.position(1:2)) > .2
    KK.update();
% KK.state = KK.estimator();
% KK.input = KK.controller();
% KK.send();
% pause(KK.timeStep);
end
