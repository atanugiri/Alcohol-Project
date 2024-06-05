% Author: Atanu Giri
% Date: 05/28/2024
%
% This function plots 2 features in 2-D according to user input.
% Available features: 'LA', 'slope', 'shift', 'UA'
% Invokes allFitParam
%
% Example usage:
% featureBiplot(feature1, feature2, ...
% 'P2L1 BL for comb boost and alc_approachavoid_logistic4_fitting_param', ...
% 'P2L1 Boost and alcohol_approachavoid_logistic4_fitting_param')
%
function featureBiplot(feature1, feature2, varargin)

% feature1 = 'UA'; feature2 = 'shift';
% varargin = {'P2L1 BL for comb boost and alc_approachavoid_logistic4_fitting_param', ...
% 'P2L1 Boost and alcohol_approachavoid_logistic4_fitting_param_2'};

[LA, slope, shift, UA] = allFitParam(varargin{:});

% Define a map of feature names to their corresponding variables
featureMap = struct('LA', LA, 'slope', slope, 'shift', shift, 'UA', UA);

% Initialize cell arrays to hold the data for each varargin input
feature1Data = cell(1, numel(varargin));
feature2Data = cell(1, numel(varargin));

% Validate and retrieve the feature data for feature1 and feature2 for each varargin input
for i = 1:numel(varargin)
    if isfield(featureMap, feature1)
        feature1Data{i} = featureMap(i).(feature1);
    else
        error('Invalid feature1: %s. Available features: LA, slope, shift, UA', feature1);
    end

    if isfield(featureMap, feature2)
        feature2Data{i} = featureMap(i).(feature2);
    else
        error('Invalid feature2: %s. Available features: LA, slope, shift, UA', feature2);
    end
end

Colors = parula(numel(varargin));
figure;
for grp = 1:numel(varargin)
    h(grp) = scatter(feature1Data{grp}, feature2Data{grp}, 'o', 'filled', ...
        'MarkerFaceColor',Colors(grp,:),'MarkerEdgeColor', Colors(grp,:));
    hold on;
    %     legend(varargin, 'Interpreter','none');
%     error_ellipse_fun([feature1Data{grp}, feature1Data{grp}], 0.68, Colors(grp,:));
end
hold off;

legend(h, varargin, 'Interpreter','none');
xlabel(sprintf('%s', feature1), 'FontSize', 25);
ylabel(sprintf('%s', feature2), 'FontSize', 25);

if contains(varargin{1}, 'logistic3')
    figname = sprintf('logistic3_biplot');
elseif contains(varargin{1}, 'logistic4')
    figname = sprintf('logistic4_biplot');
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