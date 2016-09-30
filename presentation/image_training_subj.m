function image_training_subj(subid)
setupExp;
global CSVDIR STIMDIR DEBUG
global STIM_SIZE_PIX RESOLUTION BG_COLOR

SUBJ_CSVDIR = fullfile(CSVDIR, subid);

dis_fn = dir([SUBJ_CSVDIR, '/*dis.txt']);
dis_fn = {dis_fn.name};
tar_fn = dir([SUBJ_CSVDIR, '/*tar.txt']);
tar_fn = {tar_fn.name};

fns = [dis_fn, tar_fn];

imgs = {};

for ifn = 1:length(fns)
   imgs = [imgs; txt2cell(fullfile(SUBJ_CSVDIR, fns{ifn}))]; 
end
imgs = unique(imgs);

try
    AssertOpenGL;
    % SETUP PSYCHTOOLBOX
    % Keyboard stuff
    KbName('UnifyKeyNames');
    KbCheck;
    ListenChar(2);
    
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
    
    for i = 1:length(imgs)
        img = imread(fullfile(STIMDIR, imgs{i}));
        textures(i) = Screen('MakeTexture', expWin, img);
    end
    centerRect = CenterRectOnPoint([0 0 STIM_SIZE_PIX], mx, my);
    
    textures_orientation = [repmat(textures, [1, 2]);
                            zeros([1, length(textures)]), ...
                            180*ones([1, length(textures)])];
    rand_order = randperm(length(textures_orientation));
    
    Screen('TextSize', expWin, 24);
    myText = ['You will see the images that will be used in the experiment.', ...
        '\n\n Press the spacebar to continue to the next image\n\n', ...
        'Press any key to start'];
    DrawFormattedText(expWin, myText, 'center', 'center');
    Screen('Flip', expWin);
    KbWait([], 3);
    % present images
    for i = rand_order
        texture = textures_orientation(1, i);
        orientation = textures_orientation(2, i);
        WaitSecs(0.2);
        Screen('DrawTexture', expWin, texture, [], centerRect, orientation);
        Screen('Flip', expWin);
        if ~DEBUG
            WaitSecs(2);
            Screen('Flip', expWin);
            KbWait([], 3);
        end
    end
    WaitSecs(1)
catch 
    sca;
    if exist('screenNumber', 'var') && exist('oldRes', 'var')
        SetResolution(screenNumber, oldRes);
    end
    ListenChar(0);
    psychrethrow(psychlasterror);
end %try
ListenChar(0);
sca
sca
end