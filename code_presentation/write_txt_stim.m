function write_txt_stim(cfg)

% Example:
% cfg.subid = 'mv00';
% cfg.tar.fam1 = 'ap';
% cfg.tar.fam2 = 'sb';
% cfg.tar.unk1 = 'm1';
% cfg.tar.unk2 = 'f1';
% cfg.dis.fam1 = strcat('f', strsplit(num2str(2:7)));
% cfg.dis.fam2 = strcat('m', strsplit(num2str(2:7)));
% cfg.dis.unk1 = cfg.dis.fam1;
% cfg.dis.unk2 = cfg.dis.fam2;
%
% NOTE: Make id1 always male

setupExp;

global CSVDIR STIMDIR
% subject-specific directory
SUBJ_CSVDIR = fullfile(CSVDIR, cfg.subid);
if ~exist(SUBJ_CSVDIR, 'dir')
    mkdir(SUBJ_CSVDIR);
end

types = {'tar', 'dis'};
fam = {'fam1', 'fam2', 'unk1', 'unk2'};

% check we have only different targets and distractors
for k = 1:numel(fam)
   assert(isempty(intersect(cfg.tar.(fam{k}), cfg.dis.(fam{k}))), ...
       'Assertion Failed: %s has the same target as distractor!', fam{k}); 
end

for k = 1:numel(types)
   for i = 1:numel(fam)
      ids = cfg.(types{k}).(fam{i});
      fnout = sprintf('%s_%s_id%s_%s.txt', cfg.subid, fam{i}(1:3), ...
          fam{i}(4), types{k});
      fnout = fullfile(SUBJ_CSVDIR, fnout);
      ffs = {};
      % i'm lazy
      if ~iscell(ids)
          ids = {ids};
      end
      for y = 1:numel(ids)
        fns = dir(fullfile(STIMDIR, ['*', ids{y}, '*.jpg']));
        ffs = [ffs; {fns.name}'];
      end
      cell2csv(fnout, ffs);
   end
end