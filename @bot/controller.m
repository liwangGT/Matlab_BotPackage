function input = controller(botObj,~,~,~)
% The "controller" method caluclates an input for the given time, state,
% and desired state.
%
% SYNTAX:
%   botObj = botObj.controller(time,state,desiredState)
%
% INPUTS:
%   botObj - (1 x 1 bot.bot)
%       An instance of the "bot.bot" class.
%
%   time - (1 x 1 number) [botObj.time] 
%       Current time.
%
%   state - (1 x 1 bot.State) [botObj.state] 
%       Current state.
%
%   desiredState - (1 x 1 bot.State) [botObj.desiredState] 
%       Current desired state.
%
% OUTPUTS:
%   input - (nInputs x 1 number)
%       System input.
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
% if nargin < 2, time = botObj.time; end
% if nargin < 3, state = botObj.state; end
% if nargin < 4, desiredState = botObj.desiredState; end

%% Parameters

%% Variables

%% Calculate
input = zeros(botObj.nInputs,1);

end
