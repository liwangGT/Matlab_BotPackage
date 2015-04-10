function input = controller(diffdriveObj,~,state,desiredState)
% The "controller" method caluclates an input for the given time, state,
% and desired state.
%
% SYNTAX:
%   diffdriveObj = diffdriveObj.controller(time,state,desiredState)
%
% INPUTS:
%   diffdriveObj - (1 x 1 bot.bot)
%       An instance of the "bot.bot" class.
%
%   time - (1 x 1 number) [diffdriveObj.time] 
%       Current time.
%
%   state - (1 x 1 bot.State) [diffdriveObj.state] 
%       Current state.
%
%   desiredState - (1 x 1 bot.State) [diffdriveObj.desiredState] 
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
% if nargin < 2, time = diffdriveObj.time; end
if nargin < 3, state = diffdriveObj.state; end
if nargin < 4, desiredState = diffdriveObj.desiredState; end

%% Parameters
d = diffdriveObj.d;
Q = diffdriveObj.Q;
R = diffdriveObj.R;

%% Variables
% System state
x = state.position(1:2);
theta = state.orientation.yaw;
xBar = desiredState.position(1:2); % Setpoint
xTilde = xBar - x;
thetaBar = atan2(xTilde(2),xTilde(1));

% Diffmorphic state
z = x + d*[cos(theta); sin(theta)];
zBar = xBar + d*[cos(thetaBar); sin(thetaBar)];
zTilde = (z - zBar);

% Linearization
A = zeros(2);
B = @(theta_) [cos(theta_) -d*sin(theta_); sin(theta_) d*cos(theta_)];

%% Calculate
K = lqr(A,B(theta),Q,R);
u = -K*zTilde;

v = u(1);
w = u(2);

input = diffdriveObj.linAngVel2motorValues(v,w);

end
