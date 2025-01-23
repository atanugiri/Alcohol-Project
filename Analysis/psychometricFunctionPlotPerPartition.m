% Author: Atanu Giri
% Date: 01/14/2025
%
% 'feature' can be any column from ghrelin_featuretable.
% 'splitType' can be 'session' or 'trial', depending how the user wants to
% split the health group data.
%
% Example usage:
% psychometricFunctionPlotPerPartition('approachavoid', 'trial', 'P2A Boost
% and alcohol')
%
% OR
%
% animalList = {'aladdin', 'jafar', 'jimi', 'jr', 'mike', 'scar', 'sully'};
% psychometricFunctionPlotPerPartition('approachavoid', 'trial', 'P2A Boost
% and alcohol', animalList)

function varargout = psychometricFunctionPlotPerPartition(feature, splitType, treatmentGroup, animalList)
%
% feature = 'approachavoid';
% splitType = 'trial';
% treatmentGroup = 'P2L1 Post alcohol';

if nargin < 4
    animalList = {};
end

treatment_table = extractTreatmentData(feature, splitType, {treatmentGroup});
treatment_data = treatment_table{1,1};
treatment_data = cleanBadSessionsFromTable(treatment_data, feature); % Remove bad sessions

% Filter treatment_data if animalList is provided
if ~isempty(animalList)
    treatment_data = treatment_data(ismember(treatment_data.subjectid, animalList), :);
end


if strcmpi(splitType, 'trial')
    featureForEach = cell(1,4); 
    % featureForEach = zeros(4,4); % 4 trial sections x 4 conc.

    x = 1:4;
    figure;
    Colors = parula(4);

    for j = 1:4
        % Compute the range for trialname based on j
        trialRange = ((j-1)*10 + 1):(j*10);

        % Filter treatment_data{i} based on trialname range
        splitData = treatment_data(ismember(treatment_data.trialname, trialRange), :);

        featurePerSession = psychometricFunValuesPerSession(splitData, feature);
        avFeature = mean(featurePerSession,1);
        std_dev = std(featurePerSession);
        stdErr = std_dev ./sqrt(size(featurePerSession, 1));

        plot(x, avFeature, '.-', 'LineWidth', 2, 'Color', Colors(j, :), ...
            'DisplayName',sprintf('Trial_section_%d', j));
        hold on;
        errorbar(x, avFeature, stdErr,'LineStyle', 'none', ...
            'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');

        featureForEach{j} = featurePerSession;
        % featureForEach(j,:) = avFeature;

    end

    varargout{1} = featureForEach;

elseif strcmpi(splitType, 'session')
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

    varargout{1} = featureForEach;

else
    error('Invalid splitType: "%s". Valid options are "trial" or "session".', splitType);
end

% Add label and legend
xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize', 25);
xticks(1:4);
label = {'0.5','2','5','9'};
set(gca,'xticklabel',label,'FontSize',15);
legend('show', 'Interpreter', 'none');

title(sprintf('%s', treatmentGroup), 'Interpreter','latex','FontSize',25);