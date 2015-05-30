function state = step(quadObj,timeStep,~,state,input)
% The "step" method simulates system by one time step.
%
% SYNTAX:
%   state = quadObj.step()
%   state = quadObj.step(timeStep)
%   state = quadObj.step(timeStep,time)
%   state = quadObj.step(timeStep,time,state)
%   state = quadObj.step(timeStep,time,state,input)
%   
%
% INPUTS:
%   quadObj - (1 x 1 bot.DiffDrive)
%       An instance of the "bot.DiffDrive" class.
%
%   timeStep - (1 x 1 number) [quadObj.timeStep] 
%       Time step duration.
%
%   time - (1 x 1 number) [quadObj.time] 
%       Current time.
%
%   state - (1 x 1 state) [quadObj.state] 
%       Current state.
%
%   input - (1 x 1 state) [quadObj.input] 
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
if nargin < 2, timeStep = quadObj.timeStep; end
% if nargin < 3, time = quadObj.time; end
if nargin < 4, state = quadObj.state; end
if nargin < 5, input = quadObj.input; end


%% Parameters

%% Variables
p = state.position;
v = state.velocity;
f = input(1:3);
m = quadObj.mass;

%% Step
a = f / m;

v = v + a*timeStep;
p = p + v*timeStep;

state.position = p;
state.velocity = v;

end
