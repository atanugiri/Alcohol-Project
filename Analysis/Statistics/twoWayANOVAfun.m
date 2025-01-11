% Author: Atanu Giri
% Date: 04/02/2024
%
% This function takes multiple data set of psychometrics values and
% performs 2-way ANOVA test for 1st set vs others
%

function [p, tbl] = twoWayANOVAfun(T1, T2)
responseData = vertcat(T1, T2);
groupLabel = [repmat({'T1'}, size(T1, 1), size(T1, 2)); ...
    repmat({'T2'}, size(T2, 1), size(T2, 2))];
concLabel = repelem(1:4, size(responseData,1), 1);

responseData = reshape(responseData, [], 1);
groupLabel = reshape(groupLabel, [], 1);
concLabel = reshape(concLabel, [], 1);

% Perform Two-Way ANOVA
[p, tbl] = anovan(responseData, {groupLabel, concLabel}, ...
    'model', 'interaction', 'varnames', {'Group', 'Concentration'});

% if p < 0.05
%     [c,~,~,gnames] = multcompare(stats, 'Dimension', [1 2]);
% end
end