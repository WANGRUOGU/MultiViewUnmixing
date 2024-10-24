function [submatrix,row,col] = find_max_nonzero_submatrix(A, sz)
if ismatrix(A)
    sz_A = sqrt(size(A, 1));
    T = reshape(A, sz_A, sz_A, size(A, 2));
else
    T = double(A);
    sz_A = size(A, 1);
end
matrix = max(T, [], 3);
max_nonzeros = 0;
row_start = 1;
col_start = 1;

b = 30;
for i = 1:b:(sz_A - (sz-1))
    for j = 1:b:(sz_A - (sz-1))
        submatrix = matrix(i:i+(sz-1), j:j+(sz-1));
        num_nonzeros = nnz(submatrix);

        if num_nonzeros > max_nonzeros
            max_nonzeros = num_nonzeros;
            row_start = i;
            col_start = j;
        end
    end
end

row = row_start:row_start+(sz-1);
col = col_start:col_start+(sz-1);
submatrix = T(row, col, :);
end