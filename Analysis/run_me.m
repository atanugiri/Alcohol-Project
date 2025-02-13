% Author: Atanu Giri
% Date: 02/15/2024

males = {'aladdin', 'carl', 'jafar', 'jimi', 'jr', 'kobe', 'mike', 'scar', ...
'simba', 'sully'};
females = {'alexis', 'fiona', 'harley', 'juana', 'kryssia', 'neftali', ...
'raven', 'renata', 'sarah', 'shakira'};

%% Figure 1
% Sigmoid fitting
extractFittingParam("P2L1 BL for comb boost and alc", "approachavoid", 2);

% Psychometric plots of individual sessions
individualPsychometricPlotOverlay('approachavoid', 'n', 'P2L1 BL for comb boost and alc');
individualPsychometricPlotOverlay('approachavoid', 'n', 'P2L1L3 BL for comb boost and alc');
individualPsychometricPlotOverlay('approachavoid', 'n', 'P2A Boost and alcohol');

% Shift of inflection point observed in conflict task
param_array = fitParamKernelDensity('shift', 'approachavoid', 2, 'n', ...
    'P2L1 BL for comb boost and alc', 'P2A Boost and alcohol', 'P2L1 Post alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000, 42);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000, 42);

% Increased approach rate during conflict task
[T1, T2, T3] = masterPsychometricFunctionPlot('approachavoid', {}, ...
    'P2L1 BL for comb boost and alc','P2A Boost and alcohol', 'P2L1 Post alcohol');

result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T2));
result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T3));


%% Figure 2
% Gender-specific psychometric plots of individual sessions
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1 BL for comb boost and alc');
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2A Boost and alcohol');

% Inflection pointshift observed in males
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'approachavoid', 2, 'y', ...
    'P2L1 BL for comb boost and alc', 'P2A Boost and alcohol', 'P2L1 Post alcohol');

[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000, 42);
[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000, 42);

[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000, 42);
[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000, 42);

% AA influencesapproach rate in males
[T1, T2, T3] = masterPsychometricFunctionPlot('approachavoid', males, ...
    'P2L1 BL for comb boost and alc','P2A Boost and alcohol', 'P2L1 Post alcohol');
result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T2));
result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T3));

[T1, T2, T3] = masterPsychometricFunctionPlot('approachavoid', females, ...
    'P2L1 BL for comb boost and alc','P2A Boost and alcohol', 'P2L1 Post alcohol');
result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T2));
result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T3));



%% Figure 3
% Psychometric plots of individual sessions
individualPsychometricPlotOverlay('approachavoid', 'n', 'P2L1 Boost and alcohol');
individualPsychometricPlotOverlay('approachavoid', 'n', 'P2L1L3 Boost and alcohol');

individualPsychometricPlotOverlay('approachavoid', 'n', 'P2L1 Post alcohol');
individualPsychometricPlotOverlay('approachavoid', 'n', 'P2L1L3 Post alcohol');

% Shift of inflection pointobserved only in PC
param_array = fitParamKernelDensity('shift', 'approachavoid', 2, 'n', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000, 42);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000, 42);

param_array = fitParamKernelDensity('shift', 'approachavoid', 2, 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000, 42);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000, 42);

% Increased approach rate during conflict task
[T1, T2, T3] = masterPsychometricFunctionPlot('approachavoid', {}, ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');

result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T2));
result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T3));

[T1, T2, T3] = masterPsychometricFunctionPlot('approachavoid', {}, ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');

result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T2));
result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T3));

% L1 vs L3 
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


%% Figure 4
% Gender-specific psychometric plots of individual sessions
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1 Boost and alcohol');
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1 Post alcohol');

% Shift of inflection pointis not affected
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'approachavoid', 2, 'y', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
[h_male1, p_male1] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000, 42);
[h_male2, p_male2] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000, 42);
power = estimateKStest2Power(maleParam{1}, maleParam{2}, 1000);
power = estimateKStest2Power(maleParam{1}, maleParam{3}, 1000);

[h_female1, p_female1] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000, 42);
[h_female2, p_female2] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000, 42);
power = estimateKStest2Power(femaleParam{1}, femaleParam{2}, 1000);
power = estimateKStest2Power(femaleParam{1}, femaleParam{3}, 1000);

% PNC influences approach rate in males
[T1, T2, T3] = masterPsychometricFunctionPlot('approachavoid', males, ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');

result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T2));
result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T3));

[T1, T2, T3] = masterPsychometricFunctionPlot('approachavoid', females, ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');

result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T2));
result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T3));

