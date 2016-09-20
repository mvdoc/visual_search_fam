function vis_search(subid, blocknr)
% function to run the visual_search experiment
% REMOVE THIS
if strcmp(computer, 'MACI64')
    Screen('Preference', 'SkipSyncTests', 1);
end

%% load experiment setup
setupExp;

% CALL GETSECS TO SPEED THE NEXT CALLS
GetSecs;
% CALL BEEPER TO SPEED THE NEXT CALLS
Beeper(2, 0.1, 0.1);

% VARIABLES -- MODIFY THIS IF NEEDED
global CSVDIR STIMDIR RESDIR
global DEBUG RESOLUTION ACTUAL_REFRESH
global BG_COLOR
global STIM_SIZE_PIX STIM_POS_PIX FIX_CROSS_SIZE_PIX
global ROTATION MAX_SETSIZE MAX_RT MIN_FIX_S MAX_FIX_S

FLIP_S = 1/ACTUAL_REFRESH;

SUBJ_CSVDIR = fullfile(CSVDIR, subid);
SUBJ_RESDIR = fullfile(RESDIR, subid);
if ~exist(SUBJ_RESDIR, 'dir'); mkdir(SUBJ_RESDIR); end

% LOAD TASK INFO FOR THE SUBJECT
taskInfo_fn = sprintf('%s_blocks.txt', subid);
taskInfo_fn = fullfile(SUBJ_CSVDIR, taskInfo_fn);
if ~exist(taskInfo_fn, 'file')
    error('%s does not exist. Did you modify the _orig.txt?', taskInfo_fn);
end
fid = fopen(taskInfo_fn, 'r');
taskInfo = textscan(fid, '%s');
fclose(fid);
% TASK FOR THE CURRENT BLOCK
block = taskInfo{1}{blocknr};

% LOAD SUBJECT DATA
block_fn = fullfile(SUBJ_CSVDIR, block);
fid = fopen(block_fn, 'r');
header = textscan(fid, '%s%s%s%s%s%s%s%s%s', 1, 'delimiter', ',');
header = horzcat(header{:});
blockInfo = textscan(fid, '%s%s%s%s%s%s%s%s%s', 'delimiter', ',');
blockInfo = horzcat(blockInfo{:});
fclose(fid);

% CREATE JITTER FOR ITI
ntrl = size(blockInfo, 1);
jitter = RandSample(MIN_FIX_S:FLIP_S:MAX_FIX_S, [ntrl, 1]);
% PREPARE OUTPUT
header_out = [header, 'jitter', 'keypress', 'RT'];
blockInfo_out = [blockInfo, num2cell(jitter)];
blockInfo_out_fn = ['res_', block];
blockInfo_out_fn = fullfile(SUBJ_RESDIR, blockInfo_out_fn);

if exist(blockInfo_out_fn, 'file')
    error(['File %s already exists. Please rename it, ', ...
           'back it up, or delete it (are you sure?).'], blockInfo_out_fn);
end

