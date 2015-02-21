classdef Khepera < bot.diffdrive.DiffDrive
% The "bot.diffdrive.khepera" class is for the Khephera robot.
%
% NOTES:
%   To get more information on this class type "doc bot.diffdrive.khepera" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%   @diffdrive, @bot.diffdrive, @quaternion
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 16-FEB-2015
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties%     name
%     id
%     robotIP
%     robotPort = '4555'
%     optiIP
%     optiPort = '3883'

end

% Constructor ------------------------------------------------------------------
methods
    function kheperaObj = Khepera(name,id,optiIP,varargin)
%     function kheperaObj = Khepera(name,id,optiIP,varargin)
        % Constructor function for the "khepera" class.
        %
        % SYNTAX: TODO: Add syntax
        %   kheperaObj = bot.diffdrive.khepera(arg1,[superClass arguments])
        %
        % INPUTS: TODO: Add inputs
        %   arg1 - (size type) [defaultArg1Value] 
        %       Sets the "kheperaObj.prop1" property.
        %
        % OUTPUTS:
        %   kheperaObj - (1 x 1 bot.diffdrive.khepera object) 
        %       A new instance of the "bot.diffdrive.khepera" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments TODO: Add number argument check
        narginchk(0,3)

        % Apply default values TODO: Add apply defaults
        % if nargin < 1, arg1 = 0; end

        % Check input arguments for errors TODO: Add error checks
        % assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[1,1]),...
        %     'bot.diffdrive:khepera:arg1',...
        %     'Input argument "arg1" must be a 1 x 1 real number.')
        
        % Initialize superclass TODO: Initialize superclass
        kheperaObj = kheperaObj@bot.diffdrive.DiffDrive(varargin{:});
        
        % Assign properties
        kheperaObj.wheelRadius = 0.021; % [m]
        kheperaObj.wheelBase = 0.0885; % [m]
        kheperaObj.speedFactor = 3335.8;
        kheperaObj.motorLimits = [-60000 60000];
        
%         kheperaObj.name = name;
%         kheperaObj.id = id;
%         kheperaObj.robotIP = sprintf('192.168.1.2%02.0f',id);
%         kheperaObj.robotPort = '4555';
%         kheperaObj.optiIP;
%         kheperaObj.optiPort = '3883';
        
    end
end
%-------------------------------------------------------------------------------

%% Destructor ------------------------------------------------------------------
% methods (Access = public)
%     function delete(kheperaObj)
%         % Destructor function for the "kheperaObj" class.
%         %
%         % SYNTAX:
%         %   delete(kheperaObj)
%         %
%         % INPUTS:
%         %   kheperaObj - (1 x 1 bot.diffdrive.khepera)
%         %       An instance of the "bot.diffdrive.khepera" class.
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         
%     end
% end
%-------------------------------------------------------------------------------

%% Property Methods ------------------------------------------------------------
% methods
%     function kheperaObj = set.prop1(kheperaObj,prop1)
%         % Overloaded assignment operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %   kheperaObj.prop1 = prop1
%         %
%         % INPUT:
%         %   prop1 - (1 x 1 real number)
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         assert(isnumeric(prop1) && isreal(prop1) && isequal(size(prop1),[1,1]),...
%             'bot.diffdrive:khepera:set:prop1',...
%             'Property "prop1" must be set to a 1 x 1 real number.')
% 
%         kheperaObj.prop1 = prop1;
%     end
%     
%     function prop1 = get.prop1(kheperaObj)
%         % Overloaded query operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %	  prop1 = kheperaObj.prop1
%         %
%         % OUTPUT:
%         %   prop1 - (1 x 1 real number)
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
% 
%         prop1 = kheperaObj.prop1;
%     end
% end
%-------------------------------------------------------------------------------

%% Listener Methods ------------------------------------------------------------
% methods (Access = public)
%     function eventNameEvent(kheperaObj,sourceObj,eventData)
%         % Listener response to the "eventName" event.
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         
%     end
% end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
% methods (Access = public)
%     function kheperaObj = method_name(kheperaObj,arg1)
%         % The "method_name" method ...
%         %
%         % SYNTAX:
%         %   kheperaObj = kheperaObj.method_name(arg1)
%         %
%         % INPUTS:
%         %   kheperaObj - (1 x 1 bot.diffdrive.khepera)
%         %       An instance of the "bot.diffdrive.khepera" class.
%         %
%         %   arg1 - (size type) [defaultArgumentValue] 
%         %       Description.
%         %
%         % OUTPUTS:
%         %   kheperaObj - (1 x 1 bot.diffdrive.khepera)
%         %       An instance of the "bot.diffdrive.khepera" class ... 
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
%             'bot.diffdrive:khepera:method_name:arg1',...
%             'Input argument "arg1" must be a ? x ? matrix of real numbers.')
%         
%     end
%     
% end
%-------------------------------------------------------------------------------

%% Converting Methods ----------------------------------------------------------
% methods
%     function anOtherObject = otherObject
%         % Function to convert khepera object to a otherObject object.
%         %
%         % SYNTAX:
%         %	  otherObject(kheperaObj)
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         
% 
%     end
% 
% end
%-------------------------------------------------------------------------------

%% Abstract Methods ------------------------------------------------------------
% methods (Abstract = true)
%     %  The "method_name" method . . .  TODO: Add description
%     %
%     % SYNTAX: TODO: Add syntax
%     %   kheperaObj = kheperaObj.method_name(arg1)
%     %
%     % INPUTS: TODO: Add inputs
%     %   kheperaObj - (1 x 1 bot.diffdrive.khepera)
%     %       An instance of the "bot.diffdrive.khepera" class.
%     %
%     %   arg1 - (size type) [defaultArgumentValue] 
%     %       Description.
%     %
%     % OUTPUTS: TODO: Add outputs
%     %   kheperaObj - (1 x 1 bot.diffdrive.khepera)
%     %       An instance of the "bot.diffdrive.khepera" class . . . ???.
%     %
%     % NOTES:
%     %
%     %---------------------------------------------------------------------------
%     output = someAbstractMethod(kheperaObj,arg1)
% end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
% methods (Access = public)
%     kheperaObj = someMethod(kheperaObj,arg1)
% end
%-------------------------------------------------------------------------------
    
end
