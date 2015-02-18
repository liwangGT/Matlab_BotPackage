classdef Controller
% The "bot.Controller" class ... TODO: Add description
%
% NOTES:
%   To get more information on this class type "doc bot.Controller" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +somePackage, someFile.m
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 17-FEB-2015
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
% properties (GetAccess = public, SetAccess = private)    
%     nInputs % (1 x 1 positive integer) Number of inputs to the system.
% end

%% Constructor -----------------------------------------------------------------
% methods
%     function controllerObj = Controller(nInputs)
%         % Constructor function for the "Controller" class.
%         %
%         % SYNTAX:
%         %   controllerObj = bot.Controller(nInputs)
%         %
%         % INPUTS:
%         %   nInputs = (1 x 1 positive integer) [1]
%         %       Sets the "controllerObj.nInputs" property.
%         %
%         % OUTPUTS:
%         %   controllerObj - (1 x 1 bot.Controller object) 
%         %       A new instance of the "bot.Controller" class.
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         
%         % Check number of arguments
%         narginchk(0,1)
% 
%         % Apply default values
%         if nargin < 1, nInputs = 1; end
% 
%         % Check input arguments for errors
%         assert(isnumeric(nInputs) && isreal(nInputs) && numel(nInputs) == 1 && ...
%                mod(nInputs,1) == 0 && nInputs >= 0,...
%             'Bot:Bot:nInputs',...
%             'Input argument "nInputs" must be a 1 x 1 positive integer.')
% 
%         % Assign properties
%         controllerObj.nInputs = nInputs;
%     end
% end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
methods (Access = public)
    function input = func(~,botObj)
        % The "func" method is the function that returns the input given
        % the time, state, and setpoint.
        %
        % SYNTAX:
        %   controllerObj = controllerObj.func(botObj)
        %
        % INPUTS:
        %   controllerObj - (1 x 1 bot.Controller)
        %       An instance of the "bot.Controller" class.
        %
        %   botObj - (1 x 1 bot.Bot)
        %       Bot to control.
        %
        % OUTPUTS:
        %   input - (nInputs x 1 number)
        %       Input vector.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        input = zeros(botObj.nInputs,1);
        
    end
end
%-------------------------------------------------------------------------------

end
