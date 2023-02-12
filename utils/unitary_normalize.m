function U = unitary_normalize(A, dim)
if ~exist('dim', 'var'), dim = "col"; end

if dim == "col"
    first = A(1, :);
elseif dim == "row"
    first = A(:, 1);
else
    error("`dim` can be either `row` | `col`");
end

shifts = exp(-1j * angle(first));
U = A .* shifts;
end


