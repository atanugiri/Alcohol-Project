% Author: Atanu Giri
% Date: 07/02/2024
%
% This function fits the response data with no upper or lower bound. This
% is possibly wrong.
%

function [h, fit_params, R_squared] = sigmoid_analysis(y)

% y = [0.1, 0.3, 0.5, 0.9];

% Define fitobjects
fitobjects{1} = 'a*x+b';
fitobjects{2} = '1 / (1 + (b*exp(-c * x)))';
fitobjects{3} = 'a/(1+b*exp(-c*(x)))';
fitobjects{4} = 'a/(1+(b*(exp(-c*(x-d)))))';
fitobjects{5} = 'a*(x-b)^(2)+c';

x = [0.5 2 5 9];
thresh = 0.4;

% Placeholder for results
fitobject = cell(1, numel(fitobjects));
gof = cell(1, numel(fitobjects));

for i = 1:numel(fitobjects)
    [fitobject{i}, gof{i}] = fit(x.', y.', fitobjects{i});
    counter = 1;
    while counter <20 && gof{i}.rsquare < .4
        [fitobject{i}, gof{i}] = fit(x.', y.', fitobjects{i});
        counter = counter+1;
    end
end

h = figure;

if gof{3}.rsquare >= thresh
    plot(fitobject{3},x.',y.');
    title("3 Param Sigmoid");
    fit_params = [fitobject{3}.a, fitobject{3}.b, fitobject{3}.c];
    R_squared = gof{3}.rsquare;

elseif gof{4}.rsquare >= thresh
    plot(fitobject{4},x.',y.');
    title("4 Param Sigmoid");
    fit_params = [fitobject{4}.a, fitobject{4}.b, fitobject{4}.c, ...
        fitobject{4}.d];
    R_squared = gof{4}.rsquare;

elseif gof{2}.rsquare >= thresh
    plot(fitobject{2},x.',y.');
    title("2 Param Sigmoid");
    fit_params = [1, fitobject{2}.b, fitobject{2}.c];
    R_squared = gof{2}.rsquare;

elseif gof{1}.rsquare > gof{5}.rsquare
    plot(fitobject{1},x.',y.');
    title("Line");
    fit_params = [fitobject{1}.a, fitobject{1}.b];
    R_squared = gof{1}.rsquare;

elseif gof{5}.rsquare > gof{1}.rsquare
    plot(fitobject{5},x.',y.');
    title("Parabola");
    fit_params = [fitobject{5}.a, fitobject{5}.b, fitobject{5}.c];
    R_squared = gof{5}.rsquare;
end

xlabel('Conc.');
ylabel('Choice');
legend('Data', 'Fitted Curve');
hold off;
ylim([0, 1]);
end