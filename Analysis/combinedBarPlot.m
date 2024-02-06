% Author: Atanu Giri
% Date: 12/24/2023
function  combinedBarPlot(feature)
%
% This function returns bar plot of a feature with 4 different health
% types. You can get the individual bar plot with
% 'masterFunForBarPlotOfFeature' funtion.
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

% Fetch data
featureListSalTR = psychometricFunValues(saline_toyrat_data, feature);
featureListGhrTR = psychometricFunValues(ghrelin_toyrat_data, feature);
featureListSalTS = psychometricFunValues(saline_toystick_data, feature);
featureListGhrTS = psychometricFunValues(ghrelin_toystick_data, feature);

featureList = {featureListSalTR, featureListGhrTR, featureListSalTS, featureListGhrTS};
for i = 1:numel(featureList)
    featureList{i} = reshape(featureList{i}', [], 1); % Transpose and reshape
end

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
legend('Saline toyrat', 'Ghrelin toyrat', 'Saline toystick', 'Ghrelin toystick');
ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize',25);

% Plot black dots over each bar
for i = 1:numel(featureList)
    xValues = repmat(i-0.1, 1, length(featureList{i}));
    scatter(xValues, featureList{i}, 'k', 'filled');
    hold on;
end
hold off;

% % Boxplot
% boxplot([featureList{1}, featureList{2}, featureList{3}, featureList{4}], ...
%     'Labels', {'SalTR', 'GhrTR', 'SalTS', 'GhrTS'});

% Statistics
[~, p_1vs2] = ttest(featureList{1}, featureList{2});
[~, p_3vs4] = ttest(featureList{3}, featureList{4});

text([2, 4], repmat(1.1 * max(barVal), [1, 2]), {sprintf("toyrat = %s", num2str(p_1vs2)), ...
    sprintf("toystick = %s", num2str(p_3vs4))}, 'Interpreter', 'latex', ...
    'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
    'Rotation', 45, 'Color', [0.8 0 0]);

% save figure
myPath = "/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Fig files";
% savefig(h, fullfile(myPath, sprintf('overlaidBarPlot_%s',string(feature))));



%% Description of psychometricFunValues
    function featureForEach = psychometricFunValues(dataTable, feature)
        uniqueSubjectid = unique(dataTable.subjectid);
        featureForEach = zeros(length(uniqueSubjectid), 4);

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
    end % end of psychometricFunValues
end
