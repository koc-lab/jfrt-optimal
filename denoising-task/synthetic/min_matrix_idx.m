function [varargout] = min_matrix_idx(matrix)
[~, I] = min(matrix(:));

if nargout == 1
    dimension_count = ndims(matrix);
    [idx{1:dimension_count}] = ind2sub(size(matrix), I);
    varargout{1} = idx;
else
    [varargout{1:nargout}] = ind2sub(size(matrix), I);
end
end
