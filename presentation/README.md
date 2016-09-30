# presentation

This directory contains the Psychtoolbox/MATLAB code used for presenting the experiment. The experiment was run with **Psychtoolbox version 3.0.12** in **MATLAB R2014b** on a GNU/Linux workstation (Xubuntu 14.04 with low-latency
kernel 3.13, CPU AMD FX-4350 quad-core 4.2 GHz, 8GB RAM, AMD Radeon R9 270 video card with radeon drivers) and a DELL 2000FP screen.

The main files are

- `make_csv_subject.m` to make the csv files containing trial-order information, and the block order;


- `image_training_subj.m` for the familiarization phase before the experiment, showing all pictures that would be used in the experiment;
- `vis_search_part.m`, which calls `vis_search.m` to run the actual experiment (divided into two parts of four blocks each).

## Known issues

- `make_order_task.m` doesn't properly counterbalance the sex of the target across the first and second part of the experiment; this has been noted on the manuscript, and resulted in 12/19 subjects with male targets in the first half of the experiment, and 7/19 subjects with female targets in the first half of the experiment.

## Credit

- `angle2pix.m` was created by Alireza Soltani's lab at Dartmouth, and modified by mvdoc
- `cell2csv.m` was created by Rob Kohr, and found on [MATLAB File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/7601-cell2csv)

## 