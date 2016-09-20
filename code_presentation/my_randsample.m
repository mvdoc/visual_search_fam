function res = my_randsample(list, dim, replacement)

if nargin < 3, replacement = 0; end;
res = zeros(dim);
nrows = dim(1);
ncols = dim(2);
for i = 1 : nrows
    res(i, :) = randsample(list, ncols, replacement);
end

end