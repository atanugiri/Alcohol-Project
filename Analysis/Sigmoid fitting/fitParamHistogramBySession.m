% Author: Atanu Giri
% Date: 06/11/2024
%
% Plots histogram of input parameter.
%
% Possible parameter names
% logistic3 fit: 'UA', 'slope', 'shift', 'Rsq'
% logistic4 fit: 'LA', 'slope', 'shift', 'UA', 'Rsq'
% GP fit: 'LA', 'slope', 'shift', 'UA', 'Rsq'
%
% Invokes allFitParamBySession

function varargout = fitParamHistogramBySession(param_name, splitbyGender, trtmntName)

% param_name = 'shift'; splitbyGender = 'n';
% trtmntName = 'P2L1L3 Boost and alcohol_approachavoid_logistic4_fitting_param';

if contains(trtmntName, 'logistic3')
    [UA, slope, shift, Rsq, animals] = allFitParamBySession(trtmntName);
    featureMap = struct('UA', UA, 'slope', slope, 'shift', shift, 'Rsq', Rsq);

elseif contains(trtmntName, 'logistic4')
    [LA, slope, shift, UA, Rsq, animals] = allFitParamBySession(trtmntName);
    featureMap = struct('LA', LA, 'slope', slope, 'shift', shift, 'UA', UA, ...
        'Rsq', Rsq);

elseif contains(trtmntName, 'GP')
    [LA, slope, shift, UA, Rsq, animals] = allFitParamBySession(trtmntName);
    featureMap = struct('LA', LA, 'slope', slope, 'shift', shift, 'UA', UA, ...
        'Rsq', Rsq);
end

param_array = cell(1, numel(shift));
for i = 1:numel(shift)
    param_array{i} = featureMap(i).(param_name);
end

varargout{1} = param_array;
Colors = parula(numel(shift));

% Output location
scriptDir = fileparts(mfilename('fullpath'));
myPath = fullfile(scriptDir, 'Fig files/');

figure;

for idx = 1:numel(shift)
    [f, x_values] = ksdensity(param_array{idx}); % Compute KDE values and corresponding x-values
    h(idx) = plot(x_values, f, 'LineWidth', 2, 'Color', Colors(idx,:));
    h(idx).DisplayName = sprintf('session %d', idx);
    hold on;
end

legend('show');
hold off;

% Use regexp to extract the part until the first underscore of trtmntName
result = regexp(trtmntName, '^[^_]+', 'match');
extracted_part = result{1};
sgtitle(sprintf('%s, %s', extracted_part, param_name), ...
    'Interpreter','latex','FontSize',25);

if ~strcmpi(splitbyGender, 'y')
    xlabel('value','Interpreter','latex');
    ylabel('probability density','Interpreter','latex');
end