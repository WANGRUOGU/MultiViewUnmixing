function DisplayA(A_sv, A_mv, R)

% colormap
idx = 1:R;
idx(1:2:R) = 1:((R+1)/2);
idx(2:2:R) = round(R/2+1):R;
map = jet(R);
map = map(idx, :);
c = [zeros(1, 3); map];

sz = sqrt(size(A_mv, 1));
figure
tiledlayout(1, 2)
A_temp = reshape(A_sv, sz, sz, R);
[~,idx] = max(A_temp, [], 3);
idx = idx + 1;
idx(~ any(A_temp, 3)) = 1;
nexttile, imshow(idx, c)
title('Single-view')
A_temp = reshape(A_mv, sz, sz, R);
[~,idx] = max(A_temp, [], 3);
idx = idx + 1;
idx(~ any(A_temp, 3)) = 1;
nexttile, imshow(idx, c)
title('Multi-view')