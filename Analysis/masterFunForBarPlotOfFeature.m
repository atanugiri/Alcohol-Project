% Author: Atanu Giri
% Date: 12/01/2023
%
% This function takes feature, animalList, and treatment group as input
% from 'ghrelin_featuretable' and returns bar plot for that feature as
% an average. Use animalList input to extract male/female data.
%
% Example usage:
% masterFunForBarPlotOfFeature('distance_until_limiting_time_stamp',
% {}, 'Alcohol bl', 'Alcohol')
%
% Invokes treatmentIDfun, fetchHealthDataTable, barPlotValues, cleanBadSessionsFromTable.
%
function varargout = masterFunForBarPlotOfFeature(feature, animalList, varargin)
% feature = 'approachavoid';
% splitByGender = 'n';
% varargin = {'P2L1L3 Saline'};

% Set default animalList if not provided
if nargin < 2 || isempty(animalList)
    animalList = {};
end

treatmentGroups = varargin;
treatmentIDs = cell(1, numel(treatmentGroups));

parfor i = 1:numel(treatmentGroups)
    % Connect to database
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');

    treatmentIDs{i} = treatmentIDfun(treatmentGroups{i}, conn);

    close(conn);
end

% Generate the idList from the filtered data
treatmentIDs_str = cellfun(@(x) strjoin(arrayfun(@num2str, x, 'UniformOutput', ...
    false), ','), treatmentIDs, 'UniformOutput', false);
treatment_data = cell(1, numel(treatmentIDs_str));

% L1 and L3 task in L1L3 will naturally have 20 trials
trtGroupsToExclude = {'P2L1L3 Baseline L1','P2L1L3 Baseline L3', ...
    'P2L1L3 BL for comb boost and alc L1', 'P2L1L3 BL for comb boost and alc L3', ...
    'P2L1L3 Boost and alcohol L1', 'P2L1L3 Boost and alcohol L3', ...
    'P2L1L3 Post alcohol L1', 'P2L1L3 Post alcohol L3'};

parfor i = 1:numel(treatment_data)
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');

    treatment_data{i} = fetchHealthDataTable(feature, treatmentIDs_str{i}, conn);
    if ~ismember(treatmentGroups{i}, trtGroupsToExclude)
        treatment_data{i} = cleanBadSessionsFromTable(treatment_data{i}, feature); % Remove bad sessions
    end

    close(conn);
end

% Filter treatment_data if animalList is provided
if ~isempty(animalList)
    for i = 1:numel(treatment_data)
        treatment_data{i} = treatment_data{i}(ismember(treatment_data{i}.subjectid, animalList), :);
    end
end

% Extract bar plot values
featureForEach = cell(1, numel(treatment_data));
avFeature = zeros(1, numel(treatment_data));
stdErr = zeros(1, numel(treatment_data));

% Plot figure
figure;
Colors = parula(numel(treatmentGroups));

for grp = 1:numel(treatment_data)
    %featureForEachSession = psychometricFunValuesPerSession(treatment_data{grp}, feature);
    featureForEachSession = psychometricFunValues(treatment_data{grp}, feature);
    featureForEach{grp} = mean(featureForEachSession, 2);
    avFeature(grp) = mean(featureForEach{grp});
    stdErr(grp) = std(featureForEach{grp})/sqrt(length(featureForEach{grp}));

    bar(grp, avFeature(grp), 'FaceColor',Colors(grp,:));
    hold on;
    errorbar(grp, avFeature(grp),stdErr(grp),'LineStyle', 'none', ...
        'LineWidth', 1.5, 'Color','k');
end

hold off;

xticks(1:numel(treatment_data)); % Set x-ticks
xticklabels(treatmentGroups); % Set x-tick labels
% xtickangle(45); % Rotate the x-tick labels by 45 degrees
ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize', 25);

% Return output
if nargout <= 1
    % Return a single cell array if only one output is requested
    varargout{1} = featureForEach;
else
    varargout = cell(1, numel(treatment_data));
    % Return separate outputs for each group if multiple outputs are requested
    for i = 1:numel(treatment_data)
        varargout{i} = featureForEach{i};
    end
end

%% Statistics
if numel(varargin) >= 2
    p_value = zeros(1, numel(treatment_data) - 1);
    for grp = 2:numel(treatment_data)
        [~, p_value(grp-1)] = ttest2(featureForEach{1}, featureForEach{grp});
        text(grp, max(ylim), sprintf("p = %.4f", p_value(grp-1)));
    end
end

% Save figure
figname = sprintf('%s_%s_bar',[treatmentGroups{:}],string(feature));

% Figure name
scriptDir = fileparts(mfilename('fullpath'));
folderName = 'Fig files';
myPath = fullfile(scriptDir, folderName);
% Check if the folder exists, if not, create it
if ~exist(myPath, 'dir')
    mkdir(myPath);
end

savefig(gcf, fullfile(myPath, figname));