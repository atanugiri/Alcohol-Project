% Author: Atanu Giri
% Date: 01/11/2025
%
function varargout = earlyVsLatePsychometricFunctionPlotSplitBySex(feature, splitByGender, sessionFraction, varargin)
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

featureForEachMale = cell(numel(treatmentIDs),2);
avFeatureMale = cell(numel(treatmentIDs),2);
stdErrMale = cell(numel(treatmentIDs),2);

featureForEachFemale = cell(numel(treatmentIDs),2);
avFeatureFemale = cell(numel(treatmentIDs),2);
stdErrFemale = cell(numel(treatmentIDs),2);

for grp = 1:numel(treatmentIDs)
    % Male Data
    maleData = treatment_data{grp}(strcmpi(treatment_data{grp}.gender,"male"),:);

    numTrialsMale = height(maleData);

    % Split into early and late sessions
    earlySessionsMale = maleData(1:floor(sessionFraction*numTrialsMale),:);
    startIndex = ceil((1 - sessionFraction) * numTrialsMale) + 1;
    lateSessionsMale = maleData(startIndex:end, :);

    % Compute psychometric function values
    [featureForEachMale{grp,1}, avFeatureMale{grp,1}, stdErrMale{grp,1}] ...
        = psychometricFunValues(earlySessionsMale, feature);

    [featureForEachMale{grp,2}, avFeatureMale{grp,2}, stdErrMale{grp,2}] ...
        = psychometricFunValues(lateSessionsMale, feature);

    % Plot early sessions
    figure;
    plot(x, avFeatureMale{grp,1}, '.-', 'LineWidth', 2, 'Color', Colors(grp,:), ...
        'DisplayName',sprintf('%s_early_session_%.1f', treatmentGroups{grp}, sessionFraction));
    hold on;
    errorbar(x, avFeatureMale{grp,1},stdErrMale{grp,1},'LineStyle', 'none', ...
        'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');

    % Plot late sessions
    plot(x, avFeatureMale{grp,2}, '.-', 'LineWidth', 2, 'Color', Colors(grp+1,:), ...
        'DisplayName',sprintf('%s_late_session_%.1f', treatmentGroups{grp}, sessionFraction));
    errorbar(x, avFeatureMale{grp,2},stdErrMale{grp,2},'LineStyle', 'none', ...
        'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');

    hold off;
    legend('show', 'Interpreter', 'none');
    title("Male", 'Interpreter','latex','FontSize',25);

    % Female plot
    femaleData = treatment_data{grp}(strcmpi(treatment_data{grp}.gender,"female"),:);

    numTrialsFemale = height(femaleData);

    % Split into early and late sessions
    earlySessionsFemale = femaleData(1:floor(sessionFraction*numTrialsFemale),:);
    startIndex = ceil((1 - sessionFraction) * numTrialsFemale) + 1;
    lateSessionsFemale = femaleData(startIndex:end, :);

    % Compute psychometric function values
    [featureForEachFemale{grp,1}, avFeatureFemale{grp,1}, stdErrFemale{grp,1}] ...
        = psychometricFunValues(earlySessionsFemale, feature);

    [featureForEachFemale{grp,2}, avFeatureFemale{grp,2}, stdErrFemale{grp,2}] ...
        = psychometricFunValues(lateSessionsFemale, feature);

    figure;
    % Plot early sessions
    plot(x, avFeatureFemale{grp,1}, '.-', 'LineWidth', 2, 'Color', Colors(grp,:), ...
        'DisplayName',sprintf('%s_early_session_%.1f', treatmentGroups{grp}, sessionFraction));
    hold on;
    errorbar(x, avFeatureFemale{grp,1},stdErrMale{grp,1},'LineStyle', 'none', ...
        'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');

    % Plot late sessions
    plot(x, avFeatureFemale{grp,2}, '.-', 'LineWidth', 2, 'Color', Colors(grp+1,:), ...
        'DisplayName',sprintf('%s_late_session_%.1f', treatmentGroups{grp}, sessionFraction));
    errorbar(x, avFeatureFemale{grp,2},stdErrMale{grp,2},'LineStyle', 'none', ...
        'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');

    hold off;
    legend('show', 'Interpreter', 'none');
    title("Female", 'Interpreter','latex','FontSize',25);

end

earlySessionsFeatureForEachMale = featureForEachMale{:,1};
lateSessionsFeatureForEachMale = featureForEachMale{:,2};
earlySessionsFeatureForEachFemale = featureForEachFemale{:,1};
lateSessionsFeatureForEachFemale = featureForEachFemale{:,2};

varargout{1} = earlySessionsFeatureForEachMale;
varargout{2} = lateSessionsFeatureForEachMale;
varargout{3} = earlySessionsFeatureForEachFemale;
varargout{4} = lateSessionsFeatureForEachFemale;

end