% Author: Atanu Giri
% Date: 01/26/2025
%
% 'feature' can be any column from ghrelin_featuretable.
% Example usage:
% [t1, t2, t3, t4] = trialProgression('approachavoid', 
% 'P2A Boost and alcohol')
%
% OR
%
% animalList = {'aladdin', 'jafar', 'jimi', 'jr', 'mike', 'scar', 'sully'};
% [t1, t2, t3, t4] = psychometricFunctionPlotPerPartition('approachavoid', 
% 'P2A Boost and alcohol', animalList)
%
function varargout = trialProgressionPsychometricFun(feature, treatmentGroup, animalList)

if nargin < 3
    animalList = {};
end

datasource = 'live_database';
conn = database(datasource, 'postgres', '1234');

treatmentIDs = treatmentIDfun(treatmentGroup, conn);

% Generate the idList from the filtered data
treatmentIDs_str = strjoin(arrayfun(@num2str, treatmentIDs, 'UniformOutput', false), ',');
treatment_data = fetchHealthDataTable(feature, treatmentIDs_str, conn);

% L1 and L3 task in L1L3 will naturally have 20 trials
trtGroupsToExclude = {'P2L1L3 BL for comb boost and alc L1', ...
    'P2L1L3 BL for comb boost and alc L3','P2L1L3 Boost and alcohol L1', ...
    'P2L1L3 Boost and alcohol L3', 'P2L1L3 Post alcohol L1', ...
    'P2L1L3 Post alcohol L3'};

if ~ismember(treatmentGroup,trtGroupsToExclude)
    treatment_data = cleanBadSessionsFromTable(treatment_data, feature); % Remove bad sessions
end

treatment_data = sortrows(treatment_data, 'trialname');

% Filter treatment_data if animalList is provided
if ~isempty(animalList)
    treatment_data = treatment_data(ismember(treatment_data.subjectid, animalList), :);
end

featureForEach = cell(1,4);

x = 1:4;
figure;
Colors = parula(4);

for j = 1:4
    % Compute the range for trialname based on j
    trialRange = ((j-1)*10 + 1):(j*10);

    % Filter treatment_data{i} based on trialname range
    splitData = treatment_data(ismember(treatment_data.trialname, trialRange), :);

    featurePerSession = psychometricFunValuesPerSession(splitData, feature);
    avFeature = mean(featurePerSession);
    std_dev = std(featurePerSession);
    stdErr = std_dev ./sqrt(size(featurePerSession, 1));

    plot(x, avFeature, '.-', 'LineWidth', 2, 'Color', Colors(j, :), ...
        'DisplayName',sprintf('Trial_section_%d', j));
    hold on;
    errorbar(x, avFeature, stdErr,'LineStyle', 'none', ...
        'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');

    featureForEach{j} = featurePerSession;

end

% Add label and legend
hold off;
xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize', 25);
xticks(1:4);
label = {'0.5','2','5','9'};
set(gca,'xticklabel',label,'FontSize',15);
legend('show', 'Interpreter', 'none');

title(sprintf('%s', treatmentGroup), 'Interpreter','latex','FontSize',25);

% Return output
if nargout <= 1
    % Return a single cell array if only one output is requested
    varargout{1} = featureForEach;
else
    % Return separate outputs for each cell
    for i = 1:min(nargout, 4) % Ensure it doesn't exceed the number of cells
        varargout{i} = featureForEach{i};
    end
end