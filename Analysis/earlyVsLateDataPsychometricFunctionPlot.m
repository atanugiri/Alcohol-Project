% Author: Atanu Giri
% Date: 01/10/2025
%
% 'feature' can be any column from ghrelin_featuretable.
% 'splitType' can be 'session' or 'trial', depending how the user wants to
% split the health group data.
% 'fraction' is the amount of data in early and late sessions.
% 'varargin' is health group the user wants to analyze.
%
function varargout = earlyVsLateDataPsychometricFunctionPlot(feature, splitType, fraction, varargin)

% feature = 'approachavoid';
% splitType = 'session';
% fraction = 0.5;
% varargin = {'P2A Boost and alcohol'};

treatment_data = extractTreatmentData(feature, splitType, varargin);

% Initialize variables for early and late sessions
earlyData = cell(1, numel(treatment_data));
lateData = cell(1, numel(treatment_data));

earlyDataFeatureForEach = cell(1, numel(treatment_data));
earlyDataAvFeature = cell(1, numel(treatment_data));
earlyDataStdErr = cell(1, numel(treatment_data));

lateDataFeatureForEach = cell(1, numel(treatment_data));
lateDataAvFeature = cell(1, numel(treatment_data));
lateDataStdErr = cell(1, numel(treatment_data));

for i = 1:numel(treatment_data)
    if strcmpi(splitType, 'trial')

        numTrials = height(treatment_data{i});

        % Split into early and late sessions
        earlyData{i} = treatment_data{i}(1:floor(fraction*numTrials),:);
        startIndex = ceil((1 - fraction) * numTrials) + 1;
        lateData{i} = treatment_data{i}(startIndex:end, :);

    elseif strcmpi(splitType, 'session')
        % Extract and sort unique dates
        uniqueDates = unique(treatment_data{i}.referencetime);
        uniqueDates = sort(uniqueDates); % Ensure dates are sorted chronologically

        % Determine the number of early and late dates
        numUniqueDates = numel(uniqueDates);
        numEarlyDates = floor(fraction * numUniqueDates);
        numLateDates = floor(fraction * numUniqueDates);

        % Handle middle date if the total is odd
        if mod(numUniqueDates, 2) == 1
            middleDateIndex = ceil(numUniqueDates / 2);
            earlyDates = uniqueDates(1:numEarlyDates);
            lateDates = uniqueDates(end-numLateDates+1:end);
        else
            earlyDates = uniqueDates(1:numEarlyDates);
            lateDates = uniqueDates(end-numLateDates+1:end);
        end

        % Filter rows for early and late sessions based on unique dates
        earlyData{i} = treatment_data{i}(ismember(treatment_data{i}.referencetime, earlyDates), :);
        lateData{i} = treatment_data{i}(ismember(treatment_data{i}.referencetime, lateDates), :);
    else
        error('Invalid splitType: "%s". Valid options are "trial" or "session".', splitType);
    end

    % Compute psychometric function values
    [earlyDataFeatureForEach{i}, earlyDataAvFeature{i}, earlyDataStdErr{i}] ...
        = psychometricFunValues(earlyData{i}, feature);

    [lateDataFeatureForEach{i}, lateDataAvFeature{i}, lateDataStdErr{i}] ...
        = psychometricFunValues(lateData{i}, feature);
end

% Plot Psychometric function
figure;
x = 1:4;
Colors = parula(2*numel(treatment_data));

for i = 1:numel(treatment_data)
    % Plot early sessions
    plot(x, earlyDataAvFeature{i}, '.-', 'LineWidth', 2, 'Color', Colors(i,:), ...
        'DisplayName',sprintf('%s_early_session_%.1f', varargin{i}, fraction));
    hold on;
    errorbar(x, earlyDataAvFeature{i},earlyDataStdErr{i},'LineStyle', 'none', ...
        'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');

    % Plot late sessions
    plot(x, lateDataAvFeature{i}, '.-', 'LineWidth', 2, 'Color', Colors(i+1,:), ...
        'DisplayName',sprintf('%s_late_session_%.1f', varargin{i}, fraction));
    errorbar(x, lateDataAvFeature{i},lateDataStdErr{i},'LineStyle', 'none', ...
        'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');
end

hold off;

legend('show', 'Interpreter', 'none');

varargout{1} = earlyDataFeatureForEach;
varargout{2} = lateDataFeatureForEach;

end