function setupExp()
% setup paths for the experiment

% global variables
global CSVDIR STIMDIR RESDIR
global DEBUG RESOLUTION ACTUAL_REFRESH
global BG_COLOR
global DEG2P
global STIM_SIZE_PIX STIM_POS_PIX FIX_CROSS_SIZE_PIX
global ROTATION MAX_SETSIZE MAX_RT MIN_FIX_S MAX_FIX_S

myname = mfilename;
mydir = which(myname);
curdir = fileparts(mydir);

CSVDIR = fullfile(fileparts(curdir), 'csv');
STIMDIR = fullfile(fileparts(curdir), 'stim');
RESDIR = fullfile(fileparts(curdir), 'res');
DEBUG = 0;

% PARAMETERS OF THE SETUP -- CHANGE THIS ACCORDING TO YOUR SETUP
DIST_CM = 50;  % distance subject-screen
SCREEN_W_CM = 41;  % width of the screen in cm


STIM_SIZE_DEG = [4 4];  % width, height
STIM_POS_DEG = 7;  % radius in deg
FIX_CROSS_SIZE_DEG = [1 1];  % width, height

ROTATION = pi/3; %60 degrees in radians -- exagon shape
MAX_SETSIZE = 6;
MAX_RT = 3;
MIN_FIX_S = 0.8; 
MAX_FIX_S = 1;

BG_COLOR = [128, 128, 128];

% are we using a mac?
if strcmp(computer, 'MACI64')
    RESOLUTION = [2560 1440 0];
    ACTUAL_REFRESH = 60; %for stupid macs
else  % Alireza's lab eye tracker
    RESOLUTION = [1600 1200 60];
    ACTUAL_REFRESH = RESOLUTION(3);
end

% compute conversion factor visual angle --> pixel
DEG2P = angle2pix(1, DIST_CM, SCREEN_W_CM, RESOLUTION(1));

% compute sizes in pixel and use those as global vars
STIM_SIZE_PIX = round(DEG2P * STIM_SIZE_DEG);
STIM_POS_PIX =  round(DEG2P * STIM_POS_DEG);  % radius in deg
FIX_CROSS_SIZE_PIX =  round(DEG2P * FIX_CROSS_SIZE_DEG);

if DEBUG
    Screen('Preference', 'SkipSyncTests', 1);
end