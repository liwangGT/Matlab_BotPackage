function update(botObj)
% The "update" method updates the real-time properties of the bot
% object "botObj".
%
% SYNTAX:
%   botObj = botObj.update()
%
% INPUTS:
%   botObj - (1 x 1 bot.Bot)
%       An instance of the "bot.Bot" class.
%   
% OUTPUTS:
%
% NOTES:

% NECESSARY FILES AND/OR PACKAGES:
%   +bot, quaternion.m
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com) 16-FEB-2012
%-------------------------------------------------------------------------------

%% Record current
if botObj.record
    botObj.tape.append(botObj.time,botObj.state,botObj.input);
end

%% Update
if botObj.simulate
    botObj.input = botObj.controller();
    state = botObj.step();
    time = botObj.timeRaw + botObj.timeStep;
else
    state = botObj.estimator();
    botObj.input = botObj.controller();
    time = botObj.clock();
    botObj.send();
end
botObj.timeRaw = round(time,ceil(log10(1/(botObj.timeStep)^3))); % Remove numerical errors in time
botObj.state = state;

if ~isempty(botObj.transformHandle) && ishghandle(botObj.transformHandle) && ishghandle(get(botObj.transformHandle,'Parent'))
    set(botObj.transformHandle,'Matrix',botObj.state.transform);
          
    if botObj.simulate
        drawnow
    end
end


end
