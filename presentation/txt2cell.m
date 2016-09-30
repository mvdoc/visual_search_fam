function out = txt2cell(fn)
% TXT2CELL reuturns the lines of fn as a cell
fid = fopen(fn);
tmp = textscan(fid, '%s');
fclose(fid);

out = tmp{1};