function state = step(diffdriveObj,timeStep,~,state,input)
% The "step" method simulates system by one time step.
%
% SYNTAX:
%   state = diffdriveObj.step()
%   state = diffdriveObj.step(timeStep)
%   state = diffdriveObj.step(timeStep,time)
%   state = diffdriveObj.step(timeStep,time,state)
%   state = diffdriveObj.step(timeStep,time,state,input)
%   
%
% INPUTS:
%   diffdriveObj - (1 x 1 bot.DiffDrive)
%       An instance of the "bot.DiffDrive" class.
%
%   timeStep - (1 x 1 number) [diffdriveObj.timeStep] 
%       Time step duration.
%
%   time - (1 x 1 number) [diffdriveObj.time] 
%       Current time.
%
%   state - (1 x 1 state) [diffdriveObj.state] 
%       Current state.
%
%   input - (1 x 1 state) [diffdriveObj.input] 
%       Current input.
%
% OUTPUTS:
%   state - (1 x 1 state)
%       New state.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +somePackage, someFile.m
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com) 17-FEB-2015
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, timeStep = diffdriveObj.timeStep; end
% if nargin < 3, time = diffdriveObj.time; end
if nargin < 4, state = diffdriveObj.state; end
if nargin < 5, input = diffdriveObj.input; end


%% Parameters

%% Variables
x = state.x;
y = state.y;
theta = state.yaw;

%% Step
[v,w] = diffdriveObj.motorValues2linAngVel(input);

vx = v*cos(theta);
vy = v*sin(theta);

x = x + vx*timeStep;
y = y + vy*timeStep;
theta = theta + w*timeStep;

state.x = x;
state.y = y;
state.yaw = theta;
state.vx = vx;
state.vy = vy;
state.wz = w;

end
