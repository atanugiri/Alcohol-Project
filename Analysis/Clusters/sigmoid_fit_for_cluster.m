% Author: Atanu Giri
% Date: 02/16/2024
%
% This function fits the response data from a session with desired fit
% model and extracts fitting parameters.
%

function [h, fit_params, R_squared] = sigmoid_fit_for_cluster(y, fitType)

% y = [0.9, 0.1, 0.5, 0.1]; fitType = 2;

% Define fitobjects
fitobjects{1} = @(params, x) params(1) ./ (1 + exp(-params(2) * ...
    (x - params(3)))); % 3 param logistic fit

fitobjects{2} = @(params, x) params(4) + ((params(1) - params(4)) ./ ...
    (1 + (x ./ params(3)).^params(2))); % 4 param logistic fit

fitobjects{3} = @(params, x) params(2) + (params(3) - params(2) + ...
    params(5)*x) ./ (1 + exp(params(1)*(log(x) - log(params(4))))); % Brain and Cousens

fitobjects{4} = @(params, x) params(1) ./ (1 + exp(-params(2) * ... % Linear combination
    (x - params(3)))) + params(4) ./ (1 + exp(params(5) * (x - params(6))));

% Create x data as equally spaced integers from 1 to the number of elements in y
x = [1 2 3 4];

% Starting points
initial_guess = cell(1, numel(fitobjects));
initial_guess{1} = [max(y), 1, median(x)];
initial_guess{2} = [min(y), 1, median(x), max(y)];
initial_guess{3} = [1, min(y), max(y), median(x), 0];
initial_guess{4} = [max(y), 1, median(x), max(y), 1, median(x)];

% Define lower and upper bounds for parameters
lb = cell(1, numel(fitobjects)); ub = cell(1, numel(fitobjects));
lb{1} = [0, -Inf, 1]; ub{1} = [1, Inf, 4];
lb{2} = [0, -Inf, 1, 0]; ub{2} = [1, Inf, 4, 1];
lb{3} = [-Inf, 0, 0, 1, -Inf]; ub{3} = [Inf, 1, 1, 4, Inf];
lb{4} = [0, -Inf, 1, 0, -Inf, 1]; ub{1} = [1, Inf, 4, 1, Inf, 4];

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

%% Plot the psychometric curve and the fitted sigmoid function
x_values = linspace(min(x), max(x), 100);

y_pred = fitobject(fit_params, x_values);

h = figure;
scatter(x, y, 100, 'o', 'filled');
hold on;
plot(x_values, y_pred, 'linewidth', 2);
xlabel('x');
ylabel('y');
legend('Data', 'Fitted Curve');
hold off;
ylim([0, 1]);
end