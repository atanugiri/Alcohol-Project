% Author: Atanu Giri
% Date: 12/04/2023
%
% This function takes 'feature', animalList, and treatment
% group/s as input from and returns psychometric plot for that feature as
% an average of all animals
%
% Example usage
% [T1, T2] = masterPsychometricFunctionPlot( ...
% 'distance_until_limiting_time_stamp', {},'P2L1 Saline','P2L1 Ghrelin')
%
%% Invokes treatmentIDfun, fetchHealthDataTable, psychometricFunValues,
%% cleanBadSessionsFromTable.
%
function varargout = masterPsychometricFunctionPlot(feature, animalList, varargin)

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

% Extract psychometric plot values
featureForEach = cell(1, numel(treatment_data));
avFeature = cell(1, numel(treatment_data));
stdErr = cell(1, numel(treatment_data));

% Plot figure
x = 1:4;
figure;
Colors = parula(numel(treatment_data));

for grp = 1:numel(treatment_data)
    featureForEach{grp} = psychometricFunValues(treatment_data{grp}, feature);
    avFeature{grp} = mean(featureForEach{grp});
    stdErr{grp} = std(featureForEach{grp}) ./sqrt(size(featureForEach{grp}, 1));

    plot(x, avFeature{grp}, 'LineWidth', 2, 'Color', Colors(grp,:), ...
        'DisplayName',sprintf('%s', treatmentGroups{grp}));
    hold on;
    errorbar(x, avFeature{grp},stdErr{grp},'LineStyle', 'none', ...
        'LineWidth', 1.5, 'Color','k','HandleVisibility', 'off');
end

hold off;
legend('show', 'Interpreter', 'none');
ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize', 25);
xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
xticks(1:4);
label = {'0.5','2','5','9'};
set(gca,'xticklabel',label,'FontSize',15);

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

% Figure name
figname = sprintf('%s_%s_psychometric',[treatmentGroups{:}],string(feature));

% Save figure
scriptDir = fileparts(mfilename('fullpath'));
folderName = 'Fig files';
myPath = fullfile(scriptDir, folderName);
% Check if the folder exists, if not, create it
if ~exist(myPath, 'dir')
    mkdir(myPath);
end

savefig(gcf, fullfile(myPath, figname));