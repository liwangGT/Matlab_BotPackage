classdef DiffDrive < bot.Bot
% The "bot.DiffDrive" classis for differential drive robots.
%
% NOTES:
%   To get more information on this class type "doc bot.DiffDrive" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +bot
%
% SEE ALSO: TODO: Add see alsos
%    bot.Bot | relatedFunction2
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
end

properties (GetAccess = public, SetAccess = public)    
    motorLimits = [-100 100] % (1 x 2 integers) Minimum and maximum motor values.
end

%% Constructor -----------------------------------------------------------------
methods
    function diffdriveObj = DiffDrive(nOutputs)
        % Constructor function for the "DiffDrive" class.
        %
        % SYNTAX:
        %   diffdriveObj = bot.DiffDrive(nOutputs)
        %
        % INPUTS:
        %   nOutputs = (1 x 1 positive integer) [0]
        %       Sets the "botObj.nOutputs" property.
        %
        % OUTPUTS:
        %   diffdriveObj - (1 x 1 bot.DiffDrive object) 
        %       A new instance of the "bot.DiffDrive" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(0,1)

        % Apply default values
        if nargin < 1, nOutputs = 0; end
        
        % Initialize superclass
        nInputs = 2;
        diffdriveObj = diffdriveObj@bot.Bot(nInputs,nOutputs);
        
        % Assign properties
    end
end
%-------------------------------------------------------------------------------

%% Property Methods ------------------------------------------------------------
% methods
%     function diffdriveObj = set.prop1(diffdriveObj,prop1)
%         assert(isnumeric(prop1) && isreal(prop1) && isequal(size(prop1),[1,1]),...
%             'bot:DiffDrive:set:prop1',...
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
% methods (Access = public)
%     function diffdriveObj = method_name(diffdriveObj,arg1)
%         % The "method_name" method ...
%         %
%         % SYNTAX:
%         %   diffdriveObj = diffdriveObj.method_name(arg1)
%         %
%         % INPUTS:
%         %   diffdriveObj - (1 x 1 bot.DiffDrive)
%         %       An instance of the "bot.DiffDrive" class.
%         %
%         %   arg1 - (size type) [defaultArgumentValue] 
%         %       Description.
%         %
%         % OUTPUTS:
%         %   diffdriveObj - (1 x 1 bot.DiffDrive)
%         %       An instance of the "bot.DiffDrive" class ... 
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
% 
%         % Check number of arguments
%         narginchk(1,2)
%         
%         % Apply default values
%         if nargin < 2, arg1 = 0; end
%         
%         % Check arguments for errors
%         assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[?,?]),...
%             'bot:DiffDrive:method_name:arg1',...
%             'Input argument "arg1" must be a ? x ? matrix of real numbers.')
%         
%     end
%     
% end
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
