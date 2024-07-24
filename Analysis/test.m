loadFile = load('treatment_data.mat');
treatment_data = loadFile.treatment_data;

treatment_data_size = cell(1,2);
featuresToChange = {'acc_outlier_move_median', 'stoppingpts_per_unittravel_method6', ...
    'rotationpts_per_unittravel_method4'};

combinedData = [];

for i = 1:numel(treatment_data)
    data = treatment_data{i};
    for j = 1:numel(featuresToChange)
        data.(featuresToChange{j}) = data.(featuresToChange{j}) .* ...
            data.distance_until_limiting_time_stamp;
    end

    dataMatrix = data(:, [10:11, 13:17]);
    dataMatrix = table2array(dataMatrix);

    % Remove rows with any NaN values
    cleanData = dataMatrix(~any(isnan(dataMatrix), 2), :);
    treatment_data_size{i} = size(cleanData);
    combinedData = [combinedData; cleanData];
end

% Standardize the cleaned data
standardizedData = zscore(combinedData);

% Perform PCA
[coeff, score, latent, tsquared, explained, mu] = pca(standardizedData);

% Visualize and Interpret Results
numRowsMatrix1 = treatment_data_size{1}(1);
numRowsMatrix2 = treatment_data_size{2}(1);

% Separate scores back into the two groups
scores1 = score(1:size(treatment_data_size{1}, 1), :);
scores2 = score(1:size(treatment_data_size{2}, 1), :);


group = [repmat({'Group1'}, numRowsMatrix1, 1); repmat({'Group2'}, numRowsMatrix2, 1)];

% Plot the first two principal components
figure;
gscatter(score(:,1), score(:,2), group);
xlabel('Principal Component 1');
ylabel('Principal Component 2');
title('PCA of Treatment Groups');
legend('Group 1', 'Group 2');

% Plot cumulative explained variance
cumulativeVariance = cumsum(explained);
figure;
plot(cumulativeVariance);
xlabel('Number of Principal Components');
ylabel('Cumulative Explained Variance');
title('Explained Variance by Principal Components');
