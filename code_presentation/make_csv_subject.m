function make_csv_subject(cfg)
% cfg.tar.fam1 = 'sb'
% cfg.tar.fam2 = 'ap'
% cfg.subid = 'mv00'
% cfg.subnr = 1;

warning('Did you remember that id1 is always male? Is %s male and %s female?', ...
    cfg.tar.fam1, cfg.tar.fam2);

% get control stimuli
cfg = get_control_stimuli(cfg);
% write txt stimuli
write_txt_stim(cfg);
% make csv files
make_csv_search(cfg.subid);

% make order of the tasks
make_order_tasks(cfg.subid, cfg.subnr);