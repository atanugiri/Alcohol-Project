% Author: Atanu Giri
% Date: 04/16/2024

function fitParamBarplot(varargin)
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

Colors = parula(numel(varargin));

%% Bar plot
myBarPlot(allA, 'Lower asymptote');
myBarPlot(allB, 'slope');
myBarPlot(allC, 'shift');
myBarPlot(allD, 'Upper asymptote');
myBarPlot(allRsq, 'R^2');


%% Description of myBarPlot
    function myBarPlot(paramArray, paramName)
        for idx = 1:numel(varargin)
            coeffArray = paramArray{idx};
            coeffArray = coeffArray(isfinite(coeffArray));
            meanCoeff = mean(coeffArray);
            stdErr = std(coeffArray)/sqrt(length(coeffArray));

            h(idx) = bar(idx, meanCoeff, 'FaceColor', Colors(idx,:));
            hold on;
            errorbar(idx, meanCoeff, stdErr, 'LineWidth', 1.5, 'Color','k');

        end

        hold off;
        title(sprintf('Bar plot of %s', paramName), 'Interpreter','latex','FontSize',25);
        legend(h, varargin, 'Interpreter', 'none', 'Location', 'best');

        if contains(varargin{1}, 'logistic3')
            figname = sprintf('logistic3_%s_barplot_%s', paramName, [varargin{:}]);
        elseif contains(varargin{1}, 'logistic4')
            figname = sprintf('logistic4_%s_barplot_%s', paramName, [varargin{:}]);
        end

        savefig(gcf, fullfile(myPath, figname));
        close(gcf);
    end
end