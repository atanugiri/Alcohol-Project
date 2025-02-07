% Author: Atanu Giri
% Date: 01/19/2025
%

%% Pre Light place preferance
P2L1_alcohol_time_pre_tone = analyzeConditionalPlacePreferance('P2L1 Boost and alcohol', 'pre');
P2L1_post_alcohol_time_pre_tone = analyzeConditionalPlacePreferance('P2L1 Post alcohol', 'pre');


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
% Approach rate
[t1, t2, t3, t4] = trialProgressionPsychometricFun('approachavoid', ...
    'P2L1 Boost and alcohol');

[p, tbl, stats] = kruskalWallisMultiple(t2(:,1), t3(:,1), t4(:,1));
[p, tbl, stats] = kruskalWallisMultiple(t1(:,1), t2(:,1), t3(:,1), t4(:,1));

[p, tbl, stats] = kruskalWallisMultiple(t2(:,2), t3(:,2), t4(:,2));
[p, tbl, stats] = kruskalWallisMultiple(t1(:,2), t2(:,2), t3(:,2), t4(:,2));

[t1, t2, t3, t4] = trialProgressionPsychometricFun('approachavoid', ...
    'P2L1 Post alcohol');
[p, tbl, stats] = kruskalWallisMultiple(t1(:,1), t2(:,1), t3(:,1), t4(:,1));
[p, tbl, stats] = kruskalWallisMultiple(t1(:,2), t2(:,2), t3(:,2), t4(:,2));


% Time in reward zone
[T1, T2, T3, T4] = trialProgressionPsychometricFun('time_in_feeder_25', ...
    'P2L1 Boost and alcohol');
[p, tbl, stats] = kruskalWallisMultiple(T2(:,1), T3(:,1), T4(:,1));
[p, tbl, stats] = kruskalWallisMultiple(T1(:,1), T2(:,1), T3(:,1), T4(:,1));

[p, tbl, stats] = kruskalWallisMultiple(T2(:,2), T3(:,2), T4(:,2));
[p, tbl, stats] = kruskalWallisMultiple(T1(:,2), T2(:,2), T3(:,2), T4(:,2));

[T1, T2, T3, T4] = trialProgressionPsychometricFun('time_in_feeder_25', ...
    'P2L1 Post alcohol');
[p, tbl, stats] = kruskalWallisMultiple(T1(:,1), T2(:,1), T3(:,1), T4(:,1));
[p, tbl, stats] = kruskalWallisMultiple(T1(:,2), T2(:,2), T3(:,2), T4(:,2));


%% L1 vs L3 
[T1, T2] = masterPsychometricFunctionPlot('approachavoid', {}, ...
'P2L1L3 Baseline L1', 'P2L1L3 Baseline L3');
[T3, T4] = masterPsychometricFunctionPlot('approachavoid', {}, ...
'P2L1L3 Boost and alcohol L1','P2L1L3 Boost and alcohol L3');

% Compute means
mean_T1 = mean(T1(:));
mean_T2 = mean(T2(:));

% Compute standard errors
se_T1 = std(T1(:)) / sqrt(numel(T1(:)));
se_T2 = std(T2(:)) / sqrt(numel(T2(:)));

% Compute mean difference and its standard error
diff_1 = mean_T2 - mean_T1;
se_diff_1 = sqrt(se_T1^2 + se_T2^2);  % Standard error of the difference

mean_T3 = mean(T3(:));
mean_T4 = mean(T4(:));

se_T3 = std(T3(:)) / sqrt(numel(T3(:)));
se_T4 = std(T4(:)) / sqrt(numel(T4(:)));

diff_2 = mean_T4 - mean_T3;
se_diff_2 = sqrt(se_T3^2 + se_T4^2);  % Standard error of the difference

% Create bar plot
figure;
bar_handle = bar(1:2, [diff_1, diff_2]);
hold on;
% Add error bars
errorbar(1:2, [diff_1, diff_2], [se_diff_1, se_diff_2], 'k', 'linestyle', ...
    'none', 'linewidth', 1.5);

hold off;

% Statistics
mean_T1_sessions = mean(T1, 2); % Mean across columns (concentrations)
mean_T2_sessions = mean(T2, 2);
mean_T3_sessions = mean(T3, 2);
mean_T4_sessions = mean(T4, 2);

% Compute difference within each group
diff_baseline = mean_T2_sessions - mean(mean_T1_sessions); % Baseline difference
diff_alcohol = mean_T4_sessions - mean(mean_T3_sessions);  % Alcohol difference

% Perform Wilcoxon rank-sum test
p_diff = ranksum(diff_baseline, diff_alcohol);

% Display results
disp(['p-value for group difference: ', num2str(p_diff)]);


%% Session number comparison between male and female
session_label = {'NCCB', 'CCB', 'AA', 'PNC', 'PC', 'NCPA', 'CPA'};
male_session = [54,63,77,51,30,30,34]; 
female_session = [61,62,81,64,26,30,17];
p = chi2test([male_session; female_session]);
figure;
male_labels = strcat(session_label, " (", string(male_session), ")");
pie(male_session, male_labels); title("Male");
figure;
female_labels = strcat(session_label, " (", string(female_session), ")");
pie(female_session, female_labels); title("Female");

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

figure;
male_labels = strcat(session_label, " (", ...
    string(round(trial_per_session_male)), ")");
pie(trial_per_session_male, male_labels); title("Male");
figure;
female_labels = strcat(session_label, " (", ...
    string(round(trial_per_session_female)), ")");
pie(trial_per_session_female, female_labels); title("Female");


chi2test([trial_per_session_male; trial_per_session_female]);


%% Cognitive deficit
[T1, T2, T3] = sessionProgressionPsychometricFun('distance_until_limiting_time_stamp', ...
    'P2A Boost and alcohol', 'y');