classdef bot < handle
% The "bot.bot" class is used for mobile robots.
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
    state % (1 x 1 state) Current state.
    input % (nInputs x 1 number) Current input.
    output % (nOutputs x 1 number) Current ouput.
    timeStep % (1 x 1 positive number) Time step duration.
    simulate = true; % (1 x 1 logical) If true simulation is run.
    record = false % (1 x 1 logical) If true tape recorder is on.
end

properties (Access = public)
    controller % (1 x 1 function pointer) input = controller(obj,setpoint)
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
            'Input argument "nInputs" must be a string.')
        
        assert(isnumeric(nOutputs) && isreal(nOutputs) && numel(nOutputs) == 1 && ...
               mod(nOutputs,1) == 0 && nOutputs >= 0,...
            'bot:bot:nOutputs',...
            'Input argument "nOutputs" must be a string.')
        
        % Assign properties
        botObj.nInputs = nInputs;
        botObj.nOutputs = nOutputs;
        botObj.ticID = tic;
        botObj.timeStep = .1;
        botObj.time = 0;
        botObj.state = bot.state;
        botObj.tape = bot.trajectory;
        botObj.controller = @botObj.controllerZero;
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
    
%     function state = get.state(botObj)
%         pos = botObj.stateRaw.position - botObj.stateOffset.position;
%         ori = botObj.stateRaw.orientation * botObj.stateOffset.orientation';
%         vel = botObj.stateRaw.velocity;
%         angVel = botObj.stateRaw.angularVelocity;
%         state = bot.state(pos,ori,vel,angVel);
%     end

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
    
    function input = controllerZero(botObj,~)
        % The "controllerZero" method is a controller that always returns
        % zero input.
        %
        % SYNTAX:
        %   input = controllerZero(botObj,setpoint)
        %
        % INPUTS:
        %   botObj - (1 x 1 bot.bot)
        %       An instance of the "bot.bot" class.
        %
        % OUTPUTS:
        %   input - (nInputs x 1 number)
        %       Current input.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        input = zeros(botObj.nInputs,1);
    end
    
end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = public)
    update(botObj,timeRaw,positionRaw,orientationRaw)
    state = step(botObj,timeStep,time,state,input)
end
%-------------------------------------------------------------------------------
    
end
