%% dji350Test
% The |dji350Test.m| script is used to test the dji350 class.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%
%   +bot
%
% AUTHOR:
%    Rowland O'Flaherty (http://rowlandoflaherty.com)
%
% VERSION: 
%   Created 29-MAY-2015

%% Clear
ccc

%% Import
import bot.*;
import bot.quad.*;

%% Parameters
simulate = true;
name = 'quad1';
id = 1;
optitrackHost = '192.168.2.145';
rosHost = '192.168.1.15';


%% Initialize robot
Q1 = dji350(simulate,name,id,optitrackHost,rosHost);
Q1.record = true;
Q1.init();

%% Goto
Q1.goto(