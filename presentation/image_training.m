function targets_textures = ...
    image_training(expWin, centerRect, block, textures, unique_images)
global CSVDIR
global DEBUG
% figure out who is the target
% e.g.     'mv00'    'fam0'    'inv0'    'id1'    'train'    'csv'
tokens = regexp(block, '[a-zA-Z0-9]+', 'match');

subid = tokens{1};
familiar = tokens{2};
inverted = tokens{3};
id = tokens{4};

if strcmp(familiar, 'fam0')
    stim_type = 'unk';
else
    stim_type = 'fam';
end

fntargets = fullfile(CSVDIR, subid, [subid, '_', stim_type, '_', id, '_tar.txt']);
targets = txt2cell(fntargets);
targets_textures = zeros([1, length(targets)]);
for itar = 1:length(targets)
    targets_textures(itar) = find(strcmp(targets{itar}, unique_images));
end
% randomize order
ntextures = length(textures);
random_order = randperm(ntextures);
% inverted?
if strcmp(inverted, 'inv0')
    orientation = 0;
else
    orientation = 180;
end

Screen('TextSize', expWin, 24);
myText = ['You will see the images that will be used in the next block', ...
          '\n\n Press the spacebar to continue to the next image\n\n', ...
          'Press any key to start'];
DrawFormattedText(expWin, myText, 'center', 'center');
Screen('Flip', expWin);
KbWait([], 3);
% present images
for i = random_order
    WaitSecs(1);
    Screen('DrawTexture', expWin, textures(i), [], centerRect, orientation);
    Screen('Flip', expWin);
    if ~DEBUG
        WaitSecs(2);
        Screen('Flip', expWin);
        KbWait([], 3);
    end
end
WaitSecs(1)
% tell who will be the target
% myText = ['The next two images will be the target for the next block', ...
%           '\n\n Press the spacebar to continue to the next image\n\n', ...
%           'Press any key to start'];
% DrawFormattedText(expWin, myText, 'center', 'center');
% Screen('Flip', expWin);
% KbWait([], 3);
% for i = targets_textures
%  WaitSecs(1);
%     Screen('DrawTexture', expWin, textures(i), [], centerRect, orientation);
%     Screen('Flip', expWin);
%     WaitSecs(2);
%     Screen('Flip', expWin);
%     KbWait([], 3);
% end