% Author: Atanu Giri
% Date: 01/11/2025
%
function varargout = earlyVsLateDataPsychometricFunctionPlotSplitBySex(feature, splitType, fraction, varargin)
%
% feature = 'approachavoid';
% varargin = {'P2A Boost and alcohol'};
% trailFraction = 0.5;

treatment_data = extractTreatmentData(feature, splitType, varargin);

featureForEachMale = cell(numel(treatment_data),2);
avFeatureMale = cell(numel(treatment_data),2);
stdErrMale = cell(numel(treatment_data),2);

featureForEachFemale = cell(numel(treatment_data),2);
avFeatureFemale = cell(numel(treatment_data),2);
stdErrFemale = cell(numel(treatment_data),2);

% Plot Psychometric function
x = 1:4;
Colors = parula(2*numel(treatment_data));

for grp = 1:numel(treatment_data)
    % Male Data
    maleData = treatment_data{grp}(strcmpi(treatment_data{grp}.gender,"male"),:);
    [earlyDataMale, lateDataMale] = extractEarlyAndLateSexData(maleData);

    % Compute psychometric function values
    [featureForEachMale{grp,1}, avFeatureMale{grp,1}, stdErrMale{grp,1}] ...
        = psychometricFunValues(earlyDataMale, feature);

    [featureForEachMale{grp,2}, avFeatureMale{grp,2}, stdErrMale{grp,2}] ...
        = psychometricFunValues(lateDataMale, feature);

    % Plot early sessions
    figure;
    plot(x, avFeatureMale{grp,1}, '.-', 'LineWidth', 2, 'Color', Colors(grp,:), ...
        'DisplayName',sprintf('%s_early_session_%.1f', varargin{grp}, fraction));
    hold on;
    errorbar(x, avFeatureMale{grp,1},stdErrMale{grp,1},'LineStyle', 'none', ...
        'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');

    % Plot late sessions
    plot(x, avFeatureMale{grp,2}, '.-', 'LineWidth', 2, 'Color', Colors(grp+1,:), ...
        'DisplayName',sprintf('%s_late_session_%.1f', varargin{grp}, fraction));
    errorbar(x, avFeatureMale{grp,2},stdErrMale{grp,2},'LineStyle', 'none', ...
        'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');

    hold off;
    legend('show', 'Interpreter', 'none');
    title("Male", 'Interpreter','latex','FontSize',25);

    % Female plot
    femaleData = treatment_data{grp}(strcmpi(treatment_data{grp}.gender,"female"),:);

    [earlyDataFemale, lateDataFemale] = extractEarlyAndLateSexData(femaleData);

    % Compute psychometric function values
    [featureForEachFemale{grp,1}, avFeatureFemale{grp,1}, stdErrFemale{grp,1}] ...
        = psychometricFunValues(earlyDataFemale, feature);

    [featureForEachFemale{grp,2}, avFeatureFemale{grp,2}, stdErrFemale{grp,2}] ...
        = psychometricFunValues(lateDataFemale, feature);

    figure;
    % Plot early sessions
    plot(x, avFeatureFemale{grp,1}, '.-', 'LineWidth', 2, 'Color', Colors(grp,:), ...
        'DisplayName',sprintf('%s_early_session_%.1f', varargin{grp}, fraction));
    hold on;
    errorbar(x, avFeatureFemale{grp,1},stdErrMale{grp,1},'LineStyle', 'none', ...
        'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');

    % Plot late sessions
    plot(x, avFeatureFemale{grp,2}, '.-', 'LineWidth', 2, 'Color', Colors(grp+1,:), ...
        'DisplayName',sprintf('%s_late_session_%.1f', varargin{grp}, fraction));
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


%% Description of extractEarlyAndLateSexData
    function [earlyData, lateData] = extractEarlyAndLateSexData(datatable)
        if strcmpi(splitType, 'trial')

            numTrials = height(datatable);

            % Split into early and late sessions
            earlyData = datatable(1:floor(fraction*numTrials),:);
            startIndex = ceil((1 - fraction) * numTrials) + 1;
            lateData = datatable(startIndex:end, :);

        elseif strcmpi(splitType, 'session')
            % Extract and sort unique dates
            uniqueDates = unique(datatable.referencetime);
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
            earlyData = datatable(ismember(datatable.referencetime, earlyDates), :);
            lateData = datatable(ismember(datatable.referencetime, lateDates), :);
        else
            error('Invalid splitType: "%s". Valid options are "trial" or "session".', splitType);
        end
    end

end