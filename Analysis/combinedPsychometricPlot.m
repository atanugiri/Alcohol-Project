% Author: Atanu Giri
% Date: 12/27/2023
function  combinedPsychometricPlot(feature)
%
% This function returns psychometric plot of a feature with 4 different health
% types. You can get the individual bar plot with
% 'masterPsychometricFunctionPlot' funtion.
%
feature = 'distance_until_limiting_time_stamp_old';

[Sal_toyrat_id, Ghr_toyrat_id, Sal_toystick_id, Ghr_toystick_id, ~, ~] = extract_toy_expt_ids;
% [Sal_toyrat_id, Ghr_toyrat_id, Sal_toystick_id, Ghr_toystick_id] = extract_sal_ghr_ids;


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

% Get common subjectids
uniqueSubjectidSalTR = unique(saline_toyrat_data.subjectid);
uniqueSubjectidGhrTR = unique(ghrelin_toyrat_data.subjectid);
uniqueSubjectidSalTS = unique(saline_toystick_data.subjectid);
uniqueSubjectidGhrTS = unique(ghrelin_toystick_data.subjectid);
commonSubjectId = intersect(intersect(uniqueSubjectidSalTR, uniqueSubjectidGhrTR), ...
    intersect(uniqueSubjectidSalTS, uniqueSubjectidGhrTS));

% Extract the data corresponding to common subjectids
saline_toyrat_data = saline_toyrat_data(ismember(saline_toyrat_data.subjectid, commonSubjectId),:);
ghrelin_toyrat_data = ghrelin_toyrat_data(ismember(ghrelin_toyrat_data.subjectid, commonSubjectId),:);
saline_toystick_data = saline_toystick_data(ismember(saline_toystick_data.subjectid, commonSubjectId),:);
ghrelin_toystick_data = ghrelin_toystick_data(ismember(ghrelin_toystick_data.subjectid, commonSubjectId),:);

% Extract plot values
[featureListSalTR, avFeatureSalTR, stdErrSalTR] = psychometricFunValues(saline_toyrat_data, feature);
[featureListGhrTR, avFeatureGhrTR, stdErrGhrTR] = psychometricFunValues(ghrelin_toyrat_data, feature);
[featureListSalTS, avFeatureSalTS, stdErrSalTS] = psychometricFunValues(saline_toystick_data, feature);
[featureListGhrTS, avFeatureGhrTS, stdErrGhrTS] = psychometricFunValues(ghrelin_toystick_data, feature);

featureList = {featureListSalTR, featureListGhrTR, featureListSalTS, featureListGhrTS};
avgVal = [avFeatureSalTR; avFeatureGhrTR; avFeatureSalTS; avFeatureGhrTS];
stdErr = [stdErrSalTR; stdErrGhrTR; stdErrSalTS; stdErrGhrTS];

%% Plot
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

%% Statistics
% Reshape data to a 1-D array
for i = 1:numel(featureList)
    featureList{i} = reshape(featureList{i}', [], 1); % Transpose and reshape
end

[~, p_1vs2] = ttest(featureList{1}, featureList{2});
[~, p_3vs4] = ttest(featureList{3}, featureList{4});

text([1.5, 3.5], repmat(1.1 * max(avFeatureSalTR), [1, 2]), {sprintf("toyrat = %s", num2str(p_1vs2)), ...
    sprintf("toystick = %s", num2str(p_3vs4))});


%% save figure
myPath = "/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Fig files";
savefig(h, fullfile(myPath, sprintf('combinedPsychometricPlot_%s',string(feature))));
end