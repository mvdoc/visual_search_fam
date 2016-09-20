function vis_search_part(subid, npart)

blocks = 1:16;
blocks = reshape(blocks, [], 2);

if npart > 2
    error('This experiment has only two parts');
end
for block = blocks(:, npart)'
    vis_search(subid, block);
end