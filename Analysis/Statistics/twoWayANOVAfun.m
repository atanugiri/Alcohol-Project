% Author: Atanu Giri
% Date: 04/02/2024
%
% This function takes multiple data set of psychometrics values and 
% performs 2-way ANOVA test for 1st set vs others
%
% varargin = featureForEach;

function p = twoWayANOVAfun(varargin)


% Check if at least two data sets are provided
if numel(varargin) < 2
    error('At least two data sets are required for comparison.');
end

for grp = 2:numel(varargin)
    responseData = vertcat(varargin{1}, varargin{grp});
    groupLabel = [repmat({'T1'}, size(varargin{1}, 1), size(varargin{1}, 2)); ...
        repmat({sprintf('T%d', grp)}, size(varargin{grp}, 1), size(varargin{grp}, 2))];
    concLabel = repelem(1:4, (size(varargin{1}, 1) + size(varargin{grp}, 1)), 1);

    % Perform 2-way ANOVA
    [p, tbl] = anovan(responseData(:), {groupLabel(:), concLabel(:)}, ...
        'varnames', {'group', 'concentration'}, 'model', 2, 'display', 'off');

    % Display results
    fprintf('ANOVA for T1 vs T%d:\n', grp);
    disp(tbl);
%     fprintf('p-value: %.4e\n\n', p);
end

end