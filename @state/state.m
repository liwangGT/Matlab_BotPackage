classdef State
% The "bot.State" class is used to represent the state of a mobile robot.
%
% NOTES:
%   To get more information on this class type "doc bot.State" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%   @quaternion
%
% SEE ALSO:
%    bot.Bot | bot.trajectory
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 16-FEB-2015
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Access = public, Hidden = true)
    position = nan(3,1) % (3 x 1 number) Current position [Cartesian (x,y,z)]
    orientation = quaternion(nan(4,1)) % (1 x 1 quaternion) Current orientation
    velocity = nan(3,1) % (3 x 1 number) Current velocity
    angularVelocity = nan(3,1) % (3 x 1 number) Current angular velocity
end

properties (Dependent = true, Access = public)
    x % (1 x 1 number) x position.
    y % (1 x 1 number) y position.
    z % (1 x 1 number) z position.
    roll % (1 x 1 number) roll angle.
    pitch % (1 x 1 number) pitch angle.
    yaw % (1 x 1 number) yaw angle.
    vx % (1 x 1 number) x position.
    vy % (1 x 1 number) y position.
    vz % (1 x 1 number) z position.
    wx % (1 x 1 number) x position.
    wy % (1 x 1 number) y position.
    wz % (1 x 1 number) z position.
end

properties (Dependent = true, Access = public, Hidden = true)
    vector % (12 x 1 number) Vector form of state [pos; euler; vel; angVel].
    transform % (4 x 4 number) Homogeneous tranform matrix of current position and orientation.
end

%% Constructor -----------------------------------------------------------------
methods
    function stateObj = State(pos,ori,vel,angVel)
        % Constructor function for the "State" class.
        %
        % SYNTAX:
        %   stateObj = bot.State(pos,ori,vel,angVel)
        %
        % INPUTS:
        %   pos - (3 x 1 number) [zeros(3,1)]
        %       Sets the "stateObj.position" property.
        %
        %   ori - (1 x 1 quaternion) [quaternion()]
        %       Sets the "stateObj.orientation" property.
        %
        %   vel - (3 x 1 number) [zeros(3,1)]
        %       Sets the "stateObj.velocity" property.
        %
        %   angVel - (3 x 1 number) [zeros(3,1)]
        %       Sets the "stateObj.angularVelocity" property.
        %
        % OUTPUTS:
        %   stateObj - (1 x 1 bot.State object) 
        %       A new instance of the "bot.State" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments TODO: Add number argument check
        narginchk(0,4)
        
        % Apply default values
        if nargin < 1, pos = zeros(3,1); end
        if nargin < 2, ori = quaternion(); end
        if nargin < 3, vel = zeros(3,1); end
        if nargin < 4, angVel = zeros(3,1); end
        
        % Check input arguments for errors       
        assert(isa(ori,'quaternion') && numel(ori) == 1,...
            'bot:State:ori',...
            'Input argument "ori" must be a 1 x 1 quaternion.')
        
        assert(isnumeric(vel) && isreal(vel) && numel(vel) == 3,...
            'bot:State:vel',...
            'Input argument "vel" must be a 3 x 1 real number.')
        vel = vel(:);
        
        assert(isnumeric(angVel) && isreal(angVel) && numel(angVel) == 3,...
            'bot:State:angVel',...
            'Input argument "angVel" must be a 3 x 1 real number.')
        angVel = angVel(:);
        
        % Assign properties
        if ~isnan(pos)
            stateObj.position = pos;
            stateObj.orientation = ori;
            stateObj.velocity = vel;
            stateObj.angularVelocity = angVel;
        end

    end
end
%-------------------------------------------------------------------------------

