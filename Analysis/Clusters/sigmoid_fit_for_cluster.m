% Author: Atanu Giri
% Date: 02/16/2024
%
% This function fits the response data from a session with desired fit 
% model and extracts fitting parameters.
%

function [h, fitIndex, varargout] = sigmoid_fit_for_cluster(y)

% y = [0, 0, 0, 0];

% Define the sigmoid function
fitobject1 = @(params, x) params(1)*x + params(2); % Line fit
fitobject2 = @(params, x) params(1) ./ (1 + exp(-params(2) * (x - params(3)))); % logistic fit
fitobject3 = @(params, x) params(1)*(x-params(2)).^2 + params(3); % Parabola fit

% Store fitobjects in an array
fitobjects = cell(1,3);
fitobjects{1} = fitobject1;
fitobjects{2} = fitobject2;
fitobjects{3} = fitobject3;

% Create x data as equally spaced integers from 1 to the number of elements in y
x = [1 2 3 4];

% Starting points
initial_guess = {[min(x), min(y)], [max(y), 1, median(x)], [min(x), min(y), 1]};
% Define lower and upper bounds for parameters a and c
lb = [0, -Inf, 1];
ub = [1, Inf, 4];

% Create empty array for fitresult and gof
fit_params = cell(1, numel(fitobjects));
gof = zeros(1, numel(fitobjects));

for fitIdx = 1:length(fitobjects)
    % Fit the sigmoid function to the data using nonlinear regression
    %     [fitresult{fitIdx}, goodness] = fit(x', y', fitobjects{fitIdx}, ...
    %         'StartPoint', initial_guess{fitIdx});
    %     gof(fitIdx) = goodness.rsquare;

    fit_params{fitIdx} = lsqcurvefit(fitobjects{fitIdx}, initial_guess{fitIdx}, x, y, lb, ub);

    % Compute the fitted values using the sigmoid function and the fitted parameters
    y_fit = fitobjects{fitIdx}(fit_params{fitIdx}, x);
    % Compute the total sum of squares (TSS) and residual sum of squares (RSS)
    y_mean = mean(y);
    TSS = sum((y - y_mean).^2);
    RSS = sum((y - y_fit).^2);
    R_squared = 1 - (RSS / TSS);

    gof(fitIdx) = R_squared;
end

%% Extract output
if 1 > 0 % gof(2) >= 0.4
    fitIndex = 2;
    a = fit_params{2}(1);
    b = fit_params{2}(2);
    c = fit_params{2}(3);
    goodness = gof(2);
    varargout = {a, b, c, goodness};

elseif gof(1) >= gof(3)
    fitIndex = 1;
    a = fit_params{1}(1);
    b = fit_params{1}(2);
    c = [];
    goodness = gof(1);
    varargout = {a, b, c, goodness};

elseif gof(3) >= gof(1)
    fitIndex = 3;
    a = fit_params{3}(1);
    b = fit_params{3}(2);
    c = fit_params{3}(3);
    goodness = gof(3);
    varargout = {a, b, c, goodness};
else
    varargout = {};
end

%% Plot the psychometric curve and the fitted sigmoid function
x_values = linspace(min(x), max(x), 1000);
if 1 > 0 % gof(2) >= 0.4
    y_fit = fitobjects{2}(fit_params{2}, x_values);

elseif gof(1) >= gof(3)
    y_fit = fitobjects{1}(fit_params{1}, x_values);

elseif gof(3) >= gof(1)
    y_fit = fitobjects{3}(fit_params{3}, x_values);
end

h = figure;
plot(x, y, 'o', x_values, y_fit);
xlabel('x');
ylabel('y');
legend('Data', 'Fitted Curve');
end