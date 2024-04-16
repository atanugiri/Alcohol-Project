% Author: Atanu Giri
% Date: 04/16/2024

function fitParamHistogram(varargin)
varargin = {'P2L1 Alcohol_approachavoid_logistic4_fitting_param', ...
    'P2L1 Ghrelin_approachavoid_logistic4_fitting_param', ...
    'P2L1 Ghr Alcohol_approachavoid_logistic4_fitting_param'};

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

%% Histogram
bwArray = [0.05, 10, 0.15, 0.05]; % Width of bin
histOfParam(allA, 'Lower asymptote', bwArray(1));
histOfParam(allB, 'slope', bwArray(2));
histOfParam(allC, 'shift', bwArray(3));
histOfParam(allD, 'Upper asymptote', bwArray(1));
histOfParam(allRsq, 'R^2', bwArray(4));


%% Description of histOfParam
    function histOfParam(paramArray, paramName, currentBW)
        for idx = 1:numel(varargin)
            h(idx) = histogram(paramArray{idx}, 'Normalization','pdf','FaceAlpha',0.7, ...
                'BinWidth', currentBW, 'FaceColor', Colors(idx,:));
            hold on;
        end

        hold off;
        title(sprintf('Histogram of %s', paramName), 'Interpreter','latex','FontSize',25);
        legend(h, varargin, 'Interpreter','none','Location','best');
        xlabel('value','Interpreter','latex');
        ylabel('probability density','Interpreter','latex');

        if contains(varargin{1}, 'logistic3')
            figname = sprintf('logistic3_%s_hist_%s', paramName, [varargin{:}]);
        elseif contains(varargin{1}, 'logistic4')
            figname = sprintf('logistic4_%s_hist_%s', paramName, [varargin{:}]);
        end

        savefig(gcf, fullfile(myPath, figname));
        close(gcf);
    end
end
