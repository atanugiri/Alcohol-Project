% Author: Atanu Giri
% Date: 02/16/2024
%
% This function fits the response data from a session with desired fit
% model and extracts fitting parameters.
%

function [h, varargout] = sigmoid_fit_for_cluster(y, fitType)

% y = [0, 0.3, 0.5, 0.9]; fitType = 2;

% Define fitobjects
fitobjects{1} = @(params, x) params(1) ./ (1 + exp(-params(2) * (x - params(3)))); % logistic fit
fitobjects{2} = @(params, x) params(4) + ...
    ((params(1) - params(4)) ./ (1 + (x ./ params(3)).^params(2))); % 4 param logistic fit
% fitobjects{3} = @(params, x) params(1)*(x-params(2)).^2 + params(3); % Parabola fit

% Create x data as equally spaced integers from 1 to the number of elements in y
x = [1 2 3 4];

% Starting points
initial_guess = cell(1, numel(fitobjects));
initial_guess{1} = [max(y), 1, median(x)];
initial_guess{2} = [min(y), 1, median(x), max(y)];

% Define lower and upper bounds for parameters
lb = cell(1, numel(fitobjects)); ub = cell(1, numel(fitobjects));
lb{1} = [0, -Inf, 1]; ub{1} = [1, Inf, 4];
lb{2} = [0, -Inf, 1, 0]; ub{2} = [1, Inf, 4, 1];


% Fit the sigmoid function to the data using nonlinear regression
%     [fitresult{fitIdx}, goodness] = fit(x', y', fitobjects{fitIdx}, ...
%         'StartPoint', initial_guess{fitIdx});

fitobject = fitobjects{fitType};
fit_params = lsqcurvefit(fitobject, initial_guess{fitType}, ...
    x, y, lb{fitType}, ub{fitType});

% Compute the fitted values using the sigmoid function and the fitted parameters
y_fit = fitobject(fit_params, x);

% Compute the total sum of squares (TSS) and residual sum of squares (RSS)
y_mean = mean(y);
TSS = sum((y - y_mean).^2);
RSS = sum((y - y_fit).^2);
R_squared = 1 - (RSS / TSS);

% Store fit results
if fitType == 1
    a = fit_params(1);
    b = fit_params(2);
    c = fit_params(3);
    goodness = R_squared;
    varargout = {a, b, c, goodness};

elseif fitType == 2
    a = fit_params(1);
    b = fit_params(2);
    c = fit_params(3);
    d = fit_params(4);
    goodness = R_squared;
    varargout = {a, b, c, d, goodness};
end

%% Plot the psychometric curve and the fitted sigmoid function
x_values = linspace(min(x), max(x), 100);

y_pred = fitobject(fit_params, x_values);

h = figure;
plot(x, y, 'o', x_values, y_pred);
xlabel('x');
ylabel('y');
legend('Data', 'Fitted Curve');
end