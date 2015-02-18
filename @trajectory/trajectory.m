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
end

properties (GetAccess = public, SetAccess = private, Hidden = true)
    timeVec = nan(1,0) % (1 x ? number) Trajectory time vector.
    stateVec = repmat(bot.State(nan),1,0) % (1 x ? state) Trajectory state vector.
end

properties (Dependent = true, SetAccess = private)
    times % (1 x length number) Trajectory times.
    states % (1 x length state) Trajectory states.
end

properties (Dependent = true, SetAccess = private, Hidden = true)
    lengthVec % (1 x 1 positive integer) % Actual size of vectors
end

properties (GetAccess = public, SetAccess = private, Hidden = true) 
    catSize = 500; % (1 x 1 positive integer) % Size to increase vectors when they fill up
end

%% Constructor -----------------------------------------------------------------
methods
    function trajectoryObj = Trajectory(initLength)
        % Constructor function for the "Trajectory" class.
        %
        % SYNTAX:
        %   trajectoryObj = bot.Trajectory(initLength)
        %
        % INPUTS:
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
        if nargin < 1, initLength = trajectoryObj.catSize; end

        % Check input arguments for errors
        assert(isnumeric(initLength) && isreal(initLength) && numel(initLength) == 1 && ...
            mod(initLength,1) == 0 && initLength > 0,...
            'bot:Trajectory:initLength',...
            'Input argument "initLength" must be a 1 x 1 positive integer.')
        
        % Initialize
        trajectoryObj.increaseLength(initLength);
    end
end
%-------------------------------------------------------------------------------

%% Destructor ------------------------------------------------------------------
% methods (Access = public)
%     function delete(trajectoryObj)
%         % Destructor function for the "trajectoryObj" class.
%         %
%         % SYNTAX:
%         %   delete(trajectoryObj)
%         %
%         % INPUTS:
%         %   trajectoryObj - (1 x 1 bot.Trajectory)
%         %       An instance of the "bot.Trajectory" class.
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         
%     end
% end
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

    function times = get.times(trajectoryObj)
        times = trajectoryObj.timeVec(:,1:trajectoryObj.length);
    end
    
    function states = get.states(trajectoryObj)
        states = trajectoryObj.stateVec(:,1:trajectoryObj.length);
    end
    
    function lengthVec = get.lengthVec(trajectoryObj)
        lengthVec = numel(trajectoryObj.timeVec);
    end
end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
methods (Access = public)
    function append(trajectoryObj,times,states)
        % The "append" method appends new data to the trajectory.
        %
        % SYNTAX:
        %   trajectoryObj = trajectoryObj.append(trajectoryObj,times)
        %   trajectoryObj = trajectoryObj.append(trajectoryObj,times,states)
        %
        % INPUTS:
        %   trajectoryObj - (1 x 1 bot.Trajectory)
        %       An instance of the "bot.Trajectory" class.
        %
        %   times - (1 x ? number)
        %       New time data.
        %
        %   states - (1 x ? state) [bot.state(nan)]
        %       New state data.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(2,3)

        % Check arguments for errors
        assert(isnumeric(times) && isreal(times) && isvector(times),...
            'bot:Trajectory:append:time',...
            'Input argument "time" must be a vector of real numbers.')
        times = times(:)';
        n = numel(times);
        
        if nargin < 3, states = repmat(bot.state(nan),1,n); end
        assert(isa(states,'bot.State') && isvector(states) && numel(states) == n,...
            'bot:Trajectory:append:state',...
            'Input argument "state" must be a 1 x %d vector of states.',n)
        states = states(:)';
        
        if trajectoryObj.length + n > trajectoryObj.lengthVec
            trajectoryObj.increaseLength();
        end
        l = trajectoryObj.length;
        trajectoryObj.timeVec(:,l+1:l+n) = times;
        trajectoryObj.stateVec(:,l+1:l+n) = states;
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
        trajectoryObj.stateVec = [trajectoryObj.stateVec repmat(bot.State(nan),1,l)];
    end
    
end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
% methods (Access = public)
%     trajectoryObj = someMethod(trajectoryObj,arg1)
% end
%-------------------------------------------------------------------------------
    
end
