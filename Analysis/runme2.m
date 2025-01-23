% Author: Atanu Giri
% Date: 01/19/2025
%

%% Pre Light place preferance
% BL_time_pre_tone = analyzeConditionalPlacePreferance('P2L1 BL for comb boost and alc', 'pre');
% P2A_alcohol_time_pre_tone = analyzeConditionalPlacePreferance('P2A Boost and alcohol', 'pre');
% P2L1_alcohol_time_pre_tone = analyzeConditionalPlacePreferance('P2L1 Boost and alcohol', 'pre');
% P2L1_post_alcohol_time_pre_tone = analyzeConditionalPlacePreferance('P2L1 Post alcohol', 'pre');

% data = {BL_time, P2A_alcohol_time, P2L1_alcohol_time, P2L1_post_alcohol_time};
% dataLabel = {'P2L1 BL for comb boost and alc','P2A Boost and alcohol','P2L1 Boost and alcohol', ...
%     'P2L1 Post alcohol'};
% x = 1:4;
% Colors = parula(4);
% 
% for maze = 1:4
%     figure;
%     for i = 1:numel(data)
%         plot(x, data{i}(maze,end:-1:1), '.-', 'LineWidth', 2, 'Color', Colors(i, :), ...
%             'DisplayName',sprintf('%s', dataLabel{i}));
%         hold on;
%     end
% 
%     hold off;
%     % Add label and legend
%     xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
%     ylabel('Time in port', 'Interpreter','none', 'FontSize', 25);
%     xticks(1:4);
%     label = {'0.5','2','5','9'};
%     set(gca,'xticklabel',label,'FontSize',15);
%     legend('show', 'Interpreter', 'none');
%     title(sprintf('Maze_%s_pre_tone', num2str(maze)), 'Interpreter','none');
% end


%% Post Light place preferance
% BL_time_post_tone = analyzeConditionalPlacePreferance('P2L1 BL for comb boost and alc', 'post');
% P2A_alcohol_time_post_tone = analyzeConditionalPlacePreferance('P2A Boost and alcohol', 'post');
% P2L1_alcohol_time_post_tone = analyzeConditionalPlacePreferance('P2L1 Boost and alcohol', 'post');
% P2L1_post_alcohol_time_post_tone = analyzeConditionalPlacePreferance('P2L1 Post alcohol', 'post');

time_data_post_tone = {BL_time_post_tone, P2A_alcohol_time_post_tone, P2L1_alcohol_time_post_tone, ...
    P2L1_post_alcohol_time_post_tone};
dataLabel = {'P2L1 BL for comb boost and alc','P2A Boost and alcohol','P2L1 Boost and alcohol', ...
    'P2L1 Post alcohol'};
x = 1:4;
Colors = parula(4);

for maze = 1:4
    figure;
    for i = 1:numel(time_data_post_tone)
        plot(x, time_data_post_tone{i}(maze,end:-1:1), '.-', 'LineWidth', 2, 'Color', Colors(i, :), ...
            'DisplayName',sprintf('%s', dataLabel{i}));
        hold on;
    end

    hold off;
    % Add label and legend
    xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
    ylabel('Time in port', 'Interpreter','none', 'FontSize', 25);
    xticks(1:4);
    label = {'0.5','2','5','9'};
    set(gca,'xticklabel',label,'FontSize',15);
    legend('show', 'Interpreter', 'none');
    title(sprintf('Maze_%s_post_tone', num2str(maze)), 'Interpreter','none');
end


%% Session progression in P2A alcohol
featureForEach = psychometricFunctionPlotPerPartition('approachavoid', 'session', ...
    'P2A Boost and alcohol');

% non-parametric test for small variance: Kruskal-Wallis test
group = (1:size(featureForEach, 1))'; % Group each row as a session
for col = 1:size(featureForEach, 2)
    disp(['Analyzing concentration ', num2str(col), ' using Kruskal-Wallis test']);
    p = kruskalwallis(featureForEach(:, col), group, 'off'); % Include group variable
    disp(['P-value: ', num2str(p)]);
end

% Individual p-values from the Kruskal-Wallis test
p_values = [0.42888, 0.42888, 0.42888, 0.42888];

% Compute Fisher's combined test statistic
chi_square_stat = -2 * sum(log(p_values));

% Degrees of freedom
df = 2 * length(p_values);

% Compute the combined p-value
combined_p = 1 - chi2cdf(chi_square_stat, df);

% Display the result
disp(['Combined P-value using Fisher''s method: ', num2str(combined_p)]);


%% Trial progression in P2L1 alcohol
featureForEach = psychometricFunctionPlotPerPartition('approachavoid', 'trial', ...
    'P2L1 Boost and alcohol');
for col = 1:4
    for grp = 1:numel(featureForEach)
        tempData = 
    end
end
tempData = 