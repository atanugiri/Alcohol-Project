% Author: Atanu Giri
% Date: 01/15/2025
%
% 'feature' can be any column from ghrelin_featuretable.
% 'treatmentGroup' is health group the user wants to analyze.
%
% Example usage:
% trialAndSessionProgressionPsychometricFun('approachavoid', 
% 'P2A Boost and alcohol')
%
% OR
%
% animalList = {'aladdin', 'jafar', 'jimi', 'jr', 'mike', 'scar', 'sully'};
% trialAndSessionProgressionPsychometricFun('approachavoid', 
% 'P2A Boost and alcohol', animalList)

function splitData = trialAndSessionProgressionPsychometricFun(feature, ...
    treatmentGroup, animalList)

if nargin < 3
    animalList = {};
end

[T1, T2, T3, T4] = trialProgressionPsychometricFun(feature, treatmentGroup, animalList);
trialData = {T1, T2, T3, T4};

% Intialize variable for splitData
splitData = cell(3, 4);

for j = 1:4
    tempData = trialData{j};

    % Determine the number of unique dates
    numUniqueDates = size(tempData, 1);

    % Calculate the approximate size of each section
    sectionSize = floor(numUniqueDates / 3);

    % Determine how many dates to allocate to each section
    numEarlyDates = sectionSize;
    numLateDates = sectionSize;

    % Add remaining dates to the middle section
    numMiddleDates = numUniqueDates - (numEarlyDates + numLateDates);

    % Partition the dates into 3 sections
    earlyDates = 1:numEarlyDates;
    middleDates = numEarlyDates + 1:numEarlyDates + numMiddleDates;
    lateDates = numEarlyDates + numMiddleDates + 1:numUniqueDates;

    % Filter rows for early, middle, and late sessions based on unique dates
    splitData{1,j} = tempData(earlyDates, :);
    splitData{2,j} = tempData(middleDates, :);
    splitData{3,j} = tempData(lateDates, :);
end

% Plot Psychometric function
x = 1:4;
Colors = parula(3);

for j = 1:size(splitData,2)
    figure;
    for k = 1:3
        tempData = splitData{k,j};
        avFeature = mean(tempData);
        stdErr = std(tempData)/sqrt(size(tempData,1));

        plot(x, avFeature, '.-', 'LineWidth', 2, 'Color', Colors(k,:), ...
            'DisplayName',sprintf('%s_session_%d_trial_%d', treatmentGroup, k, j));
        hold on;
        errorbar(x, avFeature, stdErr,'LineStyle', 'none', ...
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