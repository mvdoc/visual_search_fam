function distractors = get_distractor_fns(ntargets, alldistractors, ndistractors)
% Given a column cell containing
% the filenames of the distractors, returns a (ntargets, ndistractors) cell
% containing distractors sampled randomly from alldistractor.
% NOTE: this function assumes that alldistractors is a cell containing the
%       filenames of the distractors, ordered such that the second image for 
%       each identity follows the first image. E.g.,
%       id1img1, id1img2, id2img1, id2img2, ...

assert(numel(alldistractors) == 12, 'I''m expecting 12 distractor fns');

nalldistractors = length(alldistractors);
distractors = cell([ntargets, ndistractors]);

for itarget = 1 : ntargets
    % set up cells containing the indices; we'll update this once they're
    % chosen
    idx_img{1} = 1 : 2 : nalldistractors;
    idx_img{2} = 2 : 2 : nalldistractors;
    for idistractor = 1 : ndistractors
        % get which list randomly
        which_list = int8(rand >= .5) + 1;
        % this is the common index for both images -- we want to remove it at
        % the end
        id_idx = randsample(length(idx_img{which_list}), 1);
        % this is the actual index from alldistractors
        distr_idx = idx_img{which_list}(id_idx);
        % store the filename
        distractors(itarget, idistractor) = alldistractors(distr_idx);
        % remove index from both lists: we don't want to take the same id
        idx_img{1}(id_idx) = [];
        idx_img{2}(id_idx) = [];
    end
end

end