try
    AssertOpenGL;
    % SETUP PSYCHTOOLBOX
    % Keyboard stuff
    KbName('UnifyKeyNames');
    KbCheck;
    ListenChar(2);
    
    % Keys we will use
    spacebar = KbName('space');
    leftarrow = KbName('LeftArrow');
    rightarrow = KbName('RightArrow');
    exitkey = KbName('q');
    
    % Screen stuff
    screens = Screen('Screens');
    screenNumber = min(screens);
    oldRes = SetResolution(screenNumber, ...
        RESOLUTION(1), RESOLUTION(2), RESOLUTION(3));
    [expWin,expRect] = Screen('OpenWindow', screenNumber, BG_COLOR);
    HideCursor;
    % Set up alpha-blending for smooth (anti-aliased) lines
    Screen('BlendFunction', expWin, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    % get the midpoint (mx, my) of this window, x and y
    [mx, my] = RectCenter(expRect);
    
    % MAKE TEXTURE FOR FIX CROSS
    FixCr = ones(FIX_CROSS_SIZE_PIX) * mean(BG_COLOR);
    h_FIX_CROSS_SIZE_PIX = round(FIX_CROSS_SIZE_PIX/2);
    FixCr(h_FIX_CROSS_SIZE_PIX(1) - 2:h_FIX_CROSS_SIZE_PIX(1) + 2, :) = 0;
    FixCr(:, h_FIX_CROSS_SIZE_PIX(2) - 2:h_FIX_CROSS_SIZE_PIX(2) + 2) = 0;
    fixcross = Screen('MakeTexture', expWin, FixCr);
    
    % MAKE TEXTURES FOR STIMULI
    unique_images = unique(blockInfo(:, 1:6));
    % REMOVE none
    unique_images(strcmp('none', unique_images)) = [];
    n_unique_images = length(unique_images);
    textures = zeros([1, n_unique_images]);
    for i = 1:n_unique_images
        img = imread(fullfile(STIMDIR, unique_images{i}));
        textures(i) = Screen('MakeTexture', expWin, img);
    end
    
    % CREATE RECTS FOR STIMULI IN CCW ORDER
    centerRect = CenterRectOnPoint([0 0 STIM_SIZE_PIX], mx, my);
    rect_stimuli = zeros([4, MAX_SETSIZE]);
    for i = 1:MAX_SETSIZE
        xOffset = STIM_POS_PIX * cos((i-1) * ROTATION);
        yOffset = STIM_POS_PIX * sin((i-1) * ROTATION);
        rect_stimuli(:, i) = OffsetRect(centerRect, xOffset, yOffset);
    end
    % FIRST PHASE: image training only if training
    tokens = regexp(block, '[a-zA-Z0-9]+', 'match');
%     if strcmp(tokens{end-1}, 'train')
%     targets_textures = ...
%         image_training(expWin, centerRect, block, textures, unique_images);
%     end

    % always show target textures
    targets_textures = get_targets_textures(block, unique_images);
    
    % invert images?
    if strcmp(tokens{3}, 'inv0')
        orientation = 0;
    else
        orientation = 180;
    end
    
    % GREETING MESSAGE WITH DESCRIPTION OF THE BLOCK
    Screen('TextSize', expWin, 24);
    if strcmp(regexp(block, '[a-zA-Z0-9]+\.', 'match'), 'train.')
        txt = 'This is your target. We''ll start with a training phase.\n\n';
    else
        txt = ['This is your target.\n\n',...
            'Experimental phase. This will be longer than the training phase.\n\n'];
    end
    myText = [txt, ...
             'Press the LEFT ARROW (YES) when the target is present.\n\n', ...
             'Press the RIGHT ARROW (NO) when the target is absent.\n\n', ...
             'Press a key to start the experiment.'];
    DrawFormattedText(expWin, myText, 'center', my + 50);
    if exist('targets_textures', 'var')
       target_rect = CenterRectOnPoint(centerRect, mx, my - 100);
       target_text = textures(targets_textures(1));
       Screen('DrawTexture', expWin, target_text, [], target_rect, ...
           orientation); 
    end
    Screen('Flip', expWin);
    KbWait([], 3);
    Screen('Flip', expWin);
    WaitSecs(1)
    % LOOP THROUGH TRIALS
    res = zeros([ntrl, 1]);
    rts = zeros([ntrl, 1]);
    for itrl = 1:ntrl
        % TARGET FOR THIS TRIAL: absent if < 0, present if > 0
        target = str2double(blockInfo{itrl, 7}) > 0;
        % FIND INDICES OF TEXTURES FOR THE CURRENT STIMULI
        trl_textures = [];
        stimuli_position = [];
        for j = 1:MAX_SETSIZE
           stim_fn = blockInfo{itrl, j};
           where = find(strcmp(stim_fn, unique_images));
           if ~isempty(where)
               trl_textures(end+1) = textures(where);
               stimuli_position(end+1) = j;
           end
        end
        rect_stimuli_trl = rect_stimuli(:, stimuli_position);
        % DRAW FIXATION CROSS FOR A JITTERED PERIOD BETWEEN 350 and 500 ms  
        Screen('DrawTexture', expWin, fixcross);
        [ignore, tFix, ignore] = Screen('Flip', expWin);
        % DRAW STIMULI ALL AT ONCE
        Screen('DrawTextures', expWin, trl_textures, [], ...
            rect_stimuli_trl, orientation);
        [ignore, stimulusOnset, ignore] = Screen('Flip', expWin, ...
                                        tFix + jitter(ntrl));
        
        % COLLECT RESPONSE
        [keyIsDown, RT, keyCode] = KbCheck;
        while ~(keyIsDown && ...
                    (keyCode(leftarrow) || keyCode(rightarrow))) && ...
                    (GetSecs - stimulusOnset <= MAX_RT)
          
          [keyIsDown, RT, keyCode] = KbCheck;
        end
        % SAVE RT AND RESPONSE
        rts(itrl) = RT - stimulusOnset;
        if keyCode(leftarrow) %yes
            res(itrl) = 1;
        elseif keyCode(rightarrow) %no
            res(itrl) = 0;
        else %didn't press anything
            res(itrl) = -1;
        end
        % GIVE FEEDBACK
        if (target ~= res(itrl)) 
           % negative feedback on MISS, FA, and sleepy
           Beeper(800, 1, 0.2);
        end
        fprintf('Trial %3d: Response: %2d/%d\n', itrl, res(itrl), target);
    end
    % done
    Screen('Flip', expWin);
    
    % SAVE DATA if it's not a test
    if ~strcmp('test', subid)
        blockInfo_out = [blockInfo_out, num2cell(res), num2cell(rts)];
        cell2csv(blockInfo_out_fn, [header_out; blockInfo_out]);
    end
    
    % TELL THE SUBJECT WHAT TO DO at the end
    WaitSecs(1);    
    if blocknr == 16
        txt = 'You''re done! Thanks for your help!';
    elseif blocknr == 8
        txt = ['This is the end of the first part.\n\n', ...
               'You can have a small break now.\n\n', ...
               'Please call the experimenter.'];
    elseif mod(blocknr, 2) == 0
        txt = ['Done with this block.\n\n', ...
               'Press a key to continue with the next block.'];
    else
        txt = ['Press a key to continue with the experimental phase.'];
    end
    DrawFormattedText(expWin, txt, 'center', 'center');
    Screen('Flip', expWin);
    KbWait([], 3);
catch %try
    sca;
    if exist('screenNumber', 'var') || exist('oldRes', 'var')
        SetResolution(screenNumber, oldRes);
    end
    ListenChar(0);
    psychrethrow(psychlasterror);
end %try
sca;
SetResolution(screenNumber, oldRes);
ListenChar(0);
end
