% Author: Atanu Giri
% Date: 02/16/2024

function varargout = sigmoid_fit_for_cluster(y)

% Define the sigmoid function
fitobject1 = @(a,b,x) a*x + b; % Line fit
fitobject2 = @(b,c,x) 1./(1 + b*exp(-c*x));
fitobject3 = @(a,b,c,x) a./(1 + b*exp(-c*x)); % Sigmoid fit
fitobject4 = @(a,b,c,d,x) a./(1+b*(exp(-c*(x-d))));
fitobject5 = @(a,b,c,x) a*(x-b)^2 + c; % Parabola fit

% Store fitobjects in an array
fitobjects = cell(1,5);
fitobjects{1} = fitobject1; 
fitobjects{2} = fitobject2; 
fitobjects{3} = fitobject3;
fitobjects{4} = fitobject4;
fitobjects{5} = fitobject5;

% Create x data as equally spaced integers from 1 to the number of elements in y
x = [1 2 3 4];

% Create empty array for fitresult and gof
fitresult = cell(1,5);
gof = zeros(1,5);

%% Work from here
for fitIdx = 1:length(fitobjects)
    % Fit the sigmoid function to the data using nonlinear regression
    [fitresult(fitIdx), gof(fitIdx)] = fit(x', y', fitobjects{fitIdx}, ...
        'StartPoint', [mean(x), 1]);
end

% Evaluate goodness of fit
a = fitresult.a;
b = fitresult.b;
goodness = gof.rsquare;

% Plot the psychometric curve and the fitted sigmoid function
% h = figure;
% plot(x', y', 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8);
% hold on;
% x_fit = linspace(min(x), max(x), 100);
% y_fit = sigmoid(a, b, x_fit);
% plot(x_fit, y_fit, 'b-', 'LineWidth', 2);
% % Add legend and axis labels
% legend('Data', 'Fitted sigmoid','Location','northwest');
% text(max(x_fit), max(y_fit), sprintf('a=%0.2f, b=%0.2f, R^2=%0.2f', a, b, goodness), ...
%     'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'FontSize', 12, 'FontWeight', 'bold');
% 
% label = [0.5 "" 2 "" 5 "" 9];
% set(gca,'xticklabel',label,'TickLabelInterpreter','latex');
% xlabel("sucrose concentration","Interpreter","latex",'FontSize',15);

end