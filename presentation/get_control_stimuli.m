function cfg = get_control_stimuli(cfg)
subnr = cfg.subnr;
max_nsubject = 7*6;
if subnr > max_nsubject
    error('subnr %d greater than max nsubjects %d', subnr, max_nsubject);
end

male = {'m1', 'm3', 'm4', 'm5', 'm6', 'm7', 'm8'};
female = {'f1', 'f2', 'f3', 'f5', 'f6', 'f7', 'f8'};

% generate possible targets and distractors. the first item in the array is the
% target, the rest are the distractors. each row represents a possible
% ordering. 

orders = zeros([7, 7]);
for i = 1:length(orders)
   orders(i, :) = circshift(1:7, [1, -(i-1)]);
end

% set seed so we generate the same numbers every time

% male
rng(0);
randtable_m = zeros([max_nsubject, 1]);
for i = 0:5
   randtable_m(i*7 + 1: (i+1)*7, :) = randsample(7, 7); 
end

% female
rng(1);
randtable_f = zeros([max_nsubject, 1]);
for i = 0:5
   randtable_f(i*7 + 1: (i+1)*7, :) = randsample(7, 7); 
end

male = male(orders(randtable_m(subnr), :));
female = female(orders(randtable_f(subnr), :));

% id1 is always male, id2 always female
cfg.tar.unk1 = male{1};
cfg.tar.unk2 = female{1};
cfg.dis.unk1 = male(2:end);
cfg.dis.unk2 = female(2:end);

% add distractors for familiar stimuli
cfg.dis.fam1 = cfg.dis.unk1;
cfg.dis.fam2 = cfg.dis.unk2;