% Author: Atanu Giri
% Date: 08/20/2024

function combined_p = FisherMethod(data)

% Initialize p-values matrix
[~, numCols] = size(data{1});
p_values = zeros(numel(data)-1, numCols);

% Perform F-test for each column
for i = 2:numel(data)
    for j = 1:numCols
        [~, p_values(i-1,j)] = vartest2(data{1}(:, j), data{i}(:, j));
    end
end

% Combine p-values using Fisher's method
combined_p = zeros(1, numel(data)-1);

for i = 1:numel(data) - 1
    chi2_stat = -2 * sum(log(p_values(i,:)));
    combined_p(i) = 1 - chi2cdf(chi2_stat, 2 * length(p_values(i,:)));
end