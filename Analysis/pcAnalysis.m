% Author: Atanu Giri
% Date: 07/21/2024
%

function pcAnalysis(varargin)

varargin = {'P2L1 BL for comb boost and alc','P2L1 Boost and alcohol'};

% Connect to database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% Extract treatment ids
treatmentGroups = varargin;
treatmentIDs = cell(1, numel(treatmentGroups));
for i = 1:numel(treatmentGroups)
    treatmentIDs{i} = treatmentIDfun(treatmentGroups{i}, conn);
end

% Generate the idList from the filtered data
treatmentIDs_str = cellfun(@(x) strjoin(arrayfun(@num2str, x, 'UniformOutput', ...
    false), ','), treatmentIDs, 'UniformOutput', false);

treatment_data = cell(1, numel(treatmentIDs_str));

for i = 1:numel(treatmentIDs_str)
    treatment_data{i} = fetchHealthDataTable(treatmentIDs_str{i}, conn);
    treatment_data{i} = cleanBadSessionsFromTable(treatment_data{i}, 'approachavoid'); % Remove bad sessions
end

combinedData = [];
% Combine data for PCA
for i = 1:numel(treatment_data)
    combinedData = [combinedData; treatment_data{i}];
end

combinedData = combinedData(:, 10:17);
combinedData = table2array(combinedData);

% Perform PCA
[coeff, score, latent, tsquared, explained, mu] = pca(combinedData);

% Separate scores back into the two groups
scores1 = score(1:size(treatment_data{1}, 1), :);
scores2 = score(size(treatment_data{1}, 1) + 1:end, :);

% Combine scores for MANOVA
groupScores = [scores1; scores2];
groupLabels = [repmat({'Group1'}, size(scores1, 1), 1); repmat({'Group2'}, size(scores2, 1), 1)];
[d, p, stats] = manova1(groupScores, groupLabels);


%% Description of fetchHealthDataTable
    function treatment_data = fetchHealthDataTable(treatmentIDs_str, conn)
        featureList = {'passing_center_50', 'time_in_center_50', 'already_in_center_50', ...
            'acc_outlier_move_median', 'distance_until_limiting_time_stamp', ...
            'stoppingpts_per_unittravel_method6', 'rotationpts_per_unittravel_method4', ...
            'time_in_feeder_25', 'entry_time_25'};

        liveTableQuery = sprintf("SELECT id, subjectid, referencetime, gender, feeder, " + ...
            "health, trialcontrolsettings, tasktypedone, approachavoid FROM live_table " + ...
            "WHERE id IN (%s) ORDER BY id;", treatmentIDs_str);
        liveTableData = fetch(conn, liveTableQuery);

        featureString = strjoin(featureList, ', ');
        featureQuery = sprintf("SELECT id, %s FROM ghrelin_featuretable WHERE id IN " + ...
            "(%s) ORDER BY id", featureString, treatmentIDs_str);
        featureData = fetch(conn, featureQuery);

        treatment_data = innerjoin(liveTableData,featureData,'Keys','id');

        treatment_data.referencetime = datetime(treatment_data.referencetime, 'Format', 'MM/dd/yyyy');
        treatment_data = sortrows(treatment_data, 'referencetime');

        for col = 2:8 %size(treatment_data, 2)
            treatment_data.(col) = string(treatment_data.(col));
        end

        for col = 9:size(treatment_data, 2)
            treatment_data.(col) = str2double(treatment_data.(col));
        end

        treatment_data.feeder = str2double(treatment_data.feeder);

        for j = 1:height(treatment_data)
            if contains(treatment_data.trialcontrolsettings(j), "Diagonal","IgnoreCase",true)
                treatment_data.realFeederId(j) = 1;
            elseif contains(treatment_data.trialcontrolsettings(j), "Grid","IgnoreCase",true)
                treatment_data.realFeederId(j) = 2;
            elseif contains(treatment_data.trialcontrolsettings(j), "Horizontal","IgnoreCase",true)
                treatment_data.realFeederId(j) = 3;
            elseif contains(treatment_data.trialcontrolsettings(j), "Radial","IgnoreCase",true)
                treatment_data.realFeederId(j) = 4;
            else
                treatment_data.realFeederId(j) = treatment_data.feeder(j);
            end
        end
    end
end