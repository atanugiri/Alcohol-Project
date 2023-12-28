% Author: Atanu Giri
% Date: 12/24/2023

function  barPlotWithCombinedRatAndStickData(feature)
%
% This function returns bar plot of a feature as an avergare of all animal
% for combined toyrat and toystick data
% feature = 'jerk_outlier_move_median';

[Sal_toyrat_id, Ghr_toyrat_id, Sal_toystick_id, Ghr_toystick_id, ~, ~] = extract_health_ids;

saline_toy_id = vertcat(Sal_toyrat_id, Sal_toystick_id);
ghrelin_toy_id = vertcat(Ghr_toyrat_id, Ghr_toystick_id);

% Generate the idList from the filtered data
salineToyIdList = strjoin(arrayfun(@num2str, saline_toy_id, 'UniformOutput', false), ',');
ghrelinToyIdList = strjoin(arrayfun(@num2str, ghrelin_toy_id, 'UniformOutput', false), ',');

% Extract table corresponding to idList
saline_toy_data = fetchHealthDataTable(feature, salineToyIdList);
saline_toy_data(isoutlier(saline_toy_data.distance_until_limiting_time_stamp),:) = [];

ghrelin_toy_data = fetchHealthDataTable(feature, ghrelinToyIdList);
ghrelin_toy_data(isoutlier(ghrelin_toy_data.distance_until_limiting_time_stamp),:) = [];

[featureListSaline, avFeatureSal, stdErrSal] = barPlotValues(saline_toy_data, feature);
[featureListGhrelin, avFeatureGhr, stdErrGhr] = barPlotValues(ghrelin_toy_data, feature);

barVal = [avFeatureSal, avFeatureGhr];
stdErr = [stdErrSal, stdErrGhr];

% Plot
barColors = parula(numel(barVal));
h = figure;
for i = 1:numel(barVal)
    bar(i, barVal(i), 'FaceColor', barColors(i, :));
    hold on;
end

errorbar(1:length(barVal), barVal, stdErr, 'k', 'LineWidth',1.5, 'LineStyle','none');
legend('Saline toy', 'Ghrelin toy');
ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize',25);
hold off;

% Statistics
[~, pValue] = ttest2(featureListSaline, featureListGhrelin);
text(2, 1.1 * max(barVal), ['p = ', num2str(pValue)], 'Interpreter', 'latex', ...
    'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
    'Rotation', 45, 'Color', [0.8 0 0]);

% save figure
myPath = "/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Fig files";
savefig(h, fullfile(myPath, sprintf('combinedBarPlot_%s',string(feature))));




%% Description of barPlotValues
    function [featureForEach, avFeature, stdErr] = barPlotValues(dataTable, feature)
        % dataTable = femaleData; % for testing
        uniqueSubjectid = unique(dataTable.subjectid);
        featureForEach = zeros(length(uniqueSubjectid),1);

        for subject = 1:length(uniqueSubjectid)
            featureArray = dataTable.(feature)(dataTable.subjectid == uniqueSubjectid(subject), :);
            featureArray = featureArray(isfinite(featureArray));
            featureForEach(subject) = sum(featureArray)/length(featureArray);
        end

        avFeature = mean(featureForEach);
        stdErr = std(featureForEach)/sqrt(length(featureForEach));
    end
end