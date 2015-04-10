classdef Trajectory < handle
% The "bot.Trajectory" class is used to store trajectories.
%
% NOTES:
%   To get more information on this class type "doc bot.Trajectory" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +bot
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
properties (GetAccess = public, SetAccess = private)
    length = 0; % (1 x 1 positive integer) Length of trajectory.
    nInputs % (1 x 1 positive integer) Dimension of input vector.
end

properties (GetAccess = public, SetAccess = private, Hidden = true)
    timeVec = nan(1,0) % (1 x ? number) Trajectory time vector.
    posVec = nan(3,0) % (3 x ? number) Trajectory position vector (x,y,z)
    oriVec = nan(4,0) % (4 x ? number) Trajectory orientation vector (quaternions)
    velVec = nan(3,0) % (3 x ? number) Trajectory velocity vector (vx,vy,vz)
    angVec = nan(3,0) % (3 x ? number) Trajectory angular velocity vector (wx,wy,wz)
    inputVec = nan(0,0) % (m x ? number) Trajectory input vector
end

properties (Dependent = true, SetAccess = private)
    time % (1 x length number) Trajectory time.
    position % (3 x length number) Trajectory position.
    orientation % (4 x length number) Trajectory orientation.
    velocity % (3 x length number) Trajectory velocity.
    angularVelocity  % (3 x length number) Trajectory velocity.
    x
    y
    z
    roll
    pitch
    yaw
    vx
    vy
    vz
    wx
    wy
    wz
    input
end

properties (Dependent = true, SetAccess = private, Hidden = true)
    lengthVec % (1 x 1 positive integer) % Actual size of vectors
end

properties (GetAccess = public, SetAccess = private, Hidden = true) 
    catSize = 500; % (1 x 1 positive integer) % Size to increase vectors when they fill up
end

%% Constructor -----------------------------------------------------------------
methods
    function trajectoryObj = Trajectory(nInputs,initLength)
        % Constructor function for the "Trajectory" class.
        %
        % SYNTAX:
        %   trajectoryObj = bot.Trajectory(nInputs,initLength)
        %
        % INPUTS:
        %   nInputs - (1 x 1 positive interger) [0]
        %
        %   initLength - (1 x 1 positive integer) [vecCatSize] 
        %       Initializes length of trajectory
        %
        % OUTPUTS:
        %   trajectoryObj - (1 x 1 bot.Trajectory object) 
        %       A new instance of the "bot.Trajectory" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(0,1)

        % Apply default values
        if nargin < 1, nInputs = 0; end;
        if nargin < 2, initLength = trajectoryObj.catSize; end

        % Check input arguments for errors
        assert(isnumeric(nInputs) && isreal(nInputs) && numel(nInputs) == 1 && ...
            mod(nInputs,1) == 0 && nInputs >= 0,...
            'bot:Trajectory:nInputs',...
            'Input argument "nInputs" must be a 1 x 1 positive integer.')
        
        assert(isnumeric(initLength) && isreal(initLength) && numel(initLength) == 1 && ...
            mod(initLength,1) == 0 && initLength > 0,...
            'bot:Trajectory:initLength',...
            'Input argument "initLength" must be a 1 x 1 positive integer.')
        
        % Initialize
        trajectoryObj.nInputs = nInputs;
        trajectoryObj.inputVec = nan(nInputs,0);
        trajectoryObj.increaseLength(initLength);
    end
end
%-------------------------------------------------------------------------------

%% Property Methods ------------------------------------------------------------
methods
%     function trajectoryObj = set.prop1(trajectoryObj,prop1)
%         assert(isnumeric(prop1) && isreal(prop1) && isequal(size(prop1),[1,1]),...
%             'bot:Trajectory:set:prop1',...
%             'Property "prop1" must be set to a 1 x 1 real number.')
% 
%         trajectoryObj.prop1 = prop1;
%     end

    function lengthVec = get.lengthVec(trajectoryObj)
        lengthVec = numel(trajectoryObj.timeVec);
    end

    function time = get.time(trajectoryObj)
        time = trajectoryObj.timeVec(:,1:trajectoryObj.length);
    end
    
    function position = get.position(trajectoryObj)
        position = trajectoryObj.posVec(:,1:trajectoryObj.length);
    end
    
    function x = get.x(trajectoryObj)
        x = trajectoryObj.posVec(1,1:trajectoryObj.length);
    end
    
    function y = get.y(trajectoryObj)
        y = trajectoryObj.posVec(2,1:trajectoryObj.length);
    end
    
    function z = get.z(trajectoryObj)
        z = trajectoryObj.posVec(3,1:trajectoryObj.length);
    end
    
    function input = get.input(trajectoryObj)
        input = trajectoryObj.inputVec(:,1:trajectoryObj.length);
    end
