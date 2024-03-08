% Author: Atanu Giri
% Date: 02/16/2024

function [fitIndex, varargout] = sigmoid_fit_for_cluster(y)

% loadFile = load("featureList.mat");
% y = loadFile.featureList;

% Define the sigmoid function
fitobject1 = @(a,b,x) a*x + b; % Line fit
fitobject2 = @(b,c,x) 1./(1 + b*exp(-c*x)); % 2 param sigmoid fit
fitobject3 = @(a,b,c,x) a./(1 + b*exp(-c*x)); % Sigmoid fit
fitobject4 = @(a,b,c,d,x) a./(1 + b*(exp(-c*(x-d)))); % 3 param sigmoid fit
fitobject5 = @(a,b,c,x) a*(x-b).^2 + c; % Parabola fit

% Store fitobjects in an array
fitobjects = cell(1,5);
fitobjects{1} = fitobject1;
fitobjects{2} = fitobject2;
fitobjects{3} = fitobject3;
fitobjects{4} = fitobject4;
fitobjects{5} = fitobject5;

% Create x data as equally spaced integers from 1 to the number of elements in y
x = [1 2 3 4];

% Starting points
start_point = {[min(x), min(y)], [min(x), min(y)], [min(x), min(y), 1], ...
    [min(x), min(y), 1, 1], [min(x), min(y), 1]};

% Create empty array for fitresult and gof
fitresult = cell(1,5);
gof = zeros(1,5);

for fitIdx = 1:length(fitobjects)
    % Fit the sigmoid function to the data using nonlinear regression
    [fitresult{fitIdx}, goodness] = fit(x', y', fitobjects{fitIdx}, ...
        'StartPoint', start_point{fitIdx});
    gof(fitIdx) = goodness.rsquare;

    %% Plot the psychometric curve and the fitted sigmoid function
    %     figure;
    %     set(gcf, 'Windowstyle', 'docked');
    %     plot(x', y', 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8);
    %     hold on;
    %     x_fit = linspace(min(x), max(x), 100);
    %
    %     if fitIdx == 1
    %         y_fit = fitobjects{fitIdx}(fitresult{fitIdx}.a, fitresult{fitIdx}.b, x_fit);
    %         text(mean(xlim), max(ylim), sprintf('a=%0.2f, b=%0.2f, R^2=%0.2f', ...
    %             fitresult{fitIdx}.a, fitresult{fitIdx}.b, gof(fitIdx)));
    %
    %     elseif fitIdx == 2
    %         y_fit = fitobjects{fitIdx}(fitresult{fitIdx}.b, fitresult{fitIdx}.c, x_fit);
    %         text(mean(xlim), max(ylim), sprintf('b=%0.2f, c=%0.2f, R^2=%0.2f', ...
    %         fitresult{fitIdx}.b, fitresult{fitIdx}.c, gof(fitIdx)));
    %
    %     elseif fitIdx == 3
    %         y_fit = fitobjects{fitIdx}(fitresult{fitIdx}.a, fitresult{fitIdx}.b, ...
    %             fitresult{fitIdx}.c, x_fit);
    %         text(mean(xlim), max(ylim), sprintf('a=%0.2f, b=%0.2f, c=%0.2f, R^2=%0.2f', ...
    %         fitresult{fitIdx}.a, fitresult{fitIdx}.b, fitresult{fitIdx}.c, gof(fitIdx)));
    %
    %     elseif fitIdx == 4
    %         y_fit = fitobjects{fitIdx}(fitresult{fitIdx}.a, fitresult{fitIdx}.b, ...
    %             fitresult{fitIdx}.c, fitresult{fitIdx}.d, x_fit);
    %         text(mean(xlim), max(ylim), sprintf('a=%0.2f, b=%0.2f, c=%0.2f, d=%0.2f, R^2=%0.2f', ...
    %         fitresult{fitIdx}.a, fitresult{fitIdx}.b, fitresult{fitIdx}.c, ...
    %         fitresult{fitIdx}.d, gof(fitIdx)));
    %
    %     else
    %         y_fit = fitobjects{fitIdx}(fitresult{fitIdx}.a, fitresult{fitIdx}.b, ...
    %             fitresult{fitIdx}.c, x_fit);
    %         text(mean(xlim), max(ylim), sprintf('a=%0.2f, b=%0.2f, c=%0.2f, R^2=%0.2f', ...
    %         fitresult{fitIdx}.a, fitresult{fitIdx}.b, fitresult{fitIdx}.c, gof(fitIdx)));
    %     end
    %
    %     plot(x_fit, y_fit, 'b-', 'LineWidth', 2);

end

%% Extract output
if gof(3) >= 0.4 % fitobject3 gets priority
    fitIndex = 3;
    a = fitresult{3}.a;
    b = fitresult{3}.b;
    c = fitresult{3}.c;
    goodness = gof(3);
    varargout = {a, b, c, goodness};

elseif gof(4) >= 0.4
    fitIndex = 4;
    a = fitresult{4}.a;
    b = fitresult{4}.b;
    c = fitresult{4}.c;
    goodness = gof(4);
    varargout = {a, b, c, goodness};

elseif gof(2) >= 0.4
    fitIndex = 2;
    a = 1;
    b = fitresult{2}.b;
    c = fitresult{2}.c;
    goodness = gof(2);
    varargout = {a, b, c, goodness};

elseif gof(1) >= gof(5)
    fitIndex = 1;
    a = fitresult{1}.a;
    b = fitresult{1}.b;
    c = [];
    goodness = gof(1);
    varargout = {a, b, c, goodness};

elseif gof(5) >= gof(1)
    fitIndex = 5;
    a = fitresult{5}.a;
    b = fitresult{5}.b;
    c = fitresult{5}.c;
    goodness = gof(5);
    varargout = {a, b, c, goodness};
else
    varargout = {};
end

end