% Gender-specific psychometric plots of individual sessions
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1L3 Boost and alcohol');
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1L3 Post alcohol');

% Shift of inflection pointstronger in males
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'approachavoid', 2, 'y', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
[h_male1, p_male1] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000, 42);
[h_male2, p_male2] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000, 42);

[h_female1, p_female1] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000, 42);
[h_female2, p_female2] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000, 42);

% Greater influence on maleapproach rate in PC task
[T1, T2, T3] = masterPsychometricFunctionPlot('approachavoid', males, ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');

result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T2));
result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T3));

[T1, T2, T3] = masterPsychometricFunctionPlot('approachavoid', females, ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');

result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T2));
result = py.manovaTest.manovaTest(py.numpy.array(T1), py.numpy.array(T3));


%% SI 1
% Psychometric mean analysisof approach rate
[T1, T2, T3] = masterPsychometricFunctionPlot('approachavoid', {}, ...
    'P2L1 BL for comb boost and alc','P2A Boost and alcohol', 'P2L1 Post alcohol');

% Session number comparison between male and female
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

% Trial count
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

% Trial per session
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

% Session progression in P2A alcohol
featureForEach = sessionProgressionPsychometricFun('approachavoid', ...
'P2A Boost and alcohol', 'n', {});

% non-parametric test for small variance: Kruskal-Wallis test
group = (1:size(featureForEach, 1))'; % Group each row as a session
for col = 1:size(featureForEach, 2)
    disp(['Analyzing concentration ', num2str(col), ' using Kruskal-Wallis test']);
    p = kruskalwallis(featureForEach(:, col), group, 'off'); % Include group variable
    disp(['P-value: ', num2str(p)]);
end

% Individual p-values from the Kruskal-Wallis test
p_values = [0.42888, 0.42888, 0.42888, 0.42888];

% Fisher's combined test statistic
chi_square_stat = -2 * sum(log(p_values));

% Degrees of freedom
df = 2 * length(p_values);

% combined p-value
combined_p = 1 - chi2cdf(chi_square_stat, df);

disp(['Combined P-value using Fisher''s method: ', num2str(combined_p)]);

% Gender -specific psychometric meananalysis
[T1, T2, T3] = masterPsychometricFunctionPlot('approachavoid', males, ...
    'P2L1 BL for comb boost and alc','P2A Boost and alcohol', 'P2L1 Post alcohol');

[T1, T2, T3] = masterPsychometricFunctionPlot('approachavoid', females, ...
    'P2L1 BL for comb boost and alc','P2A Boost and alcohol', 'P2L1 Post alcohol');

individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1L3 BL for comb boost and alc');


%% SI 3
% Sample plots illustrating time in reward zone
trajectoryPlot(77530);
trajectoryPlot(77401);

% Enhanced impact notedduring conflict task
featureForEach = masterPsychometricFunctionPlot('time_in_feeder_25', 'n', ...
    'P2L1 BL for comb boost and alc','P2A Boost and alcohol', 'P2L1 Post alcohol');
group_1_data = py.numpy.array(featureForEach{1});
group_2_data = py.numpy.array(featureForEach{2});
group_3_data = py.numpy.array(featureForEach{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEach{1}, 1), size(featureForEach{2}, 1), 4, 0.05);

result = py.manovaTest.manovaTest(group_1_data, group_3_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEach{1}, 1), size(featureForEach{3}, 1), 4, 0.05);

featureForEach = masterPsychometricFunctionPlot('time_in_feeder_25', 'n', ...
    'P2L1L3 BL for comb boost and alc','P2A Boost and alcohol', 'P2L1L3 Post alcohol');
group_1_data = py.numpy.array(featureForEach{1});
group_2_data = py.numpy.array(featureForEach{2});
group_3_data = py.numpy.array(featureForEach{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEach{1}, 1), size(featureForEach{2}, 1), 4, 0.05);

result = py.manovaTest.manovaTest(group_1_data, group_3_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEach{1}, 1), size(featureForEach{3}, 1), 4, 0.05);

% Shift in inflection pointis observed in both tasks
param_array = fitParamKernelDensity('shift', 'time_in_feeder_25', 2, 'n', ...
    'P2L1 BL for comb boost and alc', 'P2A Boost and alcohol', 'P2L1 Post alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000, 42);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000, 42);

power = estimateKStest2Power(param_array{1}, param_array{2}, 1000);
power = estimateKStest2Power(param_array{1}, param_array{3}, 1000);

param_array = fitParamKernelDensity('shift', 'time_in_feeder_25', 2, 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2A Boost and alcohol', 'P2L1L3 Post alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000, 42);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000, 42);

