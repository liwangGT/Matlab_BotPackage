%% botTest
% The |botTest.m| script is used to test the bot class.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%
%   +bot
%
% AUTHORS:
%    <http://rowlandoflaherty.com Rowland O'Flaherty>
%
% CREATED: 
%    16-FEB-2015 (Rowland O'Flaherty)
%
% MODIFIED:
%    16-FEB-2015 (Rowland O'Flaherty)

%% Clear
ccc

%% Import
import bot.*;

%% Initialize robot
B = Bot();
B.simulate = true;
B.record = true;

%%
while round(B.time,5) < 5
    B.update();
end

B.tape.times

