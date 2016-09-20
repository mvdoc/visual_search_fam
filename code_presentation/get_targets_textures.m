function targets_textures = get_targets_textures(block, unique_images)
global CSVDIR
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
