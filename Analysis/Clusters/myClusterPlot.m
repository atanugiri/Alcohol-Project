% Author: Atanu Giri
% Date: 03/12/2024

function myClusterPlot(varargin)

% varargin = {'P2L1 Alcohol_approachavoid_logistic4_fitting_param', ...
%     'P2L1 Ghrelin_approachavoid_logistic4_fitting_param', ...
%     'P2L1 Ghr Alcohol_approachavoid_logistic4_fitting_param'};

[allA, allB, allC, allD, allRsq] = allFitParam(varargin{:});

% Save figure
scriptDir = fileparts(mfilename('fullpath'));
folderName = 'Fig files';
myPath = fullfile(scriptDir, folderName);
% Check if the folder exists, if not, create it
if ~exist(myPath, 'dir')
    mkdir(myPath);
end

%% Cluster Plot
figure(1);
Colors = parula(numel(varargin));

for grp = 1:numel(varargin)
    plot3(allA{grp}, allB{grp}, allC{grp}, 'o','MarkerFaceColor', Colors(grp,:), ...
        'MarkerEdgeColor', Colors(grp,:));
    legend(varargin, 'Interpreter','none');
    hold on;
end

hold off;

if contains(varargin{1}, 'logistic3')
    fig1name = sprintf('logistic3_cluster_%s',[varargin{:}]);
elseif contains(varargin{1}, 'logistic4')
    fig1name = sprintf('logistic4_cluster_%s',[varargin{:}]);
end

savefig(gcf, fullfile(myPath, fig1name));
close(gcf);

%% Lower and Upper asymptote biplot
figure(2);
for grp = 1:numel(varargin)
    h(grp) = scatter(allA{grp}, allD{grp}, 'o', 'filled', 'MarkerFaceColor', Colors(grp,:), ...
        'MarkerEdgeColor', Colors(grp,:));
    hold on;
%     legend(varargin, 'Interpreter','none');
    error_ellipse_fun([allA{grp}, allD{grp}], 0.68, Colors(grp,:));
end
hold off;

legend(h, varargin, 'Interpreter','none');

xlabel('Lower asymptote', 'FontSize', 25);
ylabel('Upper asymptote', 'FontSize', 25);

if contains(varargin{1}, 'logistic3')
    fig2name = sprintf('logistic3_asymptote_biplot_%s',[varargin{:}]);
elseif contains(varargin{1}, 'logistic4')
    fig2name = sprintf('logistic3_asymptote_biplot_%s',[varargin{:}]);
end

savefig(gcf, fullfile(myPath, fig1name));
close(gcf);
end