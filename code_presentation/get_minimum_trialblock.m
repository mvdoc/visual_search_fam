function trials = get_minimum_trialblock(targets_fn, distractors_fn)
% This function returns a cell containing the trials for the minimum possible
% block. In this experiment, it is a block of length 12, assuming set sizes of
% 2, 4, 6 and two different images for each identity (passed as targets in this
% function). The output cell has the targets balanced in the left/right
% positions. The image and the location are randomized to avoid some
% correlation between position and image (e.g., images 1 always in the left
% hemifield).

% check we really have only two targets 
assert(length(targets_fn) == 2, 'I thought we had only two images per target');

% preallocate the cells
trials = cell([12, 7]);
target_pres = repmat({'none'}, [6, 6]);
target_abs = repmat({'none'}, [6, 6]);

%% work on target present first

% I maintain the order of the ids fixed, but randomize the position of the
% targets

targets = repmat(targets_fn, [3, 1]);
set_sizes = [2; 2; 4; 4; 6; 6];

% stupid way of getting balanced positions, i.e., set size 2, 4, 6 in
% left/right
target_pos = randperm(6);
right = ismember(target_pos, [1, 2, 6]);
count = 1;
while length(unique(set_sizes(right))) < 3
    target_pos = randperm(6);
    right = ismember(target_pos, [1, 2, 6]);
    count = count+1;
end

for i = 1:6
    target_pres(i, target_pos(i)) = targets(i);
end

% now get distractor positions and fill with distractor filenames
for set_size = [2, 4, 6]
    distractor_pos = get_distractor_position(...
        target_pos(set_size-1:set_size), set_size);
    distractor_fns = get_distractor_fns(2, distractors_fn, set_size-1);
    
    for i = 1:2
        target_pres(set_size-2+i, distractor_pos(i, :)) = ...
            distractor_fns(i, :);
    end
end

%% now target absent
target_abs_pos = randperm(6);  %not really using this, but just to randomize

for set_size = [2, 4, 6]
    distractor_abs_pos = get_distractor_position(...
        target_abs_pos(set_size-1:set_size), set_size);
    distractor_abs_pos = [target_abs_pos(set_size-1:set_size)', ...
        distractor_abs_pos];
    distractor_abs_fns = get_distractor_fns(2, distractors_fn, set_size);
    
    for i = 1:2
        target_abs(set_size-2+i, distractor_abs_pos(i, :)) = ...
            distractor_abs_fns(i, :);
    end
end

%% put all together
trials(:, 1:6) = [target_pres; target_abs];
trials(:, 7) = num2cell([target_pos'; zeros([6, 1])]);
end