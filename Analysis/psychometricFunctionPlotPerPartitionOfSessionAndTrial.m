% Author: Atanu Giri
% Date: 01/15/2025
%
% 'feature' can be any column from ghrelin_featuretable.
% 'splitType' can be 'session' or 'trial', depending how the user wants to
% split the health group data.
% 'varargin' is health group the user wants to analyze.
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

function varargout = psychometricFunctionPlotPerPartitionOfSessionAndTrial(feature, splitType, varargin)

% feature = 'approachavoid';
% splitType = 'trial';
% varargin = {'P2A Boost and alcohol'};
% animalList = {'aladdin', 'jafar', 'jimi', 'jr', 'mike', 'scar', 'sully'};

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

% Intialize variable for splitData
splitData = cell(1, numel(treatment_data));

for i = 1:numel(treatment_data)
    % Initialize variables
    splitData{i} = cell(3, 4);
end

for i = 1:numel(treatment_data)
    currentSplitData = splitData{i};
    for j = 1:4
        %% First, sort by trials
        % Compute the range for trialname based on j
        trialRange = ((j-1)*10 + 1):(j*10);

        % Filter treatment_data{i} based on trialname range
        tempData = treatment_data{i}(ismember(treatment_data{i}.trialname, trialRange), :);

        tempData.referencetime = datetime(tempData.referencetime, ...
            'InputFormat', 'MM/dd/yyyy');
        % Sort the table by referencetime
        tempData = sortrows(tempData, 'referencetime');

        %% Now sort by dates
        % Extract and sort unique dates
        uniqueDates = unique(tempData.referencetime);
        uniqueDates = sort(uniqueDates); % Ensure dates are sorted chronologically

        % Determine the number of unique dates
        numUniqueDates = numel(uniqueDates);

        % Calculate the approximate size of each section
        sectionSize = floor(numUniqueDates / 3);

        % Determine how many dates to allocate to each section
        numEarlyDates = sectionSize;
        numLateDates = sectionSize;

        % Add remaining dates to the middle section
        numMiddleDates = numUniqueDates - (numEarlyDates + numLateDates);

        % Partition the dates into 3 sections
        earlyDates = uniqueDates(1:numEarlyDates);
        middleDates = uniqueDates(numEarlyDates + 1:numEarlyDates + numMiddleDates);
        lateDates = uniqueDates(numEarlyDates + numMiddleDates + 1:end);

        % Filter rows for early, middle, and late sessions based on unique dates
        currentSplitData{1,j} = tempData(ismember(tempData.referencetime, earlyDates), :);
        currentSplitData{2,j} = tempData(ismember(tempData.referencetime, middleDates), :);
        currentSplitData{3,j} = tempData(ismember(tempData.referencetime, lateDates), :);
    end

    splitData{i} = currentSplitData;
end

% Plot Psychometric function
x = 1:4;
Colors = parula(3*numel(treatment_data));

for i = 1:numel(treatment_data)
    currentSplitData = splitData{i};
    for j = 1:size(currentSplitData,2)
        figure;
        for k = 1:3
            % Compute psychometric function values
            [featureForEach, avFeature, stdErr] ...
                = psychometricFunValues(currentSplitData{k,j}, feature);
            plot(x, avFeature, '.-', 'LineWidth', 2, 'Color', Colors(i-1+k,:), ...
                'DisplayName',sprintf('%s_session_%d_trial_%d', varargin{i}, k, j));
            hold on;
            errorbar(x, avFeature,stdErr,'LineStyle', 'none', ...
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
    end
end