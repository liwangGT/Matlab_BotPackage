classdef quad < bot.bot
% The "bot.quad.quad" class is for quadrotor robots.
%
% NOTES:
%   To get more information on this class type "doc bot.quad.quad" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%
% SEE ALSO:
%    bot.bot | bot.diffdrive.diffdrive
%
% AUTHOR:
%    Rowland O'Flaherty (http://rowlandoflaherty.com)
%
% VERSION: 
%   Created 29-MAY-2015
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Access = public)
    armLength = 0.125 % (1 x 1 positive number) [meters] Length of arm from quad center to motor center.
    mass = 1.2 % (1 x 1 positive number) [kilograms] Mass of quad.
    Q = eye(6); % (6 x 6 semi-postive def matrix) Q matrix for LQR controller weight.
    R = eye(3); % (3 x 3 postive def matrix) R matrix for LQR controller weight.
end
% 
% properties (Access = private)
%    prop2 % (size type) TODO: Add description
% end
% 
% properties (SetObservable = true, AbortSet = true)
%     prop3  % (size type) TODO: Add description
% end

%% Constructor -----------------------------------------------------------------
methods
    function quadObj = quad(simulate,nOutputs)
        % Constructor function for the "quad" class.
        %
        % SYNTAX:
        %   quadObj = bot.quad.quad(simulate,nOutputs)
        %
        % INPUTS:
        %   simulate - (1 x 1 logical) [true]
        %       Sets the "simulate" property.
        %
        %   nOutputs - (1 x 1 positive integer) [0]
        %       Sets the "botObj.nOutputs" property.
        %
        % OUTPUTS:
        %   quadObj - (1 x 1 bot.quad object) 
        %       A new instance of the "bot.quad" class.
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
        nInputs = 3;
        quadObj = quadObj@bot.bot(simulate,nInputs,nOutputs);
        
        % Assign properties
    end
end
%-------------------------------------------------------------------------------

%% Property Methods ------------------------------------------------------------
% methods
%     function quadObj = set.prop1(quadObj,prop1)
%         % Overloaded assignment operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %   quadObj.prop1 = prop1
%         %
%         % INPUT:
%         %   prop1 - (1 x 1 real number)
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         assert(isnumeric(prop1) && isreal(prop1) && isequal(size(prop1),[1,1]),...
%             'bot:quad:set:prop1',...
%             'Property "prop1" must be set to a 1 x 1 real number.')
% 
%         quadObj.prop1 = prop1;
%     end
%     
%     function prop1 = get.prop1(quadObj)
%         % Overloaded query operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %	  prop1 = quadObj.prop1
%         %
%         % OUTPUT:
%         %   prop1 - (1 x 1 real number)
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
% 
%         prop1 = quadObj.prop1;
%     end
% end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
% methods (Access = public)
%     function quadObj = method_name(quadObj,arg1)
%         % The "method_name" method ...
%         %
%         % SYNTAX:
%         %   quadObj = quadObj.method_name(arg1)
%         %
%         % INPUTS:
%         %   quadObj - (1 x 1 bot.quad)
%         %       An instance of the "bot.quad" class.
%         %
%         %   arg1 - (size type) [defaultArgumentValue] 
%         %       Description.
%         %
%         % OUTPUTS:
%         %   quadObj - (1 x 1 bot.quad)
%         %       An instance of the "bot.quad" class ... 
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
%             'bot:quad:method_name:arg1',...
%             'Input argument "arg1" must be a ? x ? matrix of real numbers.')
%         
%     end
%     
% end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = public)
    state = step(quadObj,timeStep,time,state,input)
    input = controller(quadObj,time,state,desiredState)
end
%-------------------------------------------------------------------------------
    
end
