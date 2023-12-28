% Author: Atanu Giri
% Date: 12/22/2023

function overlayBarPlots(varargin)
%
% This plot combines the input bar plots.
%

varargin = {'Sal toyrat_acc_outlier_move_median.fig', 'Ghr toyrat_acc_outlier_move_median.fig', ...
    'Sal toystick_acc_outlier_move_median.fig', 'Ghr toystick_acc_outlier_move_median.fig'};
% Check the number of input figures
numFigures = numel(varargin);

if numFigures < 2
    error('At least two figures are required for combining bars.');
end

% Create a new figure with two subplots
figFinal = figure();
ax_combined = gca;
hold(ax_combined, 'on');
set(gcf, 'Windowstyle', 'docked');

% Create empty arrays to store values
barVal = zeros(1,numFigures);
barYNegativeDelta = zeros(1,numFigures);
barYPositiveDelta = zeros(1,numFigures);

% Initialize cell array to store legends
legendEntries = {};

% Define colors for bars
barColors = parula(numFigures);

% Loop through each input figure
for i = 1:numFigures
    % Load the figure
    fig = openfig(varargin{i});
    figAx = gca(fig);

    figAxChildren = get(figAx, 'Children');

    for j = 1:numel(figAxChildren)
        if strcmp(figAxChildren(j).Type, 'bar')
            barVal(i) = figAxChildren(j).YData(1);

            % Extract legend only for bars
            legendEntries = [legendEntries, figAxChildren(j).DisplayName];
        end
        % Plot bars with different colors
        bar(ax_combined, i, barVal(i), 'FaceColor', barColors(i, :));

        if strcmp(figAxChildren(j).Type, 'errorbar')
            barYNegativeDelta(i) = figAxChildren(j).YNegativeDelta(1);
            barYPositiveDelta(i) = figAxChildren(j).YPositiveDelta(1);
            legendEntries = [legendEntries, figAxChildren(j).DisplayName];
        end
    end

    legendEntries = [legendEntries, get(figAx, 'Legend').String];

    % Close the individual figure
    close(fig);
end

errorbar(ax_combined, 1:length(barVal), barVal, barYNegativeDelta, ...
    barYPositiveDelta, 'k', 'LineWidth',1.5, 'LineStyle','none');
legend(ax_combined, legendEntries);

% Retrieve x and y labels from one of the figures and apply to the overlaid plot
fig = openfig(varargin{1});
figAx = gca(fig);
xLabel = get(figAx.XLabel, 'String');
yLabel = get(figAx.YLabel, 'String');

xlabel(ax_combined, xLabel);
ylabel(ax_combined, yLabel, 'Interpreter','none');

% Close the temporary figure
close(fig);

myPath = "/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Fig files";
str = varargin{1};
startIndex = regexp(str, '_', 'once');
filename = str(startIndex:end);
savefig(figFinal, fullfile(myPath, sprintf('overlaidBarPlot%s',filename)));
end
