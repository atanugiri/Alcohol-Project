% Author: Atanu Giri
% Date: 01/10/2025
%
% 'feature' can be any column from ghrelin_featuretable.
% 'splitType' can be 'session' or 'trial', depending how the user wants to
% split the health group data.
% 'fraction' is the amount of data in early and late sessions.
% 'treatmentGroup' is health group the user wants to analyze.
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

function varargout = earlyVsLateDataPsychometricFunctionPlot(feature, ...
    splitType, fraction, treatmentGroup, animalList)

% feature = 'approachavoid';
% splitType = 'session';
% fraction = 0.5;
% treatmentGroup = 'P2A Boost and alcohol';

if nargin < 5
    animalList = {};
end

treatment_data = extractTreatmentData(feature, splitType, treatmentGroup);

% Filter treatment_data if animalList is provided
if ~isempty(animalList)
    treatment_data = treatment_data(ismember(treatment_data.subjectid, animalList), :);
end

% for i = 1:numel(treatment_data)
if strcmpi(splitType, 'trial')

    numTrials = height(treatment_data);

    % Split into early and late sessions
    earlyData = treatment_data(1:floor(fraction*numTrials),:);
    startIndex = ceil((1 - fraction) * numTrials) + 1;
    lateData = treatment_data(startIndex:end, :);

elseif strcmpi(splitType, 'session')
    % Extract and sort unique dates
    uniqueDates = unique(treatment_data.referencetime);
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
    earlyData = treatment_data(ismember(treatment_data.referencetime, earlyDates), :);
    lateData = treatment_data(ismember(treatment_data.referencetime, lateDates), :);
else
    error('Invalid splitType: "%s". Valid options are "trial" or "session".', splitType);
end

% Compute psychometric function values
earlyDataFeatureForEach = psychometricFunValuesPerSession(earlyData, feature);
earlyDataAvFeature = mean(earlyDataFeatureForEach);
earlyDataStdErr = std(earlyDataFeatureForEach) ./sqrt(size(earlyDataFeatureForEach, 1));

lateDataFeatureForEach = psychometricFunValuesPerSession(lateData, feature);
lateDataAvFeature = mean(lateDataFeatureForEach);
lateDataStdErr = std(lateDataFeatureForEach) ./sqrt(size(lateDataFeatureForEach, 1));
% end

% Plot Psychometric function
figure;
x = 1:4;
Colors = parula(2);

% Plot early sessions
errorbar(x, earlyDataAvFeature, earlyDataStdErr,'LineWidth', 2, 'Color', ...
    Colors(1,:), 'DisplayName',sprintf('%s_early_session_%.1f', treatmentGroup, fraction));
hold on;

% Plot late sessions
errorbar(x, lateDataAvFeature, lateDataStdErr,'LineWidth', 2, 'Color', ...
    Colors(2,:), 'DisplayName',sprintf('%s_late_session_%.1f', treatmentGroup, fraction));

hold off;

% Add label and legend
xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize', 25);
xticks(1:4);
label = {'0.5','2','5','9'};
set(gca,'xticklabel',label,'FontSize',15);
legend('show', 'Interpreter', 'none');

varargout{1} = earlyDataFeatureForEach;
varargout{2} = lateDataFeatureForEach;

end