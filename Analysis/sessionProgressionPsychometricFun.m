% Author: Atanu Giri
% Date: 01/26/2025
%
% 'feature' can be any column from ghrelin_featuretable.
% Example usage:
% featureForEach = sessionProgression('approachavoid', 
% 'P2A Boost and alcohol')
%
% OR
%
% animalList = {'aladdin', 'jafar', 'jimi', 'jr', 'mike', 'scar', 'sully'};
% featureForEach = psychometricFunctionPlotPerPartition('approachavoid', 
% 'P2A Boost and alcohol', animalList)
%
function varargout = sessionProgressionPsychometricFun(feature, treatmentGroup, animalList)

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

% Convert referencetime to datetime format
treatment_data.referencetime = datetime(treatment_data.referencetime, ...
    'InputFormat', 'MM/dd/yyyy');
% Sort the table by referencetime
treatment_data = sortrows(treatment_data, 'referencetime');

% Filter treatment_data if animalList is provided
if ~isempty(animalList)
    treatment_data = treatment_data(ismember(treatment_data.subjectid, animalList), :);
end

[featureForEach, stdErr, trialCt] = psychometricFunValuesPerSession(treatment_data, feature);

% Special for 'P2A Boost and alcohol'
if strcmpi(treatmentGroup, 'P2A Boost and alcohol')
    validSessions = trialCt(:,1) > 80;
    featureForEach = featureForEach(validSessions, :);
    stdErr = stdErr(validSessions, :);

    % Remove the first row as the animals were introduced to alcohol
    % for the first time
    featureForEach(1, :) = [];
    stdErr(1, :) = [];
end

% Plot Psychometric function
x = 1:4;
figure;
Colors = parula(size(featureForEach,1));

for session = 1:size(featureForEach,1)
    % Plot sessions
    plot(x, featureForEach(session,:), '.-', 'LineWidth', 2, 'Color', Colors(session, :), ...
        'DisplayName',sprintf('Session_%d', session));
    hold on;
    errorbar(x, featureForEach(session,:), stdErr(session,:),'LineStyle', 'none', ...
        'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');
end

hold off;
% Add label and legend
xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize', 25);
xticks(1:4);
label = {'0.5','2','5','9'};
set(gca,'xticklabel',label,'FontSize',15);
legend('show', 'Interpreter', 'none');

title(sprintf('%s', treatmentGroup), 'Interpreter','latex','FontSize',25);

% Return output
varargout{1} = featureForEach;