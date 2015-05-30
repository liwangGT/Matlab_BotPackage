function input = controller(quadObj,~,state,desiredState)
% The "controller" method caluclates an input for the given time, state,
% and desired state.
%
% SYNTAX:
%   quadObj = quadObj.controller(time,state,desiredState)
%
% INPUTS:
%   quadObj - (1 x 1 bot.bot)
%       An instance of the "bot.bot" class.
%
%   time - (1 x 1 number) [quadObj.time] 
%       Current time.
%
%   state - (1 x 1 bot.State) [quadObj.state] 
%       Current state.
%
%   desiredState - (1 x 1 bot.State) [quadObj.desiredState] 
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
% if nargin < 2, time = quadObj.time; end
if nargin < 3, state = quadObj.state; end
if nargin < 4, desiredState = quadObj.desiredState; end

%% Parameters
Q = quadObj.Q;
R = quadObj.R;
m = quadObj.mass;

%% Variables
% System state
x = [state.position; state.velocity];
xBar = [desiredState.position; zeros(3,1)]; % Setpoint
xTilde = xBar - x;

% Linearization
A = [zeros(3) eye(3); zeros(3) zeros(3)];
B = [zeros(3); 1/m*eye(3)];

%% Calculate
K = lqr(A,B,Q,R);
u = K*xTilde;

input = u;

end
