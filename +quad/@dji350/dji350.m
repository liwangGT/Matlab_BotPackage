classdef dji350 < bot.quad.quad
% The "bot.quad.dji350" class is for the DJI 350 quad robot.
%
% NOTES:
%   To get more information on this class type "doc bot.quad.dji350" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%   @quad, @quaternion
%
% SEE ALSO:
%    bot.quad.dji350
%
% AUTHOR:
%    Rowland O'Flaherty (http://rowlandoflaherty.com)
%
% VERSION: 
%   Created 29-MAY-2015
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Access = public)
    id
    host
    port = 4655
    trackable = []
    quadInitialized = false
    trackableInitialized = false
end

properties (Access = public)
    udpObj = []
end

%% Constructor -----------------------------------------------------------------
methods
    function dji350Obj = dji350(simulate,name,id,optitrackHost,rosHost)
        % Constructor function for the "dji350" class.
        %
        % SYNTAX:
        %   dji350Obj = bot.quad.dji350(arg1,[superClass arguments])
        %
        % INPUTS:
        %   simulate - (1 x 1 logical) [true]
        %       Sets the "simulate" property.
        %
        %   name - (string) ['']
        %       Sets the "name" property.
        %
        %   id - (1 x 1 positive integer or nan) [1]
        %       Sets the "id" property.
        %
        %   optitrackHost - (string) ['192.168.2.145']
        %       Sets the "optitrackHost" property.
        %
        %   rosHost - (string) ['192.168.1.15']
        %       Sets the "host" property. 
        %
        % OUTPUTS:
        %   dji350Obj - (1 x 1 bot.quad.dji350 object) 
        %       A new instance of the "bot.quad.dji350" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(0,5)

        % Apply default values
        if nargin < 1, simulate = true; end;
        if nargin < 2, name = ''; end;
        if nargin < 3, id = 1; end
        if nargin < 4, optitrackHost = '192.168.2.145'; end
        if nargin < 5, rosHost = '192.168.1.15'; end

        % Check input arguments for errors TODO: Add error checks
        % assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[1,1]),...
        %     'bot:quad:dji350:arg1',...
        %     'Input argument "arg1" must be a 1 x 1 real number.')
        
        % Initialize superclass
        dji350Obj = dji350Obj@bot.quad.quad(simulate,0);
        
        % Assign properties
        dji350Obj.armLength = 0.175;
        
        dji350Obj.id = id;
        dji350Obj.host = rosHost;
        
        if ~isempty(name)
            dji350Obj.trackable = trackable.trackable(simulate,name,optitrackHost);
            dji350Obj.udpObj = udp(rosHost,dji350Obj.port);
        end
    end
end
%-------------------------------------------------------------------------------

%% Destructor ------------------------------------------------------------------
methods (Access = public)
    function delete(dji350Obj)
        % Destructor function for the "dji350Obj" class.
        %
        % SYNTAX:
        %   delete(dji350Obj)
        %
        % INPUTS:
        %   dji350Obj - (1 x 1 bot.dji350)
        %       An instance of the "bot.dji350" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        if ~isempty(dji350Obj.udpObj)
            fclose(dji350Obj.udpObj);
            delete(dji350Obj.udpObj);
        end
    end
end
%-------------------------------------------------------------------------------

%% Property Methods ------------------------------------------------------------
% methods
%     function dji350Obj = set.prop1(dji350Obj,prop1)
%         % Overloaded assignment operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %   dji350Obj.prop1 = prop1
%         %
%         % INPUT:
%         %   prop1 - (1 x 1 real number)
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         assert(isnumeric(prop1) && isreal(prop1) && isequal(size(prop1),[1,1]),...
%             'bot:dji350:set:prop1',...
%             'Property "prop1" must be set to a 1 x 1 real number.')
% 
%         dji350Obj.prop1 = prop1;
%     end
%     
%     function prop1 = get.prop1(dji350Obj)
%         % Overloaded query operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %	  prop1 = dji350Obj.prop1
%         %
%         % OUTPUT:
%         %   prop1 - (1 x 1 real number)
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
% 
%         prop1 = dji350Obj.prop1;
%     end
% end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
methods (Access = public)
    function result = init(dji350Obj,quadFlag,trackableFlag)
        % The "method_name" method initializes the dji350 object.
        %
        % SYNTAX:
        %   result = dji350Obj.init()
        %   result = dji350Obj.init(quadFlag,trackableFlag)
        %
        % INPUTS:
        %   dji350Obj - (1 x 1 bot.quad.dji350)
        %       An instance of the "bot.quad.dji350" class.
        %
        %   quadFlag - (1 x 1 logical) [true]
        %       If true the khepera driver object is initialized.
        %
        %   trackableFlag - (1 x 1 logical) [true]
        %       If true the trackable object is initialized..
        %
        % OUTPUTS:
        %   result - (1 x 1 logical) 
        %       True if initialized.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------

        % Check number of arguments
        narginchk(1,3)
        
        % Apply default values
        if nargin < 2; quadFlag = true; end
        if nargin < 3; trackableFlag = true; end
        
        % % Check arguments for errors
        % assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[?,?]),...
        %     'bot:dji350:method_name:arg1',...
        %     'Input argument "arg1" must be a ? x ? matrix of real numbers.')
        
        result = true;
        if ~dji350Obj.simulate
            if quadFlag
                try
                    fopen(dji350Obj.udpObj);
                    dji350Obj.quadInitialized = true;
                catch err %#ok<NASGU>
                    dji350Obj.kheperaInitialized = false;
                end
                result = dji350Obj.kheperaInitialized;
            end
            if trackableFlag
                dji350Obj.trackableInitialized = dji350Obj.trackable.init();
                result = result & dji350Obj.trackableInitialized;
            end
            if result
                dji350Obj.state = dji350Obj.estimator();
            end
        end
        
    end
    
    function send(dji350Obj,input)
        % The "send" method sends data to the robot.
        %
        % SYNTAX:
        %   dji350Obj.send()
        %   dji350Obj.send(input)
        %
        % INPUTS:
        %   dji350Obj - (1 x 1 bot.quad.dji350)
        %       An instance of the "bot.quad.dji350" class.
        %   
        %   input - (2 x 1 number)
        %       Motor input values to send to the quad.
        %
        % OUTPUTS:
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        if nargin < 2; input = dji350Obj.input; end;
        
    end
    
    function data = receive(dji350Obj)
        % The "receive" method receives data from the robot.
        %
        % SYNTAX:
        %   data = dji350Obj.receive()
        %
        % INPUTS:
        %   dji350Obj - (1 x 1 bot.quad.dji350)
        %       An instance of the "bot.quad.dji350" class.
        %
        % OUTPUTS:
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        data = [];
    end
    
    function state = estimator(dji350Obj)
        % The "estimator" method returns the current state estimate for the
        % system.
        %
        % SYNTAX:
        %   time = dji350Obj.estimator()
        %
        % INPUTS:
        %   boObj - (1 x 1 bot.quad.dji350)
        %       An instance of the "bot.quad.dji350" class.
        %
        % OUTPUTS:
        %   state - (1 x 1 state)
        %       Current state estimate.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % FIXME: This should only happen if trackable is being used.
        % Otherwise the state should be estimated some other way.
        state = dji350Obj.state;
        posPrev = state.position;
        timePrev = dji350Obj.trackable.time;
        
        dji350Obj.trackable.update();
        state.position = dji350Obj.trackable.position;
        state.orientation = dji350Obj.trackable.orientation;
        state.velocity = (state.position - posPrev) / (dji350Obj.trackable.time - timePrev);
        if isinf(abs(state.velocity))
            state.velocity = [0;0;0];
        end
    end
    
    function time = clock(dji350Obj)
        % The "clock" method returns the current time for the system.
        %
        % SYNTAX:
        %   time = dji350Obj.clock()
        %
        % INPUTS:
        %   dji350Obj - (1 x 1 bot.quad.dji350)
        %       An instance of the "bot.quad.dji350" class.
        %
        % OUTPUTS:
        %   time - (1 x 1 number)
        %       Current time.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        time = dji350Obj.trackable.time;
    end
    
end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
% methods (Access = public)
%     dji350Obj = someMethod(dji350Obj,arg1)
% end
%-------------------------------------------------------------------------------
    
end