power = estimateKStest2Power(param_array{1}, param_array{2}, 1000);
power = estimateKStest2Power(param_array{1}, param_array{3}, 1000);

% AA influences time feature in males
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'time_in_feeder_25', 'y', 'P2L1 BL for comb boost and alc','P2A Boost and alcohol', ...
    'P2L1 Post alcohol');

group_1_data = py.numpy.array(featureForEachMale{1});
group_2_data = py.numpy.array(featureForEachMale{2});
group_3_data = py.numpy.array(featureForEachMale{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachMale{1}, 1), size(featureForEachMale{2}, 1), 4, 0.05);
result = py.manovaTest.manovaTest(group_1_data, group_3_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachMale{1}, 1), size(featureForEachMale{3}, 1), 4, 0.05);

group_1_data = py.numpy.array(featureForEachFemale{1});
group_2_data = py.numpy.array(featureForEachFemale{2});
group_3_data = py.numpy.array(featureForEachFemale{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachFemale{1}, 1), size(featureForEachFemale{2}, 1), 4, 0.05);
result = py.manovaTest.manovaTest(group_1_data, group_3_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachFemale{1}, 1), size(featureForEachFemale{3}, 1), 4, 0.05);

% Shift of inflection pointobserved in males
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'time_in_feeder_25', ...
    2, 'y', 'P2L1 BL for comb boost and alc', 'P2A Boost and alcohol', 'P2L1 Post alcohol');

[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000, 42);
[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000, 42);

power = estimateKStest2Power(maleParam{1}, maleParam{2}, 1000);
power = estimateKStest2Power(maleParam{1}, maleParam{3}, 1000);

[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000, 42);
[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000, 42);

% AA influencestime in feeder in males
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'time_in_feeder_25', 'y', 'P2L1L3 BL for comb boost and alc','P2A Boost and alcohol', ...
    'P2L1L3 Post alcohol');

group_1_data = py.numpy.array(featureForEachMale{1});
group_2_data = py.numpy.array(featureForEachMale{2});
group_3_data = py.numpy.array(featureForEachMale{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachMale{1}, 1), size(featureForEachMale{2}, 1), 4, 0.05);
result = py.manovaTest.manovaTest(group_1_data, group_3_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachMale{1}, 1), size(featureForEachMale{3}, 1), 4, 0.05);

group_1_data = py.numpy.array(featureForEachFemale{1});
group_2_data = py.numpy.array(featureForEachFemale{2});
group_3_data = py.numpy.array(featureForEachFemale{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachFemale{1}, 1), size(featureForEachFemale{2}, 1), 4, 0.05);
result = py.manovaTest.manovaTest(group_1_data, group_3_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachFemale{1}, 1), size(featureForEachFemale{3}, 1), 4, 0.05);

% Shift of inflection pointstronger in males
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'time_in_feeder_25', ...
    2, 'y', 'P2L1L3 BL for comb boost and alc', 'P2A Boost and alcohol', 'P2L1L3 Post alcohol');

[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000, 42);
[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000, 42);
power = estimateKStest2Power(maleParam{1}, maleParam{2}, 1000);
power = estimateKStest2Power(maleParam{1}, maleParam{3}, 1000);

[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000, 42);
[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000, 42);
power = estimateKStest2Power(femaleParam{1}, femaleParam{2}, 1000);
power = estimateKStest2Power(femaleParam{1}, femaleParam{3}, 1000);

%% SI 3
% Psychometric profiles of a vulnerable animal: AA impact
individualPsychPlotPerSession('approachavoid', ...
    'P2L1 BL for comb boost and alc', 'sully');
individualPsychPlotPerSession('approachavoid', ...
    'P2L1L3 BL for comb boost and alc', 'sully');
individualPsychPlotPerSession('approachavoid', ...
    'P2A Boost and alcohol', 'sully');

individualPsychPlotPerSession('approachavoid', ...
    'P2L1 BL for comb boost and alc', 'shakira');
individualPsychPlotPerSession('approachavoid', ...
    'P2L1L3 BL for comb boost and alc', 'shakira');
individualPsychPlotPerSession('approachavoid', ...
    'P2A Boost and alcohol', 'shakira');

% Comparing sigmoid fractions in AA: male vs. female
[count1, total1] = calculateFractionOfSigmoid('male', 'approachavoid', 2, ...
    'P2A Boost and alcohol');
figure;
pie([count1, total1 - count1]);

[count2, total2] = calculateFractionOfSigmoid('female', 'approachavoid', 2, ...
    'P2A Boost and alcohol');
figure;
pie([count2, total2 - count2]);

