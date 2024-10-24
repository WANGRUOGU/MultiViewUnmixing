function A_out = NLS(T, E, dis)

if ismatrix(T)
    M = double(T);
else
    C = size(T, 3);
    M = reshape(double(T), [], C);
end
R = size(E, 2);
idx = any(M, 2);
N = size(M, 1);
M = M(idx, :);
scale = sqrt(mean(M.^2, 2)); % pixel-wise normalization
M = M ./ scale;
A = ((E'*E)^(-1)*E'*M')';
A(A < 0) = 0;
fit = norm(M - A * E.', 'fro');
for i = 1:1e3
    fit_old = fit;
    A = A .* (M*E) ./ (A*(E.')*E);
    fit = norm(M - A * E.', 'fro');
    change = abs(fit_old - fit)/fit_old;
    if dis == 1
        fprintf('Iter %2d: fit = %e fitdelta = %7.1e\n', ...
       i, fit, change);
    end
    if (change < 1e-8) || (isnan(fit))
        break;
    end
end
A_out = zeros(N, R);
A = A .* scale;
A = A / max(max(A));
A_out(idx, :) = A;
end