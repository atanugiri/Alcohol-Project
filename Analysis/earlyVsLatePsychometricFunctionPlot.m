% Author: Atanu Giri
% Date: 01/10/2025
%
function varargout = earlyVsLatePsychometricFunctionPlot(feature, sessionFraction, varargin)
%
% feature = 'approachavoid';
% varargin = {'P2A Boost and alcohol'};
% sessionFraction = 0.5;

datasource = 'live_database';
treatmentGroups = varargin;
treatmentIDs = cell(1, numel(treatmentGroups));

parfor i = 1:numel(treatmentGroups)
    % Create a new database connection for each worker
    conn = database(datasource, 'postgres', '1234');
    treatmentIDs{i} = treatmentIDfun(treatmentGroups{i}, conn);
    % Close the connection after use
    close(conn);
end

% Generate the idList from the filtered data
treatmentIDs_str = cellfun(@(x) strjoin(arrayfun(@num2str, x, 'UniformOutput', ...
    false), ','), treatmentIDs, 'UniformOutput', false);
treatment_data = cell(1, numel(treatmentIDs_str));

parfor i = 1:numel(treatment_data)

    % Create a new database connection for each worker
    conn = database(datasource, 'postgres', '1234');

    treatment_data{i} = fetchHealthDataTable(feature, treatmentIDs_str{i}, conn);
    treatment_data{i} = cleanBadSessionsFromTable(treatment_data{i}, feature); % Remove bad sessions
    treatment_data{i} = sortrows(treatment_data{i}, 'trialname');

    % Close the connection after use
    close(conn);
end

% Plot without splitting gender
if strcmpi(splitByGender, 'n')
    % Initialize variables for early and late sessions
    earlySessions = cell(1, numel(treatment_data));
    lateSessions = cell(1, numel(treatment_data));

    earlySessionsFeatureForEach = cell(1, numel(treatment_data));
    earlySessionsAvFeature = cell(1, numel(treatment_data));
    earlySessionsStdErr = cell(1, numel(treatment_data));

    lateSessionsFeatureForEach = cell(1, numel(treatment_data));
    lateSessionsAvFeature = cell(1, numel(treatment_data));
    lateSessionsStdErr = cell(1, numel(treatment_data));

    parfor i = 1:numel(treatment_data)
        numTrials = height(treatment_data{i});

        % Split into early and late sessions
        earlySessions{i} = treatment_data{i}(1:floor(sessionFraction*numTrials),:);
        startIndex = ceil((1 - sessionFraction) * numTrials) + 1;
        lateSessions{i} = treatment_data{i}(startIndex:end, :);

        % Compute psychometric function values
        [earlySessionsFeatureForEach{i}, earlySessionsAvFeature{i}, earlySessionsStdErr{i}] ...
            = psychometricFunValues(earlySessions{i}, feature);

        [lateSessionsFeatureForEach{i}, lateSessionsAvFeature{i}, lateSessionsStdErr{i}] ...
            = psychometricFunValues(lateSessions{i}, feature);
    end

    % Plot Psychometric function
    figure;
    x = 1:4;
    Colors = parula(2*numel(treatmentIDs));

    for i = 1:numel(treatment_data)
        % Plot early sessions
        plot(x, earlySessionsAvFeature{i}, '.-', 'LineWidth', 2, 'Color', Colors(i,:), ...
            'DisplayName',sprintf('%s_early_session_%.1f', treatmentGroups{i}, sessionFraction));
        hold on;
        errorbar(x, earlySessionsAvFeature{i},earlySessionsStdErr{i},'LineStyle', 'none', ...
            'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');

        % Plot late sessions
        plot(x, lateSessionsAvFeature{i}, '.-', 'LineWidth', 2, 'Color', Colors(i+1,:), ...
            'DisplayName',sprintf('%s_late_session_%.1f', treatmentGroups{i}, sessionFraction));
        errorbar(x, lateSessionsAvFeature{i},lateSessionsStdErr{i},'LineStyle', 'none', ...
            'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');
    end

    hold off;

    legend('show', 'Interpreter', 'none');

    varargout{1} = earlySessionsFeatureForEach;
    varargout{2} = lateSessionsFeatureForEach;

end