%% Property Methods ------------------------------------------------------------
methods
    function stateObj = set.position(stateObj,position)
        assert(isnumeric(position) && isreal(position) && numel(position) == 3,...
            'bot:State:set:position',...
            'Property "position" must be set to a 3 x 1 real number.')
        
        stateObj.position = position(:);
    end
    
    function stateObj = set.orientation(stateObj,orientation)
        assert(isa(orientation,'quaternion') && numel(orientation) == 1,...
            'bot:State:set:orientation',...
            'Property "orientation" must be set to a 1 x 1 quaternion.')
        
        stateObj.orientation = orientation;
    end
    
    function stateObj = set.velocity(stateObj,velocity)
        assert(isnumeric(velocity) && isreal(velocity) && numel(velocity) == 3,...
            'bot:State:set:velocity',...
            'Property "velocity" must be set to a 3 x 1 real number.')
        
        stateObj.velocity = velocity(:);
    end
    
    function stateObj = set.angularVelocity(stateObj,angularVelocity)
        assert(isnumeric(angularVelocity) && isreal(angularVelocity) && numel(angularVelocity) == 3,...
            'bot:State:set:angularVelocity',...
            'Property "angularVelocity" must be set to a 3 x 1 real number.')
        
        stateObj.angularVelocity = angularVelocity(:);
    end
    
    function stateObj = set.x(stateObj,x)
        assert(isnumeric(x) && isreal(x) && numel(x) == 1,...
            'bot:State:set:x',...
            'Property "x" must be set to a 1 x 1 real number.')
        stateObj.position(1) = x;
    end
    
    function x = get.x(botObj)
        x = botObj.position(1);
    end
    
    function stateObj = set.y(stateObj,y)
        assert(isnumeric(y) && isreal(y) && numel(y) == 1,...
            'bot:State:set:x',...
            'Property "y" must be set to a 1 x 1 real number.')
        stateObj.position(2) = y;
    end
    
    function y = get.y(botObj)
        y = botObj.position(2);
    end
    
    function stateObj = set.z(stateObj,z)
        assert(isnumeric(z) && isreal(z) && numel(z) == 1,...
            'bot:State:set:x',...
            'Property "z" must be set to a 1 x 1 real number.')
        stateObj.position(3) = z;
    end
    
    function z = get.z(botObj)
        z = botObj.position(3);
    end
    
    function stateObj = set.roll(stateObj,roll)
        assert(isnumeric(roll) && isreal(roll) && numel(roll) == 1,...
            'bot:State:set:roll',...
            'Property "roll" must be set to a 1 x 1 real number.')
        stateObj.orientation.roll = roll;
    end
    
    function roll = get.roll(botObj)
        roll = botObj.orientation.roll;
    end
    
    function stateObj = set.pitch(stateObj,pitch)
        assert(isnumeric(pitch) && isreal(pitch) && numel(pitch) == 1,...
            'bot:State:set:pitch',...
            'Property "pitch" must be set to a 1 x 1 real number.')
        stateObj.orientation.pitch = pitch;
    end
    
    function pitch = get.pitch(botObj)
        pitch = botObj.orientation.pitch;
    end
    
    function stateObj = set.yaw(stateObj,yaw)
        assert(isnumeric(yaw) && isreal(yaw) && numel(yaw) == 1,...
            'bot:State:set:yaw',...
            'Property "yaw" must be set to a 1 x 1 real number.')
        stateObj.orientation.yaw = yaw;
    end
    
    function yaw = get.yaw(botObj)
        yaw = botObj.orientation.yaw;
    end
    
    function stateObj = set.vx(stateObj,vx)
        assert(isnumeric(vx) && isreal(vx) && numel(vx) == 1,...
            'bot:State:set:vx',...
            'Property "vx" must be set to a 1 x 1 real number.')
        stateObj.velocity(1) = vx;
    end
    
    function vx = get.vx(botObj)
        vx = botObj.velocity(1);
    end
    
    function stateObj = set.vy(stateObj,vy)
        assert(isnumeric(vy) && isreal(vy) && numel(vy) == 1,...
            'bot:State:set:vy',...
            'Property "vy" must be set to a 1 x 1 real number.')
        stateObj.velocity(2) = vy;
    end
    
    function vy = get.vy(botObj)
        vy = botObj.velocity(2);
    end
    
    function stateObj = set.vz(stateObj,vz)
        assert(isnumeric(vz) && isreal(vz) && numel(vz) == 1,...
            'bot:State:set:vz',...
            'Property "vz" must be set to a 1 x 1 real number.')
        stateObj.velocity(3) = vz;
    end
    
    function vz = get.vz(botObj)
        vz = botObj.velocity(3);
    end
    
    function stateObj = set.wx(stateObj,wx)
        assert(isnumeric(wx) && isreal(wx) && numel(wx) == 1,...
            'bot:State:set:wx',...
            'Property "wx" must be set to a 1 x 1 real number.')
        stateObj.angularVelocity(1) = wx;
    end
    
    function wx = get.wx(botObj)
        wx = botObj.angularVelocity(1);
    end
    
    function stateObj = set.wy(stateObj,wy)
        assert(isnumeric(wy) && isreal(wy) && numel(wy) == 1,...
            'bot:State:set:wy',...
            'Property "wy" must be set to a 1 x 1 real number.')
        stateObj.angularVelocity(2) = wy;
    end
    
    function wy = get.wy(botObj)
        wy = botObj.angularVelocity(2);
    end
    
    function stateObj = set.wz(stateObj,wz)
        assert(isnumeric(wz) && isreal(wz) && numel(wz) == 1,...
            'bot:State:set:wz',...
            'Property "wz" must be set to a 1 x 1 real number.')
        stateObj.angularVelocity(3) = wz;
    end
    
    function wz = get.wz(botObj)
        wz = botObj.angularVelocity(3);
    end
    
    function stateObj = set.vector(stateObj,vector)
        assert(isnumeric(vector) && isreal(vector) && numel(vector) == 12,...
            'bot:State:set:vector',...
            'Property "vector" must be set to a 12 x 1 real number.')
        vector = vector(:);
        stateObj.position = vector(1:3);
        stateObj.orientation = quaternion(vector(4:6)');
        stateObj.velocity = vector(7:9);
        stateObj.angularVelocity = vector(10:12);
    end
    
    function vector = get.vector(botObj)
        p = botObj.position;
        e = botObj.orientation.euler;
        v = botObj.velocity;
        a = botObj.angularVelocity;

        vector = [p;e;v;a];
    end
    
    function stateObj = set.transform(stateObj,transform)
        assert(isnumeric(transform) && isreal(transform) && isequal(size(transform),[4,4]),...
            'bot:State:set:transform',...
            'Property "transform" must be set to a 4 x 4 real number.')
        
        r = transform(1:3,1:3);
        p = transform(1:3,4);
        stateObj.orientation.rot = r;
        stateObj.position = p;
    end
    
    function transform = get.transform(botObj)        
        p = botObj.position;
        r = botObj.orientation.rot;

        transform = [r p;[zeros(1,3) 1]];
    end
end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
% methods (Access = public)
%     function stateObj = method_name(stateObj,arg1)
%         % The "method_name" method ...
%         %
%         % SYNTAX:
%         %   stateObj = stateObj.method_name(arg1)
%         %
%         % INPUTS:
%         %   stateObj - (1 x 1 bot.State)
%         %       An instance of the "bot.State" class.
%         %
%         %   arg1 - (size type) [defaultArgumentValue] 
%         %       Description.
%         %
%         % OUTPUTS:
%         %   stateObj - (1 x 1 bot.State)
%         %       An instance of the "bot.State" class ... 
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
%             'bot:State:method_name:arg1',...
%             'Input argument "arg1" must be a ? x ? matrix of real numbers.')
%         
%     end
%     
% end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
% methods (Access = public)
%     stateObj = someMethod(stateObj,arg1)
% end
%-------------------------------------------------------------------------------
    
end
