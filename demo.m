%% Load data
close all
addpath(genpath(pwd))
dataPath = './data/'; % Specify the path to the data here
name = {'AF488', 'AF514', 'AF532', 'ATTO542', 'AF555', 'RRX', 'AF594', ...
    'AF610', 'ATTO620', 'AF633', 'AF647', 'ATTO655', 'AF660'}; % Fluorophore names
laser = {'445', '488', '514', '561', '594', '639'}; % Laser wavelengths
R = length(name); % Number of fluorophores
I = length(laser); % Number of lasers
ref = cell(I, R); % Cell array to store reference images
mix = cell(I, 1); % Cell array to store mixture images
ref_3L = cell(1, R); % Cell array to store three-laser reference images

% Load the mixed image using lasers 488, 561, and 639
mix_3L = tiffreadVolume([dataPath, 'mix_L488_L561_L639.tif']); 

% Loop through each laser and fluorophore to load individual images
for i = 1:I
    for r = 1:R
        filename = [dataPath, name{r}, '_L', laser{i}, '.tif'];
        fprintf('Processing %s...\n', filename);
        ref{i, r} = tiffreadVolume(filename); % Load reference image
    end
    filename = [dataPath, 'mix_L', laser{i}, '.tif'];
    fprintf('Processing %s...\n', filename);
    mix{i} = tiffreadVolume(filename); % Load mixture image for current laser
end

% Load three-laser reference images
for r = 1:R
    filename = [dataPath, name{r}, '_L488_L561_L639.tif'];
    fprintf('Processing %s...\n', filename);
    ref_3L{r} = tiffreadVolume(filename); % Load reference image for 3 lasers
end

%% Remove background
C = zeros(I, 1); % Initialize array to store the number of slices per mixture
for i = 1:I
    C(i) = size(mix{i}, 3); % Get the number of slices in each mixture
end
C_3L = size(mix_3L, 3); % Get the number of slices in the three-laser mixture
ref_BR = cell(1, R); % Cell array to store background-removed reference images
ref_3L_BR = cell(1, R); % Cell array to store background-removed 3-laser reference images

% Remove background from reference and 3-laser images
for r = 1:R
    ref_3L_BR{r} = removeBackground(ref_3L{r}); % Remove background from 3-laser reference
    ref_BR{r} = removeBackground(cat(3, ref{:, r})); % Remove background from all single-laser images combined
    fprintf('Fluorophore %s cleaned...\n', name{r});
end

% Remove background from mixture images
mix_BR = removeBackground(cat(3, mix{:}));
mix_3L_BR = removeBackground(mix_3L);

%% Endmember extraction
tic;
E_mv = zeros(sum(C), R); % Initialize matrix for multi-view but single-laser endmembers
E_sv = zeros(C_3L, R); % Initialize matrix for 3-laser endmembers

% Extract endmembers using NMF for each fluorophore
for r = 1:R
    [E_sv(:, r), ~] = NMF(ref_3L_BR{r}, 1); % Single-view (3-laser) endmembers
    [E_mv(:, r), ~] = NMF(ref_BR{r}, 1);    % Multi-view but single-laser endmembers
end
toc;

%% Unmix E. coli images
prop_mv = zeros(1, R); % Initialize proportion matrix for multi-view but single-laser images
prop_sv = zeros(1, R); % Initialize proportion matrix for 3-laser images
A_ref_mv = cell(1, R); % Initialize cell array for multi-view but single-laser abundance maps
A_ref_sv = cell(1, R); % Initialize cell array for 3-laser abundance maps
sz_unmix = 100; % Size of image used for abundance estimation

% Unmix reference images and calculate cell proportions for each fluorophore
tic;
for r = 1:R
    [submatrix, row, col] = find_max_nonzero_submatrix(ref_BR{r}, sz_unmix); % Find non-zero region in the image
    A_ref_mv{r} = NLS(submatrix, E_mv, 0); % Perform non-negative least squares (NLS) for multi-view but single-laser image
    A_ref_sv{r} = NLS(ref_3L_BR{r}(row, col, :), E_sv, 0); % Perform NLS for 3-laser image
    fprintf('Reference image of %s was unmixed.\n', name{r});
    
    % Calculate proportion of E. coli for multi-view but single-laser and 3-laser images
    idx = any(A_ref_mv{r}, 2);
    prop_mv(r) = mean(A_ref_mv{r}(idx, r) ./ sum(A_ref_mv{r}(idx, :), 2));
    idx = any(A_ref_sv{r}, 2);
    prop_sv(r) = mean(A_ref_sv{r}(idx, r) ./ sum(A_ref_sv{r}(idx, :), 2));
end
toc;

% Unmix the mixed images
sz_unmix = 200; % Size of image used for abundance estimation in mixed image
[submatrix, row, col] = find_max_nonzero_submatrix(mix_BR, sz_unmix); % Find non-zero region in mixed image
A_mix_sv = NLS(mix_3L_BR(row, col, :), E_sv, 0); % Perform NLS for 3-laser mixed image
A_mix_mv = NLS(submatrix, E_mv, 0); % Perform NLS for multi-view but single-laser mixed image
fprintf('Mixed image was unmixed.\n');

%% Abundance map visualization
for r = 1:R
    DisplayA(A_ref_sv{r}, A_ref_mv{r}, R); % Display abundance map for each fluorophore
end
DisplayA(A_mix_sv, A_mix_mv, R); % Display abundance map for the mixed image
