% Author: Atanu Giri
% Date: 12/04/2023
%
% This function takes 'feature', splitByGender and treatment group/s as 
% input from and returns psychometric plot for that feature as an average 
% of all animals
%
% Example usage
% masterPsychometricFunctionPlot('distance_until_limiting_time_stamp','y','P2L1 Saline','P2L1 Ghrelin')

%% Invokes treatmentIDfun, fetchHealthDataTable, psychometricFunValues.

function varargout = masterPsychometricFunctionPlot(feature, splitByGender, varargin)

% feature = 'distance_until_limiting_time_stamp';
% splitByGender = 'y';
% varargin = {'P2L1 Boost','P2L1 Ghrelin','P2L1 Alcohol','P2L1 Ghr alcohol'};

close all;

% Connect to database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

if numel(varargin) >= 1
    treatmentGroups = cell(1, numel(varargin));
    for i = 1:numel(varargin)
        treatmentGroups{i} = varargin{i};
    end
else
    treatmentGroups = input("Which health type do you want for treatment? ","s");
end

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
end

% Plotting
x = 1:4;
figure;
hold on;
Colors = parula(numel(treatmentIDs));

%% Plot without splitting gender
if strcmpi(splitByGender, 'n')
    featureForEach = cell(1, numel(treatmentIDs));
    avFeature = cell(1, numel(treatmentIDs));
    stdErr = cell(1, numel(treatmentIDs));
    hLines = zeros(1, numel(treatmentIDs));

    for grp = 1:numel(treatmentIDs)
        [featureForEach{grp}, avFeature{grp}, stdErr{grp}] = ...
            psychometricFunValues(treatment_data{grp}, feature);
        hLines(grp) = plot(x, avFeature{grp}, 'LineWidth', 2, 'Color', Colors(grp,:));

        errorbar(x, avFeature{grp},stdErr{grp},'LineStyle', 'none', ...
            'LineWidth', 1.5, 'Color','k');
    end

    legend_labels = treatmentGroups;
    legend(hLines, legend_labels, 'Location', 'best');
    ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize', 25);
    xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);

    xticks(1:4);
    label = {'0.5','2','5','9'};
    set(gca,'xticklabel',label,'FontSize',15);

    % Output for statistics
    varargout{1} = featureForEach;

    %% Plot with splitting gender
elseif strcmpi(splitByGender, 'y')
    featureForEachMale = cell(1, numel(treatmentIDs));
    avFeatureMale = cell(1, numel(treatmentIDs));
    stdErrMale = cell(1, numel(treatmentIDs));
    hLinesMale = zeros(1, numel(treatmentIDs));

    featureForEachFemale = cell(1, numel(treatmentIDs));
    avFeatureFemale = cell(1, numel(treatmentIDs));
    stdErrFemale = cell(1, numel(treatmentIDs));
    hLinesFemale = zeros(1, numel(treatmentIDs));

    subplot(1,2,1); % For male data
    hold on;
    subplot(1,2,2); % For female data
    hold on;

    for grp = 1:numel(treatmentIDs)
        maleData = treatment_data{grp}(strcmpi(treatment_data{grp}.gender,"male"),:);
        [featureForEachMale{grp}, avFeatureMale{grp}, stdErrMale{grp}] = ...
            psychometricFunValues(maleData, feature);
        subplot(1,2,1);
        hLinesMale(grp) = plot(x, avFeatureMale{grp}, 'LineWidth', 2, 'Color', Colors(grp,:));
        errorbar(x, avFeatureMale{grp},stdErrMale{grp},'LineStyle', 'none', ...
            'LineWidth', 1.5, 'Color','k');
        title("Male", 'Interpreter','latex', 'FontSize', 25);
        ylabel(sprintf('%s', feature), 'Interpreter','none');
        xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);

        femaleData = treatment_data{grp}(strcmpi(treatment_data{grp}.gender,"female"),:);
        [featureForEachFemale{grp}, avFeatureFemale{grp}, stdErrFemale{grp}] = ...
            psychometricFunValues(femaleData, feature);
        subplot(1,2,2);
        hLinesFemale(grp) = plot(x, avFeatureFemale{grp}, 'LineWidth', 2, 'Color', Colors(grp,:));
        errorbar(x, avFeatureFemale{grp},stdErrFemale{grp},'LineStyle', 'none', ...
            'LineWidth', 1.5, 'Color','k');
        title("Female", 'Interpreter','latex','FontSize',25);
        xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);

    end

    for i = 1:2
        subplot(1,2,i);
        xticks(1:4);
        label = {'0.5','2','5','9'};
        set(gca,'xticklabel',label,'FontSize',15);
    end

    % Add legends
    legend_labels = treatmentGroups;
    legend(hLinesFemale, legend_labels, 'Location', 'best');

    % Link axes to ensure the same scale
    linkaxes([subplot(1,2,1), subplot(1,2,2)], 'y');

    % Output for statistics
    varargout{1} = featureForEachMale;
    varargout{2} = featureForEachFemale;

end

hold off;

% Figure name
if strcmpi(splitByGender, 'n')
    figname = sprintf('%s_%s_psychometric',[legend_labels{:}],string(feature));
else
    figname = sprintf('%s_%s_MvF_psychometric',[legend_labels{:}],string(feature));
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

end
