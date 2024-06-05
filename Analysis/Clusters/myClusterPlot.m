% Author: Atanu Giri
% Date: 03/12/2024
%
% This function plots lower asymptote, shift, upper asymptote in 3-D.
% Invokes allFitParam
%
% Example usage:
% myClusterPlot(...
% 'P2L1 BL for comb boost and alc_approachavoid_logistic4_fitting_param', ...
% 'P2L1 Boost and alcohol_approachavoid_logistic4_fitting_param')
%

function myClusterPlot(varargin)

varargin = {'P2L1 Boost and alcohol_approachavoid_logistic4_fitting_param_2.mat'};

[LA, slope, shift, UA, Rsq, animals] = allFitParam(varargin{:});

%% Cluster Plot
figure;
Colors = parula(numel(varargin));

for grp = 1:numel(varargin)
    plot3(LA{grp}, shift{grp}, UA{grp}, 'o','MarkerFaceColor', Colors(grp,:), ...
        'MarkerEdgeColor', Colors(grp,:));
    legend(varargin, 'Interpreter','none');
    hold on;
end

hold off;

if contains(varargin{1}, 'logistic3')
%     fig1name = sprintf('logistic3_cluster_%s',[varargin{:}]);
    fig1name = sprintf('logistic3_cluster');

elseif contains(varargin{1}, 'logistic4')
    fig1name = sprintf('logistic4_cluster');
end

% Save figure
scriptDir = fileparts(mfilename('fullpath'));
folderName = 'Fig files';
myPath = fullfile(scriptDir, folderName);
% Check if the folder exists, if not, create it
if ~exist(myPath, 'dir')
    mkdir(myPath);
end

savefig(gcf, fullfile(myPath, fig1name));
end