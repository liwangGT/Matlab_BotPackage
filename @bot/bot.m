classdef Bot < handle
% The "bot.Bot" class is used for mobile robots.
%
% NOTES:
%   To get more information on this class type "doc Bot.Bot" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +bot, quaternion.m
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 16-FEB-2012
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Access = public)
    name = '' % (string) Name of bot.
    state % (1 x 1 bot.State) Current state.
    input % (nInputs x 1 number) Current input.
    output % (nOutputs x 1 number) Current ouput.
    desiredState % (1 x 1 bot.State) Desired state.
    timeStep % (1 x 1 positive number) Time step duration.
    simulate = true; % (1 x 1 logical) If true simulation is run.
    record = false % (1 x 1 logical) If true tape recorder is on.
end

properties (Access = protected)
    ticID % (1 x 1 number) Tic ID used with toc to get current running time.
end

properties (Access = public, Hidden = true)
    timeRaw = nan % (1 x 1 number) Raw time data.
    timeOffset = 0 % (1 x 1 number) Time offset.
end

properties (Dependent = true, SetAccess = public)
    time % (1 x 1 number) Current time.
end

properties (GetAccess = public, SetAccess = private)    
    nInputs % (1 x 1 positive integer) Number of inputs to the system.
    nOutputs % (1 x 1 positive integer) Number of outputs to the system.
    tape % (1 x 1 trajectory) Tape recording of past time and poses.
end

properties (Access = public, Hidden = true)
    figHandle = [] % (1 x 1 graphics object) Figure handle for plot
    axisHandle = [] % (1 x 1 graphics object) Axis handle for plot
    graphicsHandles = [] % (? x 1 graphics objects) Graphics handles for plot
end

%% Constructor -----------------------------------------------------------------
methods
    function botObj = Bot(nInputs,nOutputs)
        % Constructor function for the "Bot" class.
        %
        % SYNTAX:
        %   botObj = Bot()
        %   botObj = Bot(nInputs)
        %   botObj = Bot(nInputs,nOutputs)
        %
        % INPUTS:
        %   nInputs = (1 x 1 positive integer) [0]
        %       Sets the "botObj.nInputs" property.
        %
        %   nOutputs = (1 x 1 positive integer) [0]
        %       Sets the "botObj.nOutputs" property.
        %
        % OUTPUTS:
        %   botObj - (1 x 1 Bot object) 
        %       A new instance of the "bot.Bot" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(0,2)

        % Apply default values
        if nargin < 1, nInputs = 0; end
        if nargin < 2, nOutputs = 0; end

        % Check input arguments for errors
        assert(isnumeric(nInputs) && isreal(nInputs) && numel(nInputs) == 1 && ...
               mod(nInputs,1) == 0 && nInputs >= 0,...
            'Bot:Bot:nInputs',...
            'Input argument "nInputs" must be a 1 x 1 positive integer.')
        
        assert(isnumeric(nOutputs) && isreal(nOutputs) && numel(nOutputs) == 1 && ...
               mod(nOutputs,1) == 0 && nOutputs >= 0,...
            'Bot:Bot:nOutputs',...
            'Input argument "nOutputs" must be a 1 x 1 positive integer.')
        
        % Assign properties
        botObj.nInputs = nInputs;
        botObj.nOutputs = nOutputs;
        botObj.ticID = tic;
        botObj.timeStep = .1;
        botObj.time = 0;
        botObj.state = bot.State;
        botObj.desiredState = bot.State;
        botObj.tape = bot.Trajectory(nInputs);
    end
end
%-------------------------------------------------------------------------------

%% Property Methods ------------------------------------------------------------
methods
    function set.time(botObj,time) 
        assert(isnumeric(time) && isreal(time) && numel(time) == 1,...
            'Bot:Bot:set:time',...
            'Property "time" must be set to a 1 x 1 real number.')
        
        if isnan(botObj.timeRaw)
            botObj.timeRaw = time;
        end
        botObj.timeOffset = botObj.timeRaw - time;
        
    end    

    function time = get.time(botObj)
        time = botObj.timeRaw - botObj.timeOffset;
    end

end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
methods (Access = public)
    function time = clock(botObj)
        % The "clock" method returns the current time for the system.
        %
        % SYNTAX:
        %   time = botObj.clock()
        %
        % INPUTS:
        %   botObj - (1 x 1 bot.Bot)
        %       An instance of the "bot.Bot" class.
        %
        % OUTPUTS:
        %   time - (1 x 1 number)
        %       Current time.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        time = toc(botObj.ticID);
    end
    
    function state = estimator(botObj)
        % The "estimator" method returns the current state estimate for the
        % system.
        %
        % SYNTAX:
        %   state = botObj.estimator()
        %
        % INPUTS:
        %   botObj - (1 x 1 bot.Bot)
        %       An instance of the "bot.Bot" class.
        %
        % OUTPUTS:
        %   state - (1 x 1 state)
        %       Current state estimate.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        state = botObj.state;
    end
    
    function send(~)
        % The "send" method sends data to the robot.
        %
        % SYNTAX:
        %   time = botObj.estimator()
        %
        % INPUTS:
        %   botObj - (1 x 1 bot.Bot)
        %       An instance of the "bot.Bot" class.
        %
        % OUTPUTS:
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
    end
end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = public)
    update(botObj,timeRaw,positionRaw,orientationRaw)
    state = step(botObj,timeStep,time,state,input)
    input = controller(botObj,time,state,desiredState)
end
%-------------------------------------------------------------------------------
    
end
