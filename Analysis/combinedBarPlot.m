% Author: Atanu Giri
% Date: 12/24/2023
function  combinedBarPlot(feature)
%
% This function returns bar plot of a feature with 4 different health
% types. You can get the individual bar plot with
% 'masterFunForBarPlotOfFeature' funtion.
%
% feature = 'rotation_pts_method1';

[Sal_toyrat_id, Ghr_toyrat_id, Sal_toystick_id, Ghr_toystick_id, ~, ~] = extract_health_ids;

salineToyratIdList = strjoin(arrayfun(@num2str, Sal_toyrat_id, 'UniformOutput', false), ',');
ghrelinToyratIdList = strjoin(arrayfun(@num2str, Ghr_toyrat_id, 'UniformOutput', false), ',');
salineToystickIdList = strjoin(arrayfun(@num2str, Sal_toystick_id, 'UniformOutput', false), ',');
ghrelinToystickIdList = strjoin(arrayfun(@num2str, Ghr_toystick_id, 'UniformOutput', false), ',');

% Extract table corresponding to idList
saline_toyrat_data = fetchHealthDataTable(feature, salineToyratIdList);
saline_toyrat_data(isoutlier(saline_toyrat_data.distance_until_limiting_time_stamp),:) = [];

ghrelin_toyrat_data = fetchHealthDataTable(feature, ghrelinToyratIdList);
ghrelin_toyrat_data(isoutlier(ghrelin_toyrat_data.distance_until_limiting_time_stamp),:) = [];

saline_toystick_data = fetchHealthDataTable(feature, salineToystickIdList);
saline_toystick_data(isoutlier(saline_toystick_data.distance_until_limiting_time_stamp),:) = [];

ghrelin_toystick_data = fetchHealthDataTable(feature, ghrelinToystickIdList);
ghrelin_toystick_data(isoutlier(ghrelin_toystick_data.distance_until_limiting_time_stamp),:) = [];

[featureListSalTR, avFeatureSalTR, stdErrSalTR] = barPlotValues(saline_toyrat_data, feature);
[featureListGhrTR, avFeatureGhrTR, stdErrGhrTR] = barPlotValues(ghrelin_toyrat_data, feature);
[featureListSalTS, avFeatureSalTS, stdErrSalTS] = barPlotValues(saline_toystick_data, feature);
[featureListGhrTS, avFeatureGhrTS, stdErrGhrTS] = barPlotValues(ghrelin_toystick_data, feature);

featureList = {featureListSalTR, featureListGhrTR, featureListSalTS, featureListGhrTS};
barVal = [avFeatureSalTR, avFeatureGhrTR, avFeatureSalTS, avFeatureGhrTS];
stdErr = [stdErrSalTR, stdErrGhrTR, stdErrSalTS, stdErrGhrTS];

% Plot
barColors = parula(numel(barVal));
h = figure;
for i = 1:numel(barVal)
    bar(i, barVal(i), 'FaceColor', barColors(i, :));
    hold on;
end

errorbar(1:length(barVal), barVal, stdErr, 'k', 'LineWidth',1.5, 'LineStyle','none');
legend('Saline toyrat', 'Ghrelin toyrat', 'Saline toystick', 'Ghrelin toystick');
ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize',25);
hold off;

% Statistics
pValue = nan(1, numel(barVal)-1);
for i = 1:length(pValue)
    [~, pValue(i)] = ttest2(featureList{1}, featureList{i+1});

    % Print on figure
    text(i+1, 1.1 * max(barVal), ['p = ', num2str(pValue(i))], 'Interpreter', 'latex', ...
    'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
    'Rotation', 45, 'Color', [0.8 0 0]);
end

% save figure
myPath = "/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Fig files";
savefig(h, fullfile(myPath, sprintf('overlaidBarPlot_%s',string(feature))));



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
