function [E, A_out] = NMF(T, R)

if ismatrix(T)
    M = double(T);
    C = size(T, 2);
else
    C = size(T, 3);
    M = reshape(double(T), [], C);
end
N = size(M, 1);
% remove saturated pixels and all zeros
idx = true(N, 1); 
for i = 1:N
    if any(M(i, :) == 255) || all(M(i, :) == 0)
        idx(i) = false;
    end
end
% idx = any(M, 2);
M = M(idx, :);
A = rand(size(M, 1), R);

E = rand(C, R); % endmember matrix
fit = norm(M - A * E.', 'fro');
for i = 1:1e3
    fit_old = fit;
    A = A .* (M*E) ./ (A*(E.')*E);
    E = E .* (M.'*A) ./ (E*(A.')*A);
    E(isnan(E)) = 0;
    E(E==Inf) = 0;
    E = E ./ max(E);
    A = A .* max(E);
    fit = norm(M - A * E.', 'fro');
    change = abs(fit_old - fit)/fit_old;
    % fprintf('Iter %2d: fit = %e fitdelta = %7.1e\n', i, fit, change);
    if (change < 1e-8) || (isnan(fit))
        break;
    end
end
A_out = zeros(N, R);
A = A / max(max(A));
A_out(idx, :) = A;
