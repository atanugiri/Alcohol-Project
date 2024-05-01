% Author: Atanu Giri
% Date: 04/16/2024
%
% Plots histogram of input parameter.
%
% Possible parameter names 
% logistic3 fit: 'UA', 'slope', 'shift', 'Rsq'
% logistic4 fit: 'LA', 'slope', 'shift', 'UA', 'Rsq'
% BC fit: 'LA', 'slope', 'shift', 'UA', 'param_f', 'Rsq'
% LC fit: 'UA', 'slope', 'shift', 'UA_2', 'slope_2', 'shift_2', 'Rsq'
% 
% Invokes allFitParam

function fitParamHistogram(param_name, varargin)

% param_name = 'UA';
% varargin = {'P2L1 Alcohol_approachavoid_logistic3_fitting_param', ...
%     'P2L1 Ghrelin_approachavoid_logistic3_fitting_param', ...
%     'P2L1 Ghr Alcohol_approachavoid_logistic3_fitting_param'};

if contains(varargin{1}, 'logistic3')
    [UA, slope, shift, Rsq] = allFitParam(varargin{:});

elseif contains(varargin{1}, 'logistic4')
    [LA, slope, shift, UA, Rsq] = allFitParam(varargin{:});

elseif contains(varargin{1}, 'BC')
    [LA, slope, shift, UA, param_f, Rsq] = allFitParam(varargin{:});

elseif contains(varargin{1}, 'LC')
    [UA, slope, shift, UA_2, slope_2, shift_2, Rsq] = allFitParam(varargin{:});

end

Colors = parula(numel(varargin));

% param_name_array = {'UA', 'slope', 'shift', 'LA', 'param_f', 'Rsq'};
% bwArray = [0.05, 10, 0.15, 0.05, 0.05, 0.05]; % Width of bin
% 
% index = strcmpi(param_name_array, param_name);
% currentBW = bwArray(index);

if strcmpi(param_name, 'UA')
    param_array = UA;
elseif strcmpi(param_name, 'slope')
    param_array = slope;
elseif strcmpi(param_name, 'shift')
    param_array = shift;
elseif strcmpi(param_name, 'LA')
    param_array = LA;
elseif strcmpi(param_name, 'param_f')
    param_array = param_f;
elseif strcmpi(param_name, 'UA_2')
    param_array = UA_2;
elseif strcmpi(param_name, 'slope_2')
    param_array = slope_2;
elseif strcmpi(param_name, 'shift_2')
    param_array = shift_2;
elseif strcmpi(param_name, 'Rsq')
    param_array = Rsq;
end

scriptDir = fileparts(mfilename('fullpath'));
myPath = fullfile(scriptDir, 'Fig files/');

% Histogram
histOfParam(param_array, param_name);


%% Description of histOfParam
    function histOfParam(paramArray, param_name)
        for idx = 1:numel(varargin)

%             h(idx) = histogram(paramArray{idx}, 'Normalization','pdf','FaceAlpha',0.7, ...
%                 'BinWidth', currentBW, 'FaceColor', Colors(idx,:));

            [f, x_values] = ksdensity(paramArray{idx}); % Compute KDE values and corresponding x-values
            h(idx) = plot(x_values, f, 'LineWidth', 2);
            % https://www.researchgate.net/publication/320535371_Intelligent_OS_X_malware_threat_detection_with_code_inspection/figures?lo=1
            % https://stackoverflow.com/questions/46441481/why-does-this-kernel-density-estimation-have-values-over-1-0
            hold on;
        end

        hold off;
        title(sprintf('Histogram of %s', param_name), 'Interpreter','latex','FontSize',25);
        legend(h, varargin, 'Interpreter','none','Location','best');
        xlabel('value','Interpreter','latex');
        ylabel('probability density','Interpreter','latex');

        if contains(varargin{1}, 'logistic3')
            figname = sprintf('logistic3_%s_hist_%s', param_name, [varargin{:}]);

        elseif contains(varargin{1}, 'logistic4')
            figname = sprintf('logistic4_%s_hist_%s', param_name, [varargin{:}]);

        elseif contains(varargin{1}, 'BC')
            figname = sprintf('BC_%s_hist_%s', param_name, [varargin{:}]);
        
        elseif contains(varargin{1}, 'LC')
            figname = sprintf('LC_%s_hist_%s', param_name, [varargin{:}]);

        end

        savefig(gcf, fullfile(myPath, figname));
        close(gcf);
    end
end