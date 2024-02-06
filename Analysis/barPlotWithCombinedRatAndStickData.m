% Author: Atanu Giri
% Date: 12/24/2023

function  barPlotWithCombinedRatAndStickData(feature)
%
% This function returns bar plot of a feature as an avergare of all animal
% for combined toyrat and toystick data
feature = 'distance_until_limiting_time_stamp_old';


[Sal_toyrat_id, Ghr_toyrat_id, Sal_toystick_id, Ghr_toystick_id, ~, ~] = extract_toy_expt_ids;
% [Sal_toyrat_id, Ghr_toyrat_id, Sal_toystick_id, Ghr_toystick_id] = extract_sal_ghr_ids;

saline_toy_id = vertcat(Sal_toyrat_id, Sal_toystick_id);
ghrelin_toy_id = vertcat(Ghr_toyrat_id, Ghr_toystick_id);

% Generate the idList from the filtered data
salineToyIdList = strjoin(arrayfun(@num2str, saline_toy_id, 'UniformOutput', false), ',');
ghrelinToyIdList = strjoin(arrayfun(@num2str, ghrelin_toy_id, 'UniformOutput', false), ',');

% Extract table corresponding to idList
saline_toy_data = fetchHealthDataTable(feature, salineToyIdList);
saline_toy_data(isoutlier(saline_toy_data.distance_until_limiting_time_stamp_old),:) = [];

ghrelin_toy_data = fetchHealthDataTable(feature, ghrelinToyIdList);
ghrelin_toy_data(isoutlier(ghrelin_toy_data.distance_until_limiting_time_stamp_old),:) = [];

% Get common subjectids
uniqueSubjectidSal = unique(saline_toy_data.subjectid);
uniqueSubjectidGhr = unique(ghrelin_toy_data.subjectid);
commonSubjectId = intersect(uniqueSubjectidSal, uniqueSubjectidGhr);

% Extract the data corresponding to common subjectids
saline_toy_data = saline_toy_data(ismember(saline_toy_data.subjectid, commonSubjectId),:);
ghrelin_toy_data = ghrelin_toy_data(ismember(ghrelin_toy_data.subjectid, commonSubjectId),:);

[featureListSaline, avFeatureSal, stdErrSal] = psychometricFunValues(saline_toy_data, feature);
[featureListGhrelin, avFeatureGhr, stdErrGhr] = psychometricFunValues(ghrelin_toy_data, feature);

featureListSaline = reshape(featureListSaline', [], 1); % Transpose and reshape
featureListGhrelin = reshape(featureListGhrelin', [], 1);

featureList = {featureListSaline, featureListGhrelin};
barVal = zeros(1,numel(featureList));
stdErr = zeros(1,numel(featureList));

for i = 1:numel(featureList)
    barVal(i) = mean(featureList{i});
    stdErr(i) = std(featureList{i})/sqrt(length(featureList{i}));
end


% Bar Plot
barColors = parula(numel(barVal));
h = figure;
for i = 1:numel(barVal)
    bar(i, barVal(i), 'FaceColor', barColors(i, :));
    hold on;
end

errorbar(1:length(barVal), barVal, stdErr, 'r', 'LineWidth',2, 'LineStyle','none');
legend('Saline toy', 'Ghrelin toy');
ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize',25);

% Line plots
% Colors = parula(numel(featureList{1}));
% for i = 1:numel(featureList{1})
%     plot(1:2, [featureList{1}(i),featureList{2}(i)], 'Color', Colors(i,:));
% end


% Statistics
[~, pValue] = ttest(featureList{1}, featureList{2});

text(1.5, 0.5 * max(barVal), ['p = ', num2str(pValue)], 'Interpreter', 'latex', ...
    'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
    'Rotation', 45, 'Color', [0.8 0 0]);

% save figure
myPath = "/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Fig files";
% savefig(h, fullfile(myPath, sprintf('combinedBarPlot_%s',string(feature))));


%% Description of psychometricFunValues
    function [featureForEach, avFeature, stdErr] = psychometricFunValues(dataTable, feature)
        uniqueSubjectid = unique(dataTable.subjectid);
        featureForEach = zeros(length(uniqueSubjectid), 4);
        stdErr = zeros(1,4);

        for subject = 1:length(uniqueSubjectid)
            for conc = 1:4
                feederToFetch = 5 - conc;
                dataFilter = dataTable.subjectid == uniqueSubjectid(subject) ...
                    & dataTable.realFeederId == feederToFetch;
                featureArray = dataTable.(feature)(dataFilter, :);
                featureArray = featureArray(isfinite(featureArray));
                featureForEach(subject, conc) = sum(featureArray)/length(featureArray);
            end
        end

        avFeature = mean(featureForEach);

        for conc = 1:4
            stdErr(conc) = std(featureForEach(:,conc))/sqrt(length(featureForEach(:,conc)));
        end

    end % end of psychometricFunValues
end