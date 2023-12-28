% Author: Atanu Giri
% Date: 12/27/2023
function  combinedPsychometricPlot(feature)
%
% This function returns psychometric plot of a feature with 4 different health
% types. You can get the individual bar plot with
% 'masterPsychometricFunctionPlot' funtion.
%
% feature = 'distance_until_limiting_time_stamp_old';

[Sal_toyrat_id, Ghr_toyrat_id, Sal_toystick_id, Ghr_toystick_id, ~, ~] = extract_health_ids;

salineToyratIdList = strjoin(arrayfun(@num2str, Sal_toyrat_id, 'UniformOutput', false), ',');
ghrelinToyratIdList = strjoin(arrayfun(@num2str, Ghr_toyrat_id, 'UniformOutput', false), ',');
salineToystickIdList = strjoin(arrayfun(@num2str, Sal_toystick_id, 'UniformOutput', false), ',');
ghrelinToystickIdList = strjoin(arrayfun(@num2str, Ghr_toystick_id, 'UniformOutput', false), ',');

% Extract table corresponding to idList
saline_toyrat_data = fetchHealthDataTable(feature, salineToyratIdList);
saline_toyrat_data(isoutlier(saline_toyrat_data.distance_until_limiting_time_stamp_old),:) = [];

ghrelin_toyrat_data = fetchHealthDataTable(feature, ghrelinToyratIdList);
ghrelin_toyrat_data(isoutlier(ghrelin_toyrat_data.distance_until_limiting_time_stamp_old),:) = [];

saline_toystick_data = fetchHealthDataTable(feature, salineToystickIdList);
saline_toystick_data(isoutlier(saline_toystick_data.distance_until_limiting_time_stamp_old),:) = [];

ghrelin_toystick_data = fetchHealthDataTable(feature, ghrelinToystickIdList);
ghrelin_toystick_data(isoutlier(ghrelin_toystick_data.distance_until_limiting_time_stamp_old),:) = [];

% Extract plot values
[featureListSalTR, avFeatureSalTR, stdErrSalTR] = psychometricFunValues(saline_toyrat_data, feature);
[featureListGhrTR, avFeatureGhrTR, stdErrGhrTR] = psychometricFunValues(ghrelin_toyrat_data, feature);
[featureListSalTS, avFeatureSalTS, stdErrSalTS] = psychometricFunValues(saline_toystick_data, feature);
[featureListGhrTS, avFeatureGhrTS, stdErrGhrTS] = psychometricFunValues(ghrelin_toystick_data, feature);

featureList = {featureListSalTR, featureListGhrTR, featureListSalTS, featureListGhrTS};
avgVal = [avFeatureSalTR; avFeatureGhrTR; avFeatureSalTS; avFeatureGhrTS];
stdErr = [stdErrSalTR; stdErrGhrTR; stdErrSalTS; stdErrGhrTS];

% Plot
x = 1:4;
barColors = parula(size(avgVal,1));
h = figure;
for i = 1:size(avgVal,1)
    plot(x, avgVal(i, :), 'LineWidth', 2, 'Color', barColors(i, :));
    hold on;
    errorbar(x, avgVal(i,:), stdErr(i,:), 'k', 'LineWidth',1.5, 'LineStyle','none');
end

legend('Saline toyrat', '', 'Ghrelin toyrat', '', 'Saline toystick', '', 'Ghrelin toystick');
ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize',25);
hold off;

% save figure
myPath = "/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Fig files";
savefig(h, fullfile(myPath, sprintf('overlaidPsychometricPlot_%s',string(feature))));


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