% Author: Atanu Giri
% Date: 07/08/2024
% This function plots variance of the input treatment group.
% Invokes masterPsychometricFunctionPlot. If varargin is provided then the
% function will generate plot.

function varianceAnalysis(feature, splitByGender, varargin)

% feature = 'approachavoid';
% splitByGender = 'y';
% varargin = {'P2L1 BL for comb boost and alc', 'P2A Boost and alcohol'};

% Check input
if nargin < 3
    error('Insufficient input arguments. Provide feature, splitByGender, and trtmntGrp.');
end

% Connect to database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

treatmentGroups = varargin;

treatmentIDs = cell(1, numel(treatmentGroups));
for i = 1:numel(treatmentGroups)
    treatmentIDs{i} = treatmentIDfun(treatmentGroups{i}, conn);
end

% Generate the idList from the filtered data
treatmentIDs_str = cellfun(@(x) strjoin(arrayfun(@num2str, x, 'UniformOutput', ...
    false), ','), treatmentIDs, 'UniformOutput', false);
treatment_data = cell(1, numel(treatmentIDs_str));

for i = 1:numel(treatmentIDs_str)
    treatment_data{i} = fetchHealthDataTable(feature, treatmentIDs_str{i}, conn);
    treatment_data{i} = cleanBadSessionsFromTable(treatment_data{i}, feature); % Remove bad sessions
end

%% Plotting
x = 1:4;
figure;
hold on;
Colors = lines(numel(treatment_data));

% Desired spacing
d = 0.4;

% Initialize a matrix to hold the positions
positions = zeros(numel(treatment_data), length(x));

% Loop through each treatment group
for t = 1:numel(treatment_data)
    % Calculate positions for each concentration for this treatment group
    positions(t, :) = x + ((2*t - (numel(treatment_data) + 1)) ...
        / (numel(treatment_data) + 1)) * d;
end

label = {'0.5','2','5','9'};

if strcmpi(splitByGender, 'n')
    featureForEach = cell(1, numel(treatment_data));
    var_y = cell(1, numel(treatment_data));
    lowerCI = cell(1, numel(treatment_data));
    upperCI = cell(1, numel(treatment_data));

    for grp = 1:numel(treatment_data)
        featureForEach{grp} = psychometricFunValues(treatment_data{grp}, feature);
        [var_y{grp}, lowerCI{grp}, upperCI{grp}] = varianceCalculation(featureForEach{grp});
    end

    for grp = 1:numel(treatment_data)
        % Create bar plot for each concentration
        h(grp) = bar(positions(grp,:), var_y{grp}, 'FaceColor', Colors(grp,:), ...
            'BarWidth', 0.2);
        hold on;
        errorbar(positions(grp, :), var_y{grp}, lowerCI{grp}, upperCI{grp}, 'k.', 'LineWidth', 1.5);

    end

    % Add labels and legends
    xlabel('Sucrose conc.');
    ylabel('Variance');

    xticks(x);
    set(gca,'xticklabel',label,'FontSize',15);
    legend_labels = treatmentGroups;
    legend(h, legend_labels, 'Location', 'best');

elseif strcmpi(splitByGender, 'y')
    featureForEachMale = cell(1, numel(treatment_data));
    featureForEachFemale = cell(1, numel(treatment_data));

    male_var_y = cell(1, numel(treatment_data));
    male_lowerCI = cell(1, numel(treatment_data));
    male_upperCI = cell(1, numel(treatment_data));

    female_var_y = cell(1, numel(treatment_data));
    female_lowerCI = cell(1, numel(treatment_data));
    female_upperCI = cell(1, numel(treatment_data));

    for grp = 1:numel(treatment_data)
        maleData = treatment_data{grp}(strcmpi(treatment_data{grp}.gender,"male"),:);
        featureForEachMale{grp} = psychometricFunValues(maleData, feature);
        [male_var_y{grp}, male_lowerCI{grp}, male_upperCI{grp}] = ...
            varianceCalculation(featureForEachMale{grp});

        femaleData = treatment_data{grp}(strcmpi(treatment_data{grp}.gender,"female"),:);
        featureForEachFemale{grp} = psychometricFunValues(femaleData, feature);
        [female_var_y{grp}, female_lowerCI{grp}, female_upperCI{grp}] = ...
            varianceCalculation(featureForEachMale{grp});

    end

    for grp = 1:numel(treatment_data)
        subplot(1,2,1);
        % Create bar plot for each concentration
        bar(positions(grp,:), male_var_y{grp}, 'FaceColor', Colors(grp,:), ...
            'BarWidth', 0.2);
        hold on;
        errorbar(positions(grp, :), male_var_y{grp}, male_lowerCI{grp}, ...
            male_upperCI{grp}, 'k.', 'LineWidth', 1.5);

        if grp == 1
            title("Male", 'Interpreter','latex', 'FontSize', 25);
            ylabel('Variance');
            xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
            xticks(x);
            set(gca,'xticklabel',label,'FontSize',15);
        end

        subplot(1,2,2);
        % Create bar plot for each concentration
        h(i) = bar(positions(grp,:), female_var_y{grp}, 'FaceColor', Colors(grp,:), ...
            'BarWidth', 0.2);
        hold on;
        errorbar(positions(grp, :), female_var_y{grp}, female_lowerCI{grp}, ...
            female_upperCI{grp}, 'k.', 'LineWidth', 1.5);

        if grp == 1
            title("Female", 'Interpreter','latex', 'FontSize', 25);
            xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
            xticks(x);
            set(gca,'xticklabel',label,'FontSize',15);
        end

    end

    % Add legends
    legend_labels = treatmentGroups;
    legend(h, legend_labels, 'Location', 'best');

    % Link axes to ensure the same scale
    linkaxes([subplot(1,2,1), subplot(1,2,2)], 'y');

else
    error('Invalid input for splitByGender. Use ''y'' or ''n''.');
end

hold off;

% Figure name
if strcmpi(splitByGender, 'n')
    figname = sprintf('Variance_%s_%s',trtmntGrp,feature);
elseif strcmpi(splitByGender, 'y')
    figname = sprintf('Variance_MvF_%s_%s',trtmntGrp,feature);
end

% Save figure
scriptDir = fileparts(mfilename('fullpath'));
folderName = 'Fig files';
myPath = fullfile(scriptDir, folderName);
% Check if the folder exists, if not, create it
if ~exist(myPath, 'dir')
    mkdir(myPath);
end

savefig(gcf, fullfile(myPath, figname));



%% Description of varianceCalculation
function [var_y, lowerCI, upperCI] = varianceCalculation(data)
% Calculate variance
var_y = var(data);
% Number of observations in each column
n = size(data, 1);
dF = n - 1;  % degrees of freedom for each column

% Calculate chi-squared values for the desired confidence level (e.g., 95%)
A = chi2inv(0.975, dF);
B = chi2inv(0.025, dF);

lowerCI = (dF * var_y) / A;
upperCI = (dF * var_y) / B;
end

end