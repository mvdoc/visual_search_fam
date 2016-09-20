function make_csv_search(subid)


% setup exp
setupExp;

% GENERAL VARIABLES
global CSVDIR
% repetition of each image for train/test phases
IMGREP.train = 2;
IMGREP.test = 10;

% subject-specific directory
SUBJ_CSVDIR = fullfile(CSVDIR, subid);
if ~exist(SUBJ_CSVDIR, 'dir')
    mkdir(SUBJ_CSVDIR);
end

% the targets and distractors will be in subject-specific directories, 
% will contain the filenames of the images, and will always be named as
%
%  - subid_fam_id1_tar.txt
%  - subid_fam_id2_tar.txt
%  - subid_unk_id1_tar.txt
%  - subid_unk_id2_tar.txt
%  - subid_fam_id1_dis.txt
%  - subid_fam_id2_dis.txt
%  - subid_unk_id1_dis.txt
%  - subid_unk_id2_dis.txt
%
% the distractors txt files exist because we want to make sure that the gender
% of the distractors is matched to the gender of the targets

% let's put everything into structures
ids = {'id1', 'id2'};
nids = length(ids);
roles = {'tar', 'dis'};
nroles = length(roles);

fam_task = struct();
unk_task = struct();
for i = 1:nids
    for j= 1:nroles
        this_id = ids{i};
        this_role = roles{j};
        
        % familiar
        fn_fam = sprintf('%s_fam_%s_%s.txt', subid, this_id, this_role);
        fn_fam = fullfile(SUBJ_CSVDIR, fn_fam);
        fam_task.(this_id).(this_role) = txt2cell(fn_fam);
        
        % unknown
        fn_unk = sprintf('%s_unk_%s_%s.txt', subid, this_id, this_role);
        fn_unk = fullfile(SUBJ_CSVDIR, fn_unk);
        unk_task.(this_id).(this_role) = txt2cell(fn_unk);
    end
end


% OUTPUT LAYOUT
TARGET_COL = 7;
FAMILIAR_COL = 8;
INVERTED_COL = 9;
HEADER = {'img1', 'img2', 'img3', 'img4', 'img5', 'img6', ...
          'target_pos', 'familiar', 'inverted'};
ncols = length(HEADER);

% FACTORS
SET_SIZES = [2, 4, 6];
TARGET = [0, 1];
FAMILIARITY = [0, 1]; %0 unknown, 1 familiar
TARGET_ID = [1, 2];
IMG = [1, 2];  %images for each identity;

% n conditions **for each block**
n_conditions = length(SET_SIZES) * length(TARGET) * length(IMG);
n_trials.train = IMGREP.train * n_conditions;
n_trials.test = IMGREP.test * n_conditions;

blocks = {'train', 'test'};
blocknames = {};
overwriteall = 0;

for inverted = 0:1
    for familiar = 0:1
        for id = 1:2
            for blockType = 1:2
                % preallocate output cell
                out = cell([n_trials.(blocks{blockType}), ncols]);
                
                % use correct filenames
                if familiar == 0
                    targets_fn = unk_task.(ids{id}).tar;
                    distractors_fn = unk_task.(ids{id}).dis;
                else
                    targets_fn = fam_task.(ids{id}).tar;
                    distractors_fn = fam_task.(ids{id}).dis;
                end
                
                % create enough trials
                for irep = 0:IMGREP.(blocks{blockType})-1
                   minblock = get_minimum_trialblock(targets_fn, distractors_fn);
                   minblock = [minblock, repmat({familiar}, [12, 1]), ...
                       repmat({inverted}, [12, 1])];
                   % store
                   out(irep*12+1 : (irep+1)*12, :) = minblock;
                end
                
                % shuffle
                out = out(randperm(n_trials.(blocks{blockType})), :);
                
                % TODO: some assertions here??
                
                % save here
                out = [HEADER; out];
                
                fnout_s = sprintf('%s_fam%d_inv%d_%s_%s.csv', subid, ...
                    familiar, inverted, ...
                    ids{id}, blocks{blockType});
                
                % store fnout in blocknames
                blocknames = [blocknames; fnout_s];
                fnout = fullfile(SUBJ_CSVDIR, fnout_s);
                
                s = 'y';
                if exist(fnout, 'file') && ~overwriteall
                    warning('File %s already exists!', fnout);
                    s = input(['Do you want to overwrite it? ', ...
                        'y: yes / Y: yes to all / n: no [n]'], 's');
                    if isempty(s)
                        s = 'n';
                    end
                    if strcmp(s, 'Y')
                        overwriteall = 1;
                    end
                end
                %save
                if strcmp(s, 'y') || overwriteall
                    fprintf('Saving %s\n', fnout_s);
                    cell2csv(fnout, out, ',');
                else
                    fprintf('Skipping %s\n', fnout_s);
                end
                
            end  %blockType
        end  %id
    end  % familiar
end  %inverted

fnout = sprintf('%s_blocks_orig.txt', subid);
fprintf('Saving %s\n', fnout);
fnout = fullfile(SUBJ_CSVDIR, fnout);
cell2csv(fnout, blocknames);

end