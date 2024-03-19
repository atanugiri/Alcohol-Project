% Author: Atanu Giri
% Date: 03/17/2024

% This function makes bar plot of a feature at a user specified
% concentration

%% Invokes masterPsychometricFunctionPlot

function barPlotOfFeatureAtSpecificConcentration(feature, splitByGender, concIdx, varargin)

% feature = 'approachavoid';
% splitByGender = 'y';
% varargin = {'P2L1L3 Saline', 'P2L1L3 Ghrelin'};
% concIdx = 4; % User defined


% Plotting
hold on;
Colors = parula(numel(varargin));

%% Plot without splitting gender
if strcmpi(splitByGender, 'n')
    featureForEach = masterPsychometricFunctionPlot(feature, splitByGender, varargin{:});
    close(gcf);
    figure;
    hold on;

    avFeature = cellfun(@mean, featureForEach, 'UniformOutput', false);
    stdErr = cellfun(@(x) std(x)/sqrt(length(x)), featureForEach, 'UniformOutput', false);

    for grp = 1:numel(varargin)
        hBar(grp) = bar(grp, avFeature{grp}(concIdx), 'FaceColor', Colors(grp,:));
        errorbar(grp, avFeature{grp}(concIdx),stdErr{grp}(concIdx),'LineStyle', 'none', ...
            'LineWidth', 1.5, 'Color','k');
    end
    hold off;

    legend(hBar, varargin, 'Location', 'best');
    ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize', 25);

        % Statistics
    if numel(varargin) >= 2
        p_value = zeros(1, numel(varargin) - 1);
        for grp = 2:numel(varargin)
            [~, p_value(grp-1)] = ttest2(featureForEach{1}(:,concIdx), ...
                featureForEach{grp}(:,concIdx));
            text(grp, max(ylim), sprintf("p = %.4f", p_value(grp-1)));
        end
    end

    %% Plot with splitting gender
elseif strcmpi(splitByGender, 'y')
    [featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
        feature, splitByGender, varargin{:});
    close(gcf);
    figure;
    hold on;

    avFeatureMale = cellfun(@mean, featureForEachMale, 'UniformOutput', false);
    stdErrMale = cellfun(@(x) std(x)/sqrt(length(x)), featureForEachMale, 'UniformOutput', false);

    avFeatureFemale = cellfun(@mean, featureForEachFemale, 'UniformOutput', false);
    stdErrFemale = cellfun(@(x) std(x)/sqrt(length(x)), featureForEachFemale, 'UniformOutput', false);

    for grp = 1:numel(varargin)
        subplot(1,2,1);
        hold on;
        hBarMale(grp) = bar(grp, avFeatureMale{grp}(concIdx), 'FaceColor', Colors(grp,:));
        errorbar(grp, avFeatureMale{grp}(concIdx),stdErrMale{grp}(concIdx),'LineStyle', 'none', ...
            'LineWidth', 1.5, 'Color','k');
        title("Male", 'Interpreter','latex', 'FontSize', 25);
        ylabel(sprintf('%s', feature), 'Interpreter','none');

        subplot(1,2,2);
        hold on;
        hBarFemale(grp) = bar(grp, avFeatureFemale{grp}(concIdx), 'FaceColor', Colors(grp,:));
        errorbar(grp, avFeatureFemale{grp}(concIdx),stdErrFemale{grp}(concIdx),'LineStyle', 'none', ...
            'LineWidth', 1.5, 'Color','k');
        title("Female", 'Interpreter','latex', 'FontSize', 25);
    end

    legend(hBarFemale, varargin, 'Location', 'best');

    % Link axes to ensure the same scale
    linkaxes([subplot(1,2,1), subplot(1,2,2)], 'y');

     % Statistics
    if numel(varargin) >= 2
        p_value_male = zeros(1, numel(varargin) - 1);
        for grp = 2:numel(varargin)
            [~, p_value_male(grp-1)] = ttest2(featureForEachMale{1}(:,concIdx), ...
                featureForEachMale{grp}(:,concIdx));
            subplot(1,2,1);
            text(grp, max(ylim), sprintf("p = %.4f", p_value_male(grp-1)));
        end

        p_value_female = zeros(1, numel(varargin) - 1);
        for grp = 2:numel(varargin)
            [~, p_value_female(grp-1)] = ttest2(featureForEachFemale{1}(:,concIdx), ...
                featureForEachFemale{grp}(:,concIdx));
            subplot(1,2,2);
            text(grp, max(ylim), sprintf("p = %.4f", p_value_female(grp-1)));
        end
    end
end

hold off;

% Save figure
if strcmpi(splitByGender, 'n')
    figname = sprintf('%s_%s_at_conc_%d',[varargin{:}],string(feature), concIdx);
else
    figname = sprintf('%s_%s_MvF_at_conc_%d',[varargin{:}],string(feature), concIdx);
end

% Figure name
scriptDir = fileparts(mfilename('fullpath'));
folderName = 'Fig files';
myPath = fullfile(scriptDir, folderName);
% Check if the folder exists, if not, create it
if ~exist(myPath, 'dir')
    mkdir(myPath);
end

savefig(gcf, fullfile(myPath, figname));

end