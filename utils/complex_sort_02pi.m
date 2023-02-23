function [sorted, idx] = complex_sort_02pi(arr)
[~, idx] = sort(exp(-1j * pi) * round(arr, 15));
sorted = arr(idx);
end