end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
methods (Access = public)
    function append(trajectoryObj,time,states,inputs)
        % The "append" method appends new data to the trajectory.
        %
        % SYNTAX:
        %   trajectoryObj = trajectoryObj.append(trajectoryObj,time,states,inputs)
        %
        % INPUTS:
        %   trajectoryObj - (1 x 1 bot.Trajectory)
        %       An instance of the "bot.Trajectory" class.
        %
        %   time - (1 x ? number)
        %       New time data.
        %
        %   states - (1 x ? state)
        %       New state data.
        %
        %   inputs - (m x ? state)
        %       New state data.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(3,4)
        
        if nargin < 4; inputs = []; end

        % Check arguments for errors
        assert(isnumeric(time) && isreal(time) && isvector(time),...
            'bot:Trajectory:append:time',...
            'Input argument "time" must be a vector of real numbers.')
        time = time(:)';
        n = numel(time);
        
        assert(isa(states,'bot.State') && isvector(states) && numel(states) == n,...
            'bot:Trajectory:append:states',...
            'Input argument "states" must be a 1 x %d vector of states.',n)
        states = states(:)';
        
        if ~isempty(inputs)
            assert(isnumeric(inputs) && isreal(inputs) && size(inputs,1) == trajectoryObj.nInputs && size(inputs,2) == n,...
                'bot:Trajectory:append:inputs',...
                'Input argument "inputs" must be a %d x %d matrix of inputs.',trajectoryObj.nInputs,n)
        end
        
        if trajectoryObj.length + n > trajectoryObj.lengthVec
            trajectoryObj.increaseLength();
        end
        l = trajectoryObj.length;
        trajectoryObj.timeVec(:,l+1:l+n) = time;
        trajectoryObj.posVec(:,l+1:l+n) = [states.position];
        trajectoryObj.oriVec(:,l+1:l+n) = cell2mat(arrayfun(@(s) s.orientation.quat,states,'UniformOutput',0));
        trajectoryObj.velVec(:,l+1:l+n) = [states.velocity];
        trajectoryObj.angVec(:,l+1:l+n) = [states.angularVelocity];
        if ~isempty(inputs)
            trajectoryObj.inputVec(:,l+1:l+n) = inputs;
        end
        
        trajectoryObj.length = l + n;
    end
end

methods (Access = public, Hidden = true)
    function increaseLength(trajectoryObj,l)
        % The "increaseLength" method increase the length of the storage
        % vectors by "l".
        %
        % SYNTAX:
        %   trajectoryObj = trajectoryObj.increaseLength(l)
        %
        % INPUTS:
        %   trajectoryObj - (1 x 1 bot.Trajectory)
        %       An instance of the "bot.Trajectory" class.
        %
        %   l - (1 x 1 positive number) [trajectoryObj.catSize]
        %       Length to increase vectors by. 
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------

        % Check number of arguments
        narginchk(1,2)
        
        % Apply default values
        if nargin < 2, l = trajectoryObj.catSize; end
        
        % Check arguments for errors
        assert(isnumeric(l) && isreal(l) && numel(l) == 1 && mod(l,1) == 0 && l > 0,...
            'bot:Trajectory:increaseLength:l',...
            'Input argument "l" must be a 1 x 1 positive integer.')
        
        trajectoryObj.timeVec = [trajectoryObj.timeVec nan(1,l)];
        trajectoryObj.posVec = [trajectoryObj.posVec nan(3,l)];
        trajectoryObj.oriVec = [trajectoryObj.oriVec nan(4,l)];
        trajectoryObj.velVec = [trajectoryObj.velVec nan(3,l)];
        trajectoryObj.angVec = [trajectoryObj.angVec nan(3,l)];
        if trajectoryObj.nInputs > 0
            trajectoryObj.inputVec = [trajectoryObj.inputVec nan(trajectoryObj.nInputs,l)];
        end
    end
    
end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
% methods (Access = public)
%     trajectoryObj = someMethod(trajectoryObj,arg1)
% end
%-------------------------------------------------------------------------------
    
end
