% Author: Atanu Giri
% Date: 01/14/2025
%
% 'feature' can be any column from ghrelin_featuretable.
% 'splitType' can be 'session' or 'trial', depending how the user wants to
% split the health group data.
% 'varargin' is health group the user wants to analyze.
%
% Example usage:
% 
function varargout = psychometricFunctionPlotPerPartition(feature, splitType, varargin)

% feature = 'approachavoid';
% splitType = 'trial';
% varargin = {'P2A Boost and alcohol'};

% Initialize animalList
animalList = [];

% Check if the last input argument is the animalList
if ~isempty(varargin) && iscell(varargin{end}) && all(cellfun(@ischar, varargin{end}))
    animalList = varargin{end}; % Extract animalList
    varargin(end) = [];         % Remove animalList from varargin
end

treatmentGroups = varargin;
treatment_data = extractTreatmentData(feature, splitType, treatmentGroups);

% Filter treatment_data if animalList is provided
if ~isempty(animalList)
    for i = 1:numel(treatment_data)
        treatment_data{i} = treatment_data{i}(ismember(treatment_data{i}.subjectid, animalList), :);
    end
end

% Initialize variables for early and late sessions
splitData = cell(1, numel(treatment_data));


splitDataFeatureForEach = cell(1, numel(treatment_data));
splitDataAvFeature = cell(1, numel(treatment_data));
splitDataStdErr = cell(1, numel(treatment_data));

if strcmpi(splitType, 'trial')
    for i = 1:numel(treatment_data)

        for j = 1:4
            % Compute the range for trialname based on j
            trialRange = ((j-1)*10 + 1):(j*10);

            % Filter treatment_data{i} based on trialname range
            splitData{i, j} = treatment_data{i}(ismember(treatment_data{i}.trialname, trialRange), :);

            % Compute psychometric function values
            [splitDataFeatureForEach{i,j}, splitDataAvFeature{i,j}, splitDataStdErr{i,j}] ...
                = psychometricFunValues(splitData{i,j}, feature);
        end
    end

elseif strcmpi(splitType, 'session')
    for i = 1:numel(treatment_data)

        % Extract and sort unique dates
        uniqueDates = unique(treatment_data{i}.referencetime);
        uniqueDates = sort(uniqueDates); % Ensure dates are sorted chronologically

        % Determine the number of early and late dates
        numUniqueDates = numel(uniqueDates);

        for date = 1:numUniqueDates
            % Filter rows for early and late sessions based on unique dates
            splitData{i,date} = treatment_data{i}(ismember(treatment_data{i}.referencetime, ...
                uniqueDates(date)), :);
            % Compute psychometric function values
            [splitDataFeatureForEach{i,date}, splitDataAvFeature{i,date}, splitDataStdErr{i,date}] ...
                = psychometricFunValues(splitData{i,date}, feature);
        end
    end

else
    error('Invalid splitType: "%s". Valid options are "trial" or "session".', splitType);
end

% Plot Psychometric function
figure;
x = 1:4;
Colors = parula(size(splitDataAvFeature,1)*size(splitDataAvFeature,2));

for i = 1:numel(treatment_data)
    for j = 1:size(splitData,2)
        if isempty(splitData{i, j})
            continue;
        end
        % Plot early sessions
        plot(x, splitDataAvFeature{i,j}, '.-', 'LineWidth', 2, 'Color', Colors(i-1+j, :), ...
            'DisplayName',sprintf('%s_%d', varargin{i}, j));
        hold on;
        errorbar(x, splitDataAvFeature{i,j},splitDataStdErr{i,j},'LineStyle', 'none', ...
            'LineWidth', 1.5, 'Color','k', 'HandleVisibility', 'off');
    end
end

hold off;

legend('show', 'Interpreter', 'none');

varargout = splitDataFeatureForEach;
end