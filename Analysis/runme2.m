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
[t1, t2, t3, t4] = psychometricFunctionPlotPerPartition('approachavoid', 'trial', ...
    'P2L1 Boost and alcohol');

[p, tbl, stats] = kruskalWallisMultiple(t2(:,1), t3(:,1), t4(:,1));
[p, tbl, stats] = kruskalWallisMultiple(t1(:,1), t2(:,1), t3(:,1), t4(:,1));

[p, tbl, stats] = kruskalWallisMultiple(t2(:,2), t3(:,2), t4(:,2));
[p, tbl, stats] = kruskalWallisMultiple(t1(:,2), t2(:,2), t3(:,2), t4(:,2));

%% L1 vs L3 
[T1, T2, T3, T4] = masterPsychometricFunctionPlot('approachavoid', {}, ...
'P2L1L3 Baseline L1', 'P2L1L3 Baseline L3', 'P2L1L3 Boost and alcohol L1', ...
'P2L1L3 Boost and alcohol L3');
result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T2));
result = py.manovaTest.manovaTest(py.numpy.array(T3), py.numpy.array(T4));

[T1, T2, T3, T4, T5, T6] = masterPsychometricFunctionPlot('approachavoid', {}, ...
'P2L1 Baseline','P2L1L3 Baseline L1', 'P2L1L3 Baseline L3', 'P2L1 Boost and alcohol', ...
'P2L1L3 Boost and alcohol L1', 'P2L1L3 Boost and alcohol L3');

%% Session number comparison between male and female
session_label = {'NCCB', 'CCB', 'AA', 'PNC', 'PC', 'NCPA', 'CPA'};
male_session = [54,63,77,51,30,30,34]; 
female_session = [61,62,81,64,26,30,17];
p = chi2test([male_session; female_session]);

%% Trial count
males = {'aladdin', 'carl', 'jafar', 'jimi', 'jr', 'kobe', 'mike', 'scar', ...
'simba', 'sully'};
females = {'alexis', 'fiona', 'harley', 'juana', 'kryssia', 'neftali', ...
'raven', 'renata', 'sarah', 'shakira'};

treatmentGrp = {'P2L1 BL for comb boost and alc', 'P2L1L3 BL for comb boost and alc', ...
    'P2A Boost and alcohol', 'P2L1 Boost and alcohol', 'P2L1L3 Boost and alcohol', ...
    'P2L1 Post alcohol', 'P2L1L3 Post alcohol'};

totalMaleTrialCt = zeros(1, numel(treatmentGrp));
totalFemaleTrialCt = zeros(1, numel(treatmentGrp));

for grp = 1:numel(treatmentGrp)
    maleTrialCt = countSessionAndTrial('approachavoid', treatmentGrp{grp}, males, conn);
    totalMaleTrialCt(grp) = sum(maleTrialCt(:));

    femaleTrialCt = countSessionAndTrial('approachavoid', treatmentGrp{grp}, females, conn);
    totalFemaleTrialCt(grp) = sum(femaleTrialCt(:));
end

%% Trial per session
trial_per_session_male = totalMaleTrialCt ./male_session;
trial_per_session_female = totalFemaleTrialCt ./female_session;

chi2test([trial_per_session_male; trial_per_session_female]);
