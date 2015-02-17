function update(botObj)
% The "update" method updates the real-time properties of the bot
% object "botObj".
%
% SYNTAX:
%   botObj = botObj.update()
%
% INPUTS:
%   botObj - (1 x 1 bot.bot)
%       An instance of the "bot.bot" class.
%
%   timeRaw - (1 x 1 number)
%       Time value to use for the update.
%
%   positionRaw - (3 x 1 number)
%       X, Y, Z position values to use for the update. 
%
%   orientationRaw - (1 x 1 quaternion or 4 x 1 number)
%       Quaternion object or A, B, C, D normalized quaternion values to use
%       for the update.
%   
% OUTPUTS:
%
% NOTES:
%   If arguments are provided, those argument values are used for the
%   update instead of querying the Optitrack system for data. This is
%   useful if it is desired to overload this method.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +bot, quaternion.m, getTrackableData.(mex file)
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com) 16-FEB-2012
%-------------------------------------------------------------------------------

% %% Check Input Arguments
% 
% % Check number of arguments
% narginchk(4,4)
% assert(nargin == 1 || nargin == 4,...
%     'bot:bot:update:nargin',...
%     'Incorrect number of input arguments')
% 
% 
% % Check arguments for errors
% assert(isa(botObj,'bot.bot') && numel(botObj) == 1,...
%     'bot:bot:update:botObj',...
%     'Input argument "botObj" must be a 1 x 1 "bot.bot" object.')
% 
% if nargin == 4
%     assert(isnumeric(timeRaw) && isreal(timeRaw) && numel(timeRaw) == 1,...
%         'bot:bot:update:timeRaw',...
%         'Input argument "timeRaw" must be a scaler real number.')
%     
%     assert(isnumeric(positionRaw) && isreal(positionRaw) && numel(positionRaw) == 3,...
%         'bot:bot:update:positionRaw',...
%         'Input argument "positionRaw" must be a 3 x 1 vector of real numbers.')
%     positionRaw = positionRaw(:);
%     
%     assert((isa(orientationRaw,'quaternion') && numel(orientationRaw) == 1 ) || ...
%         (isnumeric(orientationRaw) && isreal(orientationRaw) && numel(orientationRaw) == 4),...
%         'bot:bot:update:orientationRaw',...
%         'Input argument "orientationRaw" must be a 1 x 1 quaternion or 4 x 1 vector of real numbers.')
% 
%     if ~isa(orientationRaw,'quaternion')
%             orientationRaw = orientationRaw(:);
%             if abs(norm(orientationRaw) - 1) > .01;
%                 warning('bot:bot:update:orientationRaw',...
%                     'Property "orientationRaw" norm is not very close to 1. (Norm = %.3f)',norm(orientationRaw))
%             end
%             orientationRaw = orientationRaw / norm(orientationRaw);
%             orientationRaw = quaternion(orientationRaw);
%     end
% end

% %% Update
% timePrev = botObj.timeRaw_;
% posPrev = botObj.positionRaw_;
% oriPrev = botObj.orientationRaw_;
% 
% botObj.timeRaw_ = timeRaw;
% botObj.positionRaw_ = positionRaw;
% botObj.orientationRaw_ = orientationRaw;
% 
% dt = botObj.timeRaw_ - timePrev;
% dp = (botObj.positionRaw_ - posPrev);
% dq = inv(oriPrev)*botObj.orientationRaw_; %#ok<MINV>
% [de,dtheta] = quaternion.quat2axis(dq.a,dq.b,dq.c,dq.d);
% if dtheta == 0
%     de = zeros(3,1);
% end
% de = real(de); 
% 
% botObj.velocity = dp / dt;
% botObj.angularVelocity = de / dt;
%     
% if botObj.tapeFlag
%     botObj.writeToTape();
% end

%% Record current
if botObj.record
    botObj.tape.append(botObj.time,botObj.state);
end

%% Update
if botObj.simulate
    time = botObj.timeRaw + botObj.timeStep;
    state = botObj.step();
else
    time = botObj.clock();
    pause(botObj.timeStep);
end

% output = botObj.sensor();
% state = botObj.estimator();
% input = botObj.controller();

botObj.timeRaw = time;
botObj.state = state;


end
