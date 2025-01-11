datasource = 'live_database';
conn = database(datasource,'postgres','1234');

BL_P2L1_id = extract_treatment_ids(conn);
BL_P2L1_id_str = strjoin(arrayfun(@num2str, BL_P2L1_id, 'UniformOutput', false), ',');

query = sprintf('SELECT * FROM ghrelin_featuretable WHERE id IN (%s)', BL_P2L1_id_str);
data = fetch(conn, query);
featureData = data(:, [2:4, 8,10, 11, 17, 21, 23]);

% Step 1: Convert all data from string to numeric using str2double
numericData = str2double(table2array(featureData));  % Convert the table to an array of numbers

% Step 2: Remove rows with NaN values (those which couldn't be converted)
validRows = all(~isnan(numericData), 2);  % Rows that are not NaN
cleanData = numericData(validRows, :);  % Keep only valid rows

% Step 3: Compute the correlation matrix if there is valid data
if ~isempty(cleanData)  % Ensure there is valid data left
    corrMatrix = corr(cleanData);  % Compute the correlation matrix
end

% Step 4: Create a heatmap of the correlation matrix
figure;  % Create a new figure window
heatmap(corrMatrix, 'Colormap', jet, 'ColorbarVisible', 'on');

% Step 5: Set row and column labels to match the feature names from the table
% Assuming the columns of the original table are the features you want to label
featureNames = featureData.Properties.VariableNames;

% Set the heatmap labels for rows and columns
ax = gca;  % Get the current axes
ax.XDisplayLabels = sprintf('%s',featureNames);  % Set the x-axis labels (column names)
ax.YDisplayLabels = sprintf('%s',featureNames);  % Set the y-axis labels (row names)

% Add title and labels for clarity
title('Correlation Matrix Heatmap');