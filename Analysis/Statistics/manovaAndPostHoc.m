% Author: Atanu Giri
% Date: 09/23/2024
%

function [d_manova, p_manova, stats_manova] = manovaAndPostHoc(T1, T2)
% Combine data for MANOVA
data = [T1; T2];
group = [repmat({'T1'}, size(T1, 1), 1); repmat({'T2'}, size(T2, 1), 1)];

[d_manova, p_manova, stats_manova] = manova1(data, group);

fprintf('\n');
disp('Post-hoc comparisons:');
% Perform post-hoc pairwise comparisons using each feature independently
for i = 1:size(data, 2)
    % Extract individual feature data for post-hoc
    feature_data = data(:, i);

    % Run one-way ANOVA on each feature
    [p_anova, tbl_anova, stats_anova] = anova1(feature_data, group, 'off');
    [c, m, h, gnames] = multcompare(stats_anova);

    % Output results to the command window
    fprintf('Conc %d: %0.4f\n', i, c(6));
end
end