p = chi2test([count1, (total1 - count1); count2, (total2 - count2)]);
power = estimateChi2Power(count1, total1, count2, total2);

%% SI 4
males = {'aladdin', 'carl', 'jafar', 'jimi', 'jr', 'kobe', 'mike', 'scar', ...
'simba', 'sully'};
females = {'alexis', 'fiona', 'harley', 'juana', 'kryssia', 'neftali', ...
'raven', 'renata', 'sarah', 'shakira'};

parfor animalIdx = 1:numel(males)
    individualPsychPlotPerSession('approachavoid', 'P2L1 BL for comb boost and alc', males{animalIdx});
    individualPsychPlotPerSession('approachavoid', 'P2L1L3 BL for comb boost and alc', males{animalIdx});
    individualPsychPlotPerSession('approachavoid', 'P2A Boost and alcohol', males{animalIdx});
end

parfor animalIdx = 1:numel(females)
    individualPsychPlotPerSession('approachavoid', 'P2L1 BL for comb boost and alc', females{animalIdx});
    individualPsychPlotPerSession('approachavoid', 'P2L1L3 BL for comb boost and alc', females{animalIdx});
    individualPsychPlotPerSession('approachavoid', 'P2A Boost and alcohol', females{animalIdx});
end

% Comparing sigmoid fractions in NCCB: male vs. female
[count1, total1] = calculateFractionOfSigmoid('male', 'approachavoid', 2, ...
    'P2L1 BL for comb boost and alc');
figure;
pie([count1, total1 - count1]);

[count2, total2] = calculateFractionOfSigmoid('female', 'approachavoid', 2, ...
    'P2L1 BL for comb boost and alc');
figure;
pie([count2, total2 - count2]);

p = chi2test([count1, (total1 - count1); count2, (total2 - count2)]);

% Comparing sigmoid fractions in CCB: male vs. female
[count1, total1] = calculateFractionOfSigmoid('male', 'approachavoid', 2, ...
    'P2L1L3 BL for comb boost and alc');
figure;
pie([count1, total1 - count1]);

[count2, total2] = calculateFractionOfSigmoid('female', 'approachavoid', 2, ...
    'P2L1L3 BL for comb boost and alc');
figure;
pie([count2, total2 - count2]);

p = chi2test([count1, (total1 - count1); count2, (total2 - count2)]);

%% SI 5
% Comparing sigmoid fractions in PNC: male vs. female
[count1, total1] = calculateFractionOfSigmoid('male', 'approachavoid', 2, ...
    'P2L1 Boost and alcohol');
figure;
pie([count1, total1 - count1]);

[count2, total2] = calculateFractionOfSigmoid('female', 'approachavoid', 2, ...
    'P2L1 Boost and alcohol');
figure;
pie([count2, total2 - count2]);

p = chi2test([count1, (total1 - count1); count2, (total2 - count2)]);
power = estimateChi2Power(count1, total1, count2, total2);

% Comparing sigmoid fractions in PC: male vs. female
[count1, total1] = calculateFractionOfSigmoid('male', 'approachavoid', 2, ...
    'P2L1L3 Boost and alcohol');
figure;
pie([count1, total1 - count1]);

[count2, total2] = calculateFractionOfSigmoid('female', 'approachavoid', 2, ...
    'P2L1L3 Boost and alcohol');
figure;
pie([count2, total2 - count2]);

p = chi2test([count1, (total1 - count1); count2, (total2 - count2)]);

%% SI 6
%
featureForEach = masterPsychometricFunctionPlot('time_in_feeder_25', 'n', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
group_1_data = py.numpy.array(featureForEach{1});
group_2_data = py.numpy.array(featureForEach{2});
group_3_data = py.numpy.array(featureForEach{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEach{1}, 1), size(featureForEach{2}, 1), 4, 0.05);

result = py.manovaTest.manovaTest(group_1_data, group_3_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEach{1}, 1), size(featureForEach{3}, 1), 4, 0.05);

featureForEach = masterPsychometricFunctionPlot('time_in_feeder_25', 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
group_1_data = py.numpy.array(featureForEach{1});
group_2_data = py.numpy.array(featureForEach{2});
group_3_data = py.numpy.array(featureForEach{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEach{1}, 1), size(featureForEach{2}, 1), 4, 0.05);

result = py.manovaTest.manovaTest(group_1_data, group_3_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEach{1}, 1), size(featureForEach{3}, 1), 4, 0.05);

% 
param_array = fitParamKernelDensity('shift', 'time_in_feeder_25', 2, 'n', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000, 42);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000, 42);
power = estimateKStest2Power(param_array{1}, param_array{2}, 1000);
power = estimateKStest2Power(param_array{1}, param_array{3}, 1000);

param_array = fitParamKernelDensity('shift', 'time_in_feeder_25', 2, 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000, 42);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000, 42);
power = estimateKStest2Power(param_array{1}, param_array{2}, 1000);
power = estimateKStest2Power(param_array{1}, param_array{3}, 1000);

%
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot('time_in_feeder_25', ...
    'y', 'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
group_1_data = py.numpy.array(featureForEachMale{1});
group_2_data = py.numpy.array(featureForEachMale{2});
group_3_data = py.numpy.array(featureForEachMale{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachMale{1}, 1), size(featureForEachMale{2}, 1), 4, 0.05);

result = py.manovaTest.manovaTest(group_1_data, group_3_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachMale{1}, 1), size(featureForEachMale{3}, 1), 4, 0.05);

group_1_data = py.numpy.array(featureForEachFemale{1});
group_2_data = py.numpy.array(featureForEachFemale{2});
group_3_data = py.numpy.array(featureForEachFemale{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachFemale{1}, 1), size(featureForEachFemale{2}, 1), 4, 0.05);

result = py.manovaTest.manovaTest(group_1_data, group_3_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachFemale{1}, 1), size(featureForEachFemale{3}, 1), 4, 0.05);

% 
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'time_in_feeder_25', 2, 'y', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
[h_male1, p_male1] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000, 42);
[h_male2, p_male2] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000, 42);

power = estimateKStest2Power(maleParam{1}, maleParam{2}, 1000);
power = estimateKStest2Power(maleParam{1}, maleParam{3}, 1000);

[h_female1, p_female1] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000, 42);
[h_female2, p_female2] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000, 42);

power = estimateKStest2Power(femaleParam{1}, femaleParam{2}, 1000);
power = estimateKStest2Power(femaleParam{1}, femaleParam{3}, 1000);

%
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot('time_in_feeder_25', ...
    'y', 'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
group_1_data = py.numpy.array(featureForEachMale{1});
group_2_data = py.numpy.array(featureForEachMale{2});
group_3_data = py.numpy.array(featureForEachMale{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachMale{1}, 1), size(featureForEachMale{2}, 1), 4, 0.05);

result = py.manovaTest.manovaTest(group_1_data, group_3_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachMale{1}, 1), size(featureForEachMale{3}, 1), 4, 0.05);

group_1_data = py.numpy.array(featureForEachFemale{1});
group_2_data = py.numpy.array(featureForEachFemale{2});
group_3_data = py.numpy.array(featureForEachFemale{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachFemale{1}, 1), size(featureForEachFemale{2}, 1), 4, 0.05);

result = py.manovaTest.manovaTest(group_1_data, group_3_data);
power = py.manova_power.compute_manova_power(result{1}, ...
    size(featureForEachFemale{1}, 1), size(featureForEachFemale{3}, 1), 4, 0.05);

% 
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'time_in_feeder_25', 2, 'y', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
[h_male1, p_male1] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000, 42);
[h_male2, p_male2] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000, 42);

power = estimateKStest2Power(maleParam{1}, maleParam{2}, 1000);
power = estimateKStest2Power(maleParam{1}, maleParam{3}, 1000);

[h_female1, p_female1] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000, 42);
[h_female2, p_female2] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000, 42);

power = estimateKStest2Power(femaleParam{1}, femaleParam{2}, 1000);
power = estimateKStest2Power(femaleParam{1}, femaleParam{3}, 1000);

% Comparing sigmoid fractions in NCPA: male vs. female
[count1, total1] = calculateFractionOfSigmoid('male', 'approachavoid', 2, ...
    'P2L1 Post alcohol');
figure;
pie([count1, total1 - count1]);

[count2, total2] = calculateFractionOfSigmoid('female', 'approachavoid', 2, ...
    'P2L1 Post alcohol');
figure;
pie([count2, total2 - count2]);

p = chi2test([count1, (total1 - count1); count2, (total2 - count2)]);

% Comparing sigmoid fractions in CPA: male vs. female
[count1, total1] = calculateFractionOfSigmoid('male', 'approachavoid', 2, ...
    'P2L1L3 Post alcohol');
figure;
pie([count1, total1 - count1]);

[count2, total2] = calculateFractionOfSigmoid('female', 'approachavoid', 2, ...
    'P2L1L3 Post alcohol');
figure;
pie([count2, total2 - count2]);

p = chi2test([count1, (total1 - count1); count2, (total2 - count2)]);