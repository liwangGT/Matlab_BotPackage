classdef bot < handle
% The "bot.bot" class is used for creating mobile robots. In general it
% should be used as an abstract class (i.e. other more specific robot
% classes should inherit from the bot class), but it is not an abstract
% class (i.e. creating instances of the bot class is possible).
%
% NOTES:
%   To get more information on this class type "doc bot.bot" into the
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
    simulate = true; % (1 x 1 logical) If true runs in simulation.
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
    function botObj = bot(nInputs,nOutputs)
        % Constructor function for the "bot" class.
        %
        % SYNTAX:
        %   botObj = bot()
        %   botObj = bot(nInputs)
        %   botObj = bot(nInputs,nOutputs)
        %
        % INPUTS:
        %   nInputs = (1 x 1 positive integer) [0]
        %       Sets the "botObj.nInputs" property.
        %
        %   nOutputs = (1 x 1 positive integer) [0]
        %       Sets the "botObj.nOutputs" property.
        %
        % OUTPUTS:
        %   botObj - (1 x 1 bot object) 
        %       A new instance of the "bot.bot" class.
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
            'bot:bot:nInputs',...
            'Input argument "nInputs" must be a 1 x 1 positive integer.')
        
        assert(isnumeric(nOutputs) && isreal(nOutputs) && numel(nOutputs) == 1 && ...
               mod(nOutputs,1) == 0 && nOutputs >= 0,...
            'bot:bot:nOutputs',...
            'Input argument "nOutputs" must be a 1 x 1 positive integer.')
        
        % Assign properties
        botObj.nInputs = nInputs;
        botObj.nOutputs = nOutputs;
        botObj.ticID = tic;
        botObj.timeStep = .1;
        botObj.time = 0;
        botObj.state = bot.state;
        botObj.desiredState = bot.state;
        botObj.tape = bot.trajectory(nInputs);
    end
end
%-------------------------------------------------------------------------------

%% Property Methods ------------------------------------------------------------
methods
    function set.time(botObj,time) 
        assert(isnumeric(time) && isreal(time) && numel(time) == 1,...
            'bot:bot:set:time',...
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
        %   botObj - (1 x 1 bot.bot)
        %       An instance of the "bot.bot" class.
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
        %   botObj - (1 x 1 bot.bot)
        %       An instance of the "bot.bot" class.
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
    
    function input = controller(botObj,~,~,~)
        % The "controller" method caluclates an input for the given time, state,
        % and desired state.
        %
        % SYNTAX:
        %   botObj = botObj.controller(time,state,desiredState)
        %
        % INPUTS:
        %   botObj - (1 x 1 bot.bot)
        %       An instance of the "bot.bot" class.
        %
        %   time - (1 x 1 number) [botObj.time] 
        %       Current time.
        %
        %   state - (1 x 1 bot.State) [botObj.state] 
        %       Current state.
        %
        %   desiredState - (1 x 1 bot.State) [botObj.desiredState] 
        %       Current desired state.
        %
        % OUTPUTS:
        %   input - (nInputs x 1 number)
        %       System input.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        input = zeros(botObj.nInputs,1);
    end
    
    function state = step(botObj,~,~,~,~)
        % The "step" method simulates system forward by one time step.
        %
        % SYNTAX:
        %   state = botObj.step(timeStep,time,state,input)
        %   
        %
        % INPUTS:
        %   botObj - (1 x 1 bot.bot)
        %       An instance of the "bot.bot" class.
        %
        %   timeStep - (1 x 1 number) [botObj.timeStep] 
        %       Time step duration.
        %
        %   time - (1 x 1 number) [botObj.time] 
        %       Current time.
        %
        %   state - (1 x 1 state) [botObj.state] 
        %       Current state.
        %
        %   input - (1 x 1 state) [botObj.input] 
        %       Current input.
        %
        % OUTPUTS:
        %   state - (1 x 1 state)
        %       New state at one time step forward.
        %
        % NOTES:
        %
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
        %   botObj - (1 x 1 bot.bot)
        %       An instance of the "bot.bot" class.
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
end
%-------------------------------------------------------------------------------
    
end
