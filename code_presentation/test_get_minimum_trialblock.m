targets_fn = {'1tar1'; '1tar2'};
distractors_fn = strcat('dis', repmat({'1'; '2'}, [6, 1]));
distractors_fn = strcat(strsplit(num2str(sort([1:6, 1:6])))', distractors_fn);

trials = get_minimum_trialblock(targets_fn, distractors_fn);

% same number of trials for each set size
fprintf('Testing we have the same number of trials for each set size...');
nstimuli_trial = sum(~cellfun(@(x) strcmp(x, 'none'), trials(:, 1:6)), 2);
assert(sum(nstimuli_trial == 2) == sum(nstimuli_trial == 4))
assert(sum(nstimuli_trial == 2) == sum(nstimuli_trial == 6))
fprintf(' OK!\n');

% same number of target present/absent trials
fprintf('Testing we have the same number of target present/absent trials...');
ntrial_pres = sum(sum(cellfun(@(x) strcmp(x(2:4), 'tar'), trials(:, 1:6)), 2));
ntrial_abs = length(trials) - ntrial_pres;
assert(ntrial_pres == ntrial_abs);
fprintf(' OK!\n');

% unique stimuli for each trial
fprintf('Testing we have unique stimuli for each trial...');
id_trial = cellfun(@(x) x(1:4), trials(:, 1:6), 'UniformOutput', 0);
for i = 1:length(trials)
   this_trial = id_trial(i, :);
   this_trial = this_trial(~strcmp(this_trial, 'none'));
   assert(length(unique(this_trial)) == length(this_trial));
end
fprintf(' OK!\n');

% same number of targets in left/right hemifield
fprintf('Testing we have the same number of targets in left/right hemifields...');
tar_pos = zeros([1, 6]);
for i = 1:length(trials)
   this_trial = id_trial(i, :);
   this_tar_pos = ...
       find(strcmp(cellfun(@(x) x(2:end), ...
       this_trial, 'UniformOutput', 0), 'tar'));
   tar_pos(this_tar_pos) = tar_pos(this_tar_pos) + 1;
end
assert(sum(tar_pos([1, 2, 6])) == sum(tar_pos([3, 4, 5])));
fprintf(' OK!\n');

fprintf('Testing we have the same number of targets in left/right hemifields for each set size...');
tar_pos = zeros([3, 2]);  % set_size X left/right
for i = 1:length(trials)
   this_trial = id_trial(i, :);
   this_tar_pos = ...
       find(strcmp(cellfun(@(x) x(2:end), ...
       this_trial, 'UniformOutput', 0), 'tar'));
   this_set_size = sum(~strcmp(this_trial, 'none'));
   
   if ismember(this_tar_pos, [3, 4, 5])
       pos = 1; % left
   else
       pos = 2; % right
   end
   
   if ~isempty(this_tar_pos)
       tar_pos(this_set_size/2, pos) = tar_pos(this_set_size/2, pos) + 1;
   end
end
assert(isequal(diff(tar_pos, 1, 2)', [0 0 0]));
fprintf(' OK!\n');

fprintf('All tests passed!\n');