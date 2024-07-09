function [var_y, lowerCI, upperCI] = varianceCalculation(data)
% Calculate variance
var_y = var(data);
% Number of observations in each column
n = size(data, 1);
dF = n - 1;  % degrees of freedom for each column

% Calculate chi-squared values for the desired confidence level (e.g., 95%)
A = chi2inv(0.975, dF);
B = chi2inv(0.025, dF);

lowerCI = (dF * var_y) / A;
upperCI = (dF * var_y) / B;
end