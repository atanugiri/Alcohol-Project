function [p, tbl, stats] = kruskalWallisMultiple(varargin)
    % kruskalWallisMultiple - Perform Kruskal-Wallis test on multiple input datasets.
    %
    % Syntax: [p, tbl, stats] = kruskalWallisMultiple(data1, data2, ...)
    %
    % Inputs:
    %   - varargin: Variable number of input arrays (data1, data2, ...)
    %
    % Outputs:
    %   - p: p-value of the Kruskal-Wallis test.
    %   - tbl: Table of test statistics.
    %   - stats: Structure containing Kruskal-Wallis test statistics for further analysis.
    %
    % Example:
    %   [p, tbl, stats] = kruskalWallisMultiple(data1, data2, data3);
    %
    % Notes:
    %   - Each input dataset must be a column vector.

    % Combine all datasets into a single array
    allData = vertcat(varargin{:});
    
    % Create group labels
    numGroups = numel(varargin);
    groupLabels = [];
    for i = 1:numGroups
        groupLabels = [groupLabels; repmat(i, size(varargin{i}))];
    end
    
    % Perform Kruskal-Wallis test
    [p, tbl, stats] = kruskalwallis(allData, groupLabels, 'off'); % 'off' suppresses the plot
end
