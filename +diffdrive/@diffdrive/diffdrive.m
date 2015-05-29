classdef diffdrive < bot.bot
% The "bot.diffdrive.diffdrive" class is for differential drive robots.
%
% NOTES:
%   To get more information on this class type "doc bot.diffdrive.diffdrive" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%
% SEE ALSO:
%    bot.bot | bot.quad.quad
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 17-FEB-2015
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Access = public)
    wheelRadius = 0.01 % (1 x 1 positive number) [meters] Radius of robot wheel.
    wheelBase = 0.1 % (1 x 1 positive number) [meters] Wheel base length of robot.
    speedFactor = 1; % (1 x 1 number) Conversion factor between wheel angular velocities and motor speeds
    d = .1; % (1 x 1 positive number) Diffeomorphic distance from center of robot.
    Q = diag([10 10]); % (2 x 2 semi-postive def matrix) Q matrix for LQR controller weight.
    R = diag([1 10]); % (2 x 2 postive def matrix) R matrix for LQR controller weight.
end

properties (GetAccess = public, SetAccess = public)    
    motorLimits = [-100 100] % (1 x 2 integers) Minimum and maximum motor values.
end

%% Constructor -----------------------------------------------------------------
methods
    function diffdriveObj = diffdrive(simulate,nOutputs)
        % Constructor function for the "diffdrive" class.
        %
        % SYNTAX:
        %   diffdriveObj = bot.diffdrive.diffdrive(simulate,nOutputs)
        %
        % INPUTS:
        %   simulate - (1 x 1 logical) [true]
        %       Sets the "simulate" property.
        %
        %   nOutputs - (1 x 1 positive integer) [0]
        %       Sets the "botObj.nOutputs" property.
        %
        % OUTPUTS:
        %   diffdriveObj - (1 x 1 bot.diffdrive object) 
        %       A new instance of the "bot.diffdrive" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(0,2)

        % Apply default values
        if nargin < 1, simulate = true; end
        if nargin < 2, nOutputs = 0; end
        
        % Initialize superclass
        nInputs = 2;
        diffdriveObj = diffdriveObj@bot.bot(simulate,nInputs,nOutputs);
        
        % Assign properties
    end
end
%-------------------------------------------------------------------------------

%% Property Methods ------------------------------------------------------------
% methods
%     function diffdriveObj = set.prop1(diffdriveObj,prop1)
%         assert(isnumeric(prop1) && isreal(prop1) && isequal(size(prop1),[1,1]),...
%             'bot:diffdrive:set:prop1',...
%             'Property "prop1" must be set to a 1 x 1 real number.')
% 
%         diffdriveObj.prop1 = prop1;
%     end
%     
%     function prop1 = get.prop1(diffdriveObj) 
%         prop1 = diffdriveObj.prop1;
%     end
% end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
methods (Access = public)
    function goto(diffdriveObj,desiredPoint,ballSize)
        % The "goto" method drives the robot to the "desiredPoint" and stops
        % when the robot is within a distance of "ballSize" of the point.
        %
        % SYNTAX:
        %   time = diffdriveObj.clock()
        %
        % INPUTS:
        %   diffdriveObj - (1 x 1 bot.diffdrive.diffdrive)
        %       An instance of the "bot.diffdrive.diffdrive" class.
        %
        %   desiredPoint - (2 x 1 number)
        %       Desired point to goto.
        %
        %   ballSize - (2 x 1 number)
        %       Ball size of goal point.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        diffdriveObj.state = diffdriveObj.estimator();
        diffdriveObj.desiredState.position(1:2) = desiredPoint;
        
        while norm(diffdriveObj.desiredState.position(1:2) - diffdriveObj.state.position(1:2)) > ballSize
            diffdriveObj.update()
        end
        
    end
    
    function [vertices,faces,colors] = defaultGraphic(~)
        % See parent class for description.
        %
        %-----------------------------------------------------------------------
        
        % Body
        n = 32;
        t = linspace(0,2*pi*(1-1/n),n)';
        vertices{1} = .1*[cos(t),sin(t),zeros(n,1)];
        faces{1} = 1:n;
        colors{1} = [.8 .8 .8];
        
        % Wheels
        vertices{2} = [.1 .11 0;...
                       .1 .13 0;...
                       -.1 .13 0;...
                       -.1 .11 0;...
                       .1 -.11 0;...
                       .1 -.13 0;...
                       -.1 -.13 0;...
                       -.1 -.11 0];
        faces{2} = [1:4;5:8];
        colors{2} = [0 0 0];
        
        % Nose
        vertices{3} = [.11 -.05;...
                      .11  .05;...
                      .15  0];
        faces{3} = 1:3;
        colors{3} = [0 0 0];
    end
end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = public)
    motorValues = linAngVel2motorValues(diffdriveObj,linVel,angVel)
    [linVel,angVel] = motorValues2linAngVel(diffdriveObj,motorValues)
    
    state = step(diffdriveObj,timeStep,time,state,input)
    input = controller(diffdriveObj,time,state,desiredState)
end
%-------------------------------------------------------------------------------
    
end
