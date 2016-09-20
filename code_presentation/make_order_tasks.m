function make_order_tasks(subid, nsub)
setupExp;

global CSVDIR
SUBJ_CSVDIR = fullfile(CSVDIR, subid);

famorder = repmat([0, 1], [1, 4]);
invorder = repmat([0 0 1 1], [1, 2]);
idorder = [ones(1, 4), 2*ones(1, 4)];

if ismember(mod(nsub, 8), [2, 4, 6, 0])
       famorder = circshift(famorder, [1, 1]);     
end
if ismember(mod(nsub, 8), [3, 4, 7, 0])
       invorder = circshift(invorder, [1, 2]);
end
if ismember(mod(nsub, 8), [0, 5, 6, 7])
    idorder = circshift(idorder, [1, 4]);
end

tasks = {};
for i = 1:length(famorder)
    tasks = [tasks; ...
        {sprintf('%s_fam%d_inv%d_id%d_train.csv', ...
            subid, famorder(i), invorder(i), idorder(i)); ...
        sprintf('%s_fam%d_inv%d_id%d_test.csv', ...
            subid, famorder(i), invorder(i), idorder(i))}];
end

fnout = sprintf('%s_blocks.txt', subid);
cell2csv(fullfile(SUBJ_CSVDIR, fnout), tasks);
end