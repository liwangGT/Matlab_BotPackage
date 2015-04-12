classdef khepera < bot.diffdrive.diffdrive
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
properties (Access = public)
    id
    host
    port = '4555'
    trackable = []
    kheperaInitialized = false
    trackableInitialized = false
end

properties (Access = public)
    javaHandle = []
end

% Constructor ------------------------------------------------------------------
methods
    function kheperaObj = khepera(name,id,optitrackHost,varargin)
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
        %   Need to have the khepera Java driver on the Java path.
        %   Example:
        %       javaaddpath('/Users/Rowland/Dropbox/Matlab/Packages/+bot/+diffdrive/kheperaJavaDriver');
        %
        %-----------------------------------------------------------------------

        % Apply default values
        if nargin < 1, name = ''; end;
        if nargin < 2, id = nan; end
        if nargin < 3, optitrackHost = '192.168.2.145'; end

        % Check input arguments for errors TODO: Add error checks
        % assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[1,1]),...
        %     'bot.diffdrive:khepera:arg1',...
        %     'Input argument "arg1" must be a 1 x 1 real number.')
        
        % Initialize superclass
        kheperaObj = kheperaObj@bot.diffdrive.diffdrive(varargin{:});
        
        % Assign properties
        kheperaObj.wheelRadius = 0.021; % [m]
        kheperaObj.wheelBase = 0.0885; % [m]
        kheperaObj.speedFactor = 3335.8;
        kheperaObj.motorLimits = [-60000 60000];
        
        kheperaObj.d = .01;
        kheperaObj.Q = diag([10,10]);
        kheperaObj.R = diag([20;1]);
        
        kheperaObj.id = id;
        kheperaObj.host = sprintf('192.168.1.2%02.0f',id);
        
        if ~isempty(name)
            kheperaObj.trackable = trackable.trackable(name,optitrackHost);
            kheperaObj.javaHandle = javaObject('matlab.simulator.k3.K3Driver', kheperaObj.host, int32(str2double(kheperaObj.port)));
        end
    end
end
%-------------------------------------------------------------------------------

%% Destructor ------------------------------------------------------------------
methods (Access = public)
    function delete(kheperaObj)
        % Destructor function for the "kheperaObj" class.
        %
        % SYNTAX:
        %   delete(kheperaObj)
        %
        % INPUTS:
        %   kheperaObj - (1 x 1 bot.diffdrive.khepera)
        %       An instance of the "bot.diffdrive.khepera" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        if ~isempty(kheperaObj.javaHandle)
            kheperaObj.javaHandle.mClose();
        end
    end
end
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

%% General Methods -------------------------------------------------------------
methods (Access = public)
    function result = init(kheperaObj,kheperaFlag,trackableFlag)
        % The "init" method initializes the khepera object.
        %
        % SYNTAX:
        %   result = kheperaObj.init()
        %   result = kheperaObj.init(kheperaFlag,trackableFlag)
        %
        % INPUTS:
        %   kheperaObj - (1 x 1 bot.diffdrive.khepera)
        %       An instance of the "bot.diffdrive.khepera" class.
        %
        %   kheperaFlag - (1 x 1 logical) [true]
        %       If true the khepera driver object is initialized.
        %
        %   trackableFlag - (1 x 1 logical) [true]
        %       If true the trackable object is initialized.
        %
        % OUTPUTS:
        %   result - (1 x 1 logical) 
        %       True if initialized.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        if nargin < 2; kheperaFlag = true; end
        if nargin < 3; trackableFlag = true; end

        result = true;
        if ~kheperaObj.simulate
            if kheperaFlag
                try
                    kheperaObj.javaHandle.mSendInit();
                    kheperaObj.kheperaInitialized = true;
                catch err %#ok<NASGU>
                    kheperaObj.kheperaInitialized = false;
                end
                result = kheperaObj.kheperaInitialized;
            end
            if trackableFlag
                kheperaObj.trackableInitialized = kheperaObj.trackable.init();
                result = result & kheperaObj.trackableInitialized;
            end
            if result
                kheperaObj.state = kheperaObj.estimator();
            end
        end
    end
    
    function send(kheperaObj,input)
        % The "send" method sends data to the robot.
        %
        % SYNTAX:
        %   kheperaObj.send()
        %   kheperaObj.send(input)
        %
        % INPUTS:
        %   kheperaObj - (1 x 1 bot.diffdrive.khepera)
        %       An instance of the "bot.diffdrive.khepera" class.
        %   
        %   input - (2 x 1 number)
        %       Motor input values to send to khepera.
        %
        % OUTPUTS:
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        if nargin < 2; input = kheperaObj.input; end;
        input = min(max(input,kheperaObj.motorLimits(1)),kheperaObj.motorLimits(2));
        velL = input(1);
        velR = input(2);
        kheperaObj.javaHandle.mSendControl(velR,velL)
    end
    
    function data = receive(kheperaObj)
        % The "receive" method receives data from the robot.
        %
        % SYNTAX:
        %   data = kheperaObj.receive()
        %
        % INPUTS:
        %   kheperaObj - (1 x 1 bot.diffdrive.khepera)
        %       An instance of the "bot.diffdrive.khepera" class.
        %
        % OUTPUTS:
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        data = kheperaObj.javaHandle.mRecvData();
    end
    
    function state = estimator(kheperaObj)
        % The "estimator" method returns the current state estimate for the
        % system.
        %
        % SYNTAX:
        %   time = kheperaObj.estimator()
        %
        % INPUTS:
        %   boObj - (1 x 1 bot.diffdrive.khepera)
        %       An instance of the "bot.diffdrive.khepera" class.
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
        state = kheperaObj.state;
        posPrev = state.position;
        timePrev = kheperaObj.trackable.time;
        
        kheperaObj.trackable.update();
        state.position = kheperaObj.trackable.position;
        state.orientation = kheperaObj.trackable.orientation;
        state.velocity = (state.position - posPrev) / (kheperaObj.trackable.time - timePrev);
        if isinf(abs(state.velocity))
            state.velocity = [0;0;0];
        end
    end
    
    function time = clock(kheperaObj)
        % The "clock" method returns the current time for the system.
        %
        % SYNTAX:
        %   time = kheperaObj.clock()
        %
        % INPUTS:
        %   kheperaObj - (1 x 1 bot.diffdrive.khepera)
        %       An instance of the "bot.diffdrive.khepera" class.
        %
        % OUTPUTS:
        %   time - (1 x 1 number)
        %       Current time.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        time = kheperaObj.trackable.time;
    end
    
    function stop(kheperaObj)
        % The "stop" method stops the khepera.
        %
        % SYNTAX:
        %   kheperaObj.stop()
        %
        % INPUTS:
        %   kheperaObj - (1 x 1 bot.diffdrive.khepera)
        %       An instance of the "bot.diffdrive.khepera" class.
        %
        % OUTPUTS:
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        kheperaObj.send([0;0]);
    end
    
    function [vertices,faces,colors] = defaultGraphic(~)
        % See parent class for description.
        %
        %-----------------------------------------------------------------------
        
        % Base
        vertices{1} =  [ -0.025   0.063   0;
                          0.030   0.063   0;
                          0.053   0.043   0;
                          0.070   0.010   0;
                          0.070  -0.010   0;
                          0.053  -0.043   0;
                          0.030  -0.063   0;
                         -0.025  -0.063   0;
                         -0.044  -0.043   0;
                         -0.052  -0.010   0;
                         -0.052   0.010   0;
                         -0.044   0.043   0];
        faces{1} = 1:size(vertices{1},1);
        colors{1} = [.8 .8 .8];
        
        % Top plate
        vertices{2} =  [ -0.038   0.043    0;
                         -0.038  -0.043    0;
                          0.033  -0.043    0;
                          0.052  -0.021    0;
                          0.057       0    0;
                          0.052   0.021    0;
                          0.033   0.043    0];
        faces{2} = 1:size(vertices{2},1);
        colors{2} = [0 0 0];
    end
end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
% methods (Access = public)
% 
% end
%-------------------------------------------------------------------------------
    
end
