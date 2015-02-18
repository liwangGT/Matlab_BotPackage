function state = step(botObj,~,~,state,~)
% The "step" method simulates system by one time step.
%
% SYNTAX:
%   state = botObj.step()
%   state = botObj.step(timeStep)
%   state = botObj.step(timeStep,time)
%   state = botObj.step(timeStep,time,state)
%   state = botObj.step(timeStep,time,state,input)
%   
%
% INPUTS:
%   botObj - (1 x 1 Bot.bot)
%       An instance of the "Bot.bot" class.
%
%   timeStep - (1 x 1 number) [botObj.timeStep] 
%       Time step duration.
%
%   time - (1 x 1 number) [botObj.time] 
%       Current time.
%
%   state - (1 x 1 state) [botObj.state] 
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
% if nargin < 2, timeStep = botObj.timeStep; end
% if nargin < 3, time = botObj.time; end
if nargin < 4, state = botObj.state; end
% if nargin < 5, input = botObj.input; end

%% Parameters

%% Variables

%% Step


end
