% Author: Atanu Giri
% Date: 02/15/2024

fig_directory = '/Users/atanugiri/Downloads/Alcohol Project/Analysis/Fig files/';

%% Figure 1
% Psychometric plots of individual sessions 
individualPsychometricPlotOverlay('approachavoid', 'n', 'P2L1 BL for comb boost and alc');
individualPsychometricPlotOverlay('approachavoid', 'n', 'P2L1L3 BL for comb boost and alc');
individualPsychometricPlotOverlay('approachavoid', 'n', 'P2A Boost and alcohol');

% Sigmoid fitting
extractFittingParam("P2L1 BL for comb boost and alc", "approachavoid", 2);

% Shift of inflection point observed in conflict task
param_array = fitParamKernelDensity('shift', 'approachavoid', 2, 'n', ...
    'P2L1 BL for comb boost and alc', 'P2A Boost and alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000);

param_array = fitParamKernelDensity('shift', 'approachavoid', 2, 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2A Boost and alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000);

% Increased approach rate during conflict task
featureForEach = masterFunForBoxPlot('approachavoid', 'n', ...
    'P2L1 BL for comb boost and alc','P2A Boost and alcohol');
T1 = featureForEach{1};
T2 = featureForEach{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

featureForEach = masterFunForBoxPlot('approachavoid', 'n', ...
    'P2L1L3 BL for comb boost and alc','P2A Boost and alcohol');
T1 = featureForEach{1};
T2 = featureForEach{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

% Variance in approach rate accross groups
data = varianceAnalysis('approachavoid', 'n', 'P2L1 BL for comb boost and alc', ...
    'P2A Boost and alcohol');
% Initialize p-values matrix
[numRows1, numCols] = size(data{1});
[numRows2, ~] = size(data{2});
p_values = zeros(1, numCols);

% Perform F-test for each column
for j = 1:numCols
    [~, p_values(j)] = vartest2(data{1}(:, j), data{2}(:, j));
end

% Combine p-values using Fisher's method
chi2_stat = -2 * sum(log(p_values));
combined_p = 1 - chi2cdf(chi2_stat, 2 * length(p_values));

fprintf('Combined p-value from Fisher''s method: %0.4f\n', combined_p);


data = varianceAnalysis('approachavoid', 'n', 'P2L1L3 BL for comb boost and alc', ...
    'P2A Boost and alcohol');
% Initialize p-values matrix
[numRows1, numCols] = size(data{1});
[numRows2, ~] = size(data{2});
p_values = zeros(1, numCols);

% Perform F-test for each column
for j = 1:numCols
    [~, p_values(j)] = vartest2(data{1}(:, j), data{2}(:, j));
end

% Combine p-values using Fisher's method
chi2_stat = -2 * sum(log(p_values));
combined_p = 1 - chi2cdf(chi2_stat, 2 * length(p_values));

fprintf('Combined p-value from Fisher''s method: %0.4f\n', combined_p);


%% Figure 2
% Gender-specific psychometric plots of individual sessions
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1 BL for comb boost and alc');
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2A Boost and alcohol');

% Inflection pointshift observed in males
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'approachavoid', 2, 'y', ...
    'P2L1 BL for comb boost and alc', 'P2A Boost and alcohol');

[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000);
[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000);

% AA influencesapproach rate in males
[featureForEachMale, featureForEachFemale] = masterFunForBoxPlot( ...
    'approachavoid', 'y', 'P2L1 BL for comb boost and alc','P2A Boost and alcohol');

T1 = featureForEachMale{1};
T2 = featureForEachMale{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

T1 = featureForEachFemale{1};
T2 = featureForEachFemale{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

% Unchanged variance in approach rates
[maleData,femaleData] = varianceAnalysis('approachavoid', 'y', ...
    'P2L1 BL for comb boost and alc', 'P2A Boost and alcohol');
% Initialize p-values matrix
[numRows1, numCols] = size(maleData{1});
[numRows2, ~] = size(maleData{2});
p_values = zeros(1, numCols);

% Perform F-test for each column
for j = 1:numCols
    [~, p_values(j)] = vartest2(maleData{1}(:, j), maleData{2}(:, j));
end

% Combine p-values using Fisher's method
chi2_stat = -2 * sum(log(p_values));
combined_p = 1 - chi2cdf(chi2_stat, 2 * length(p_values));

fprintf('Combined p-value from Fisher''s method: %0.4f\n', combined_p);

% Initialize p-values matrix
[numRows1, numCols] = size(femaleData{1});
[numRows2, ~] = size(femaleData{2});
p_values = zeros(1, numCols);

% Perform F-test for each column
for j = 1:numCols
    [~, p_values(j)] = vartest2(femaleData{1}(:, j), femaleData{2}(:, j));
end

% Combine p-values using Fisher's method
chi2_stat = -2 * sum(log(p_values));
combined_p = 1 - chi2cdf(chi2_stat, 2 * length(p_values));

fprintf('Combined p-value from Fisher''s method: %0.4f\n', combined_p);

% Gender-specificpsychometric plots
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1L3 BL for comb boost and alc');

% Inflection pointshift observed in males
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'approachavoid', 2, 'y', ...
    'P2L1L3 BL for comb boost and alc', 'P2A Boost and alcohol');

[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000);
[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000);

% AA exerts stronger influenceon male approach rate
[featureForEachMale, featureForEachFemale] = masterFunForBoxPlot( ...
    'approachavoid', 'y', 'P2L1L3 BL for comb boost and alc','P2A Boost and alcohol');

T1 = featureForEachMale{1};
T2 = featureForEachMale{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

T1 = featureForEachFemale{1};
T2 = featureForEachFemale{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

% Males exhibitvariance change
[maleData,femaleData] = varianceAnalysis('approachavoid', 'y', ...
    'P2L1L3 BL for comb boost and alc', 'P2A Boost and alcohol');
% Initialize p-values matrix
[numRows1, numCols] = size(maleData{1});
[numRows2, ~] = size(maleData{2});
p_values = zeros(1, numCols);

% Perform F-test for each column
for j = 1:numCols
    [~, p_values(j)] = vartest2(maleData{1}(:, j), maleData{2}(:, j));
end

% Combine p-values using Fisher's method
chi2_stat = -2 * sum(log(p_values));
combined_p = 1 - chi2cdf(chi2_stat, 2 * length(p_values));

fprintf('Combined p-value from Fisher''s method: %0.4f\n', combined_p);

% Initialize p-values matrix
[numRows1, numCols] = size(femaleData{1});
[numRows2, ~] = size(femaleData{2});
p_values = zeros(1, numCols);

% Perform F-test for each column
for j = 1:numCols
    [~, p_values(j)] = vartest2(femaleData{1}(:, j), femaleData{2}(:, j));
end

% Combine p-values using Fisher's method
chi2_stat = -2 * sum(log(p_values));
combined_p = 1 - chi2cdf(chi2_stat, 2 * length(p_values));

fprintf('Combined p-value from Fisher''s method: %0.4f\n', combined_p);


%% Figure 3
% Sample plots illustrating time in reward zone
trajectoryPlot(77530);
trajectoryPlot(77401);

% Enhanced impact notedduring conflict task
featureForEach = masterPsychometricFunctionPlot('time_in_feeder_25', 'n', ...
    'P2L1 BL for comb boost and alc','P2A Boost and alcohol');
T1 = featureForEach{1};
T2 = featureForEach{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

featureForEach = masterPsychometricFunctionPlot('time_in_feeder_25', 'n', ...
    'P2L1L3 BL for comb boost and alc','P2A Boost and alcohol');
T1 = featureForEach{1};
T2 = featureForEach{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

% Shift in inflection pointis observed in both tasks
param_array = fitParamKernelDensity('shift', 'time_in_feeder_25', 2, 'n', ...
    'P2L1 BL for comb boost and alc', 'P2A Boost and alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000);

param_array = fitParamKernelDensity('shift', 'time_in_feeder_25', 2, 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2A Boost and alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000);

% AA influences time feature in males
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'time_in_feeder_25', 'y', 'P2L1 BL for comb boost and alc','P2A Boost and alcohol');

T1 = featureForEachMale{1};
T2 = featureForEachMale{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

T1 = featureForEachFemale{1};
T2 = featureForEachFemale{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

% Shift of inflection pointobserved in males
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'time_in_feeder_25', ...
    2, 'y', 'P2L1 BL for comb boost and alc', 'P2A Boost and alcohol');

[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000);
[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000);

% AA influencestime in feeder in males
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'time_in_feeder_25', 'y', 'P2L1L3 BL for comb boost and alc','P2A Boost and alcohol');

T1 = featureForEachMale{1};
T2 = featureForEachMale{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

T1 = featureForEachFemale{1};
T2 = featureForEachFemale{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

% Shift of inflection pointstronger in males
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'time_in_feeder_25', ...
    2, 'y', 'P2L1L3 BL for comb boost and alc', 'P2A Boost and alcohol');

[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000);
[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000);


%% Figure 4
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


%% Figure 5
% Psychometric plots of individual sessions
individualPsychometricPlotOverlay('approachavoid', 'n', 'P2L1 Boost and alcohol');
individualPsychometricPlotOverlay('approachavoid', 'n', 'P2L1L3 Boost and alcohol');

individualPsychometricPlotOverlay('approachavoid', 'n', 'P2L1 Post alcohol');
individualPsychometricPlotOverlay('approachavoid', 'n', 'P2L1L3 Post alcohol');

% Shift of inflection pointobserved only in PC
param_array = fitParamKernelDensity('shift', 'approachavoid', 2, 'n', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000);

param_array = fitParamKernelDensity('shift', 'approachavoid', 2, 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000);

% Greater influence onapproach rate in conflict task
featureForEach = masterPsychometricFunctionPlot('approachavoid', 'n', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
T1 = featureForEach{1};
T2 = featureForEach{2};
T3 = featureForEach{3};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

data = [T1; T3];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T3'}, size(T3,1), 1)];
[d, p, stats] = manova1(data, group);

featureForEach = masterPsychometricFunctionPlot('approachavoid', 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
T1 = featureForEach{1};
T2 = featureForEach{2};
T3 = featureForEach{3};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

data = [T1; T3];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T3'}, size(T3,1), 1)];
[d, p, stats] = manova1(data, group);

% Conflict task exhibits greater variance change
data = varianceAnalysis('approachavoid', 'n', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
% Initialize p-values matrix
[numRows1, numCols] = size(data{1});
[numRows2, ~] = size(data{2});
p_values = zeros(1, numCols);

% Perform F-test for each column
for j = 1:numCols
    [~, p_values(j)] = vartest2(data{1}(:, j), data{2}(:, j));
end

% Combine p-values using Fisher's method
chi2_stat = -2 * sum(log(p_values));
combined_p = 1 - chi2cdf(chi2_stat, 2 * length(p_values));

fprintf('Combined p-value from Fisher''s method: %0.4f\n', combined_p);

% Initialize p-values matrix
[numRows3, ~] = size(data{3});
p_values = zeros(1, numCols);

% Perform F-test for each column
for j = 1:numCols
    [~, p_values(j)] = vartest2(data{1}(:, j), data{3}(:, j));
end

% Combine p-values using Fisher's method
chi2_stat = -2 * sum(log(p_values));
combined_p = 1 - chi2cdf(chi2_stat, 2 * length(p_values));

fprintf('Combined p-value from Fisher''s method: %0.4f\n', combined_p);

data = varianceAnalysis('approachavoid', 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
% Initialize p-values matrix
[numRows1, numCols] = size(data{1});
[numRows2, ~] = size(data{2});
p_values = zeros(1, numCols);

% Perform F-test for each column
for j = 1:numCols
    [~, p_values(j)] = vartest2(data{1}(:, j), data{2}(:, j));
end

% Combine p-values using Fisher's method
chi2_stat = -2 * sum(log(p_values));
combined_p = 1 - chi2cdf(chi2_stat, 2 * length(p_values));

fprintf('Combined p-value from Fisher''s method: %0.4f\n', combined_p);

% Initialize p-values matrix
[numRows3, ~] = size(data{3});
p_values = zeros(1, numCols);

% Perform F-test for each column
for j = 1:numCols
    [~, p_values(j)] = vartest2(data{1}(:, j), data{3}(:, j));
end

% Combine p-values using Fisher's method
chi2_stat = -2 * sum(log(p_values));
combined_p = 1 - chi2cdf(chi2_stat, 2 * length(p_values));

fprintf('Combined p-value from Fisher''s method: %0.4f\n', combined_p);


%% Figure 6
% Gender-specific psychometric plots of individual sessions
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1 Boost and alcohol');
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1 Post alcohol');

% Shift of inflection pointis not affected
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'approachavoid', 2, 'y', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
[h_male1, p_male1] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000);
[h_male2, p_male2] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000);

[h_female1, p_female1] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000);
[h_female2, p_female2] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000);

% PNC influences approach rate in males
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot('approachavoid', 'y', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
T1 = featureForEachMale{1};
T2 = featureForEachMale{2};
T3 = featureForEachMale{3};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

data = [T1; T3];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T3'}, size(T3,1), 1)];
[d, p, stats] = manova1(data, group);

T1 = featureForEachFemale{1};
T2 = featureForEachFemale{2};
T3 = featureForEachFemale{3};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

data = [T1; T3];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T3'}, size(T3,1), 1)];
[d, p, stats] = manova1(data, group);

% Slight variance change observed for both genders
[maleData,femaleData] = varianceAnalysis('approachavoid', 'y', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
% Initialize p-values matrix
[numRows1, numCols] = size(maleData{1});
[numRows2, ~] = size(maleData{2});

p_values = zeros(1, numCols);

% Perform F-test for each column
for j = 1:numCols
    [~, p_values(j)] = vartest2(maleData{1}(:, j), maleData{2}(:, j));
end

% Combine p-values using Fisher's method
chi2_stat = -2 * sum(log(p_values));
combined_p = 1 - chi2cdf(chi2_stat, 2 * length(p_values));

% Initialize p-values matrix
[numRows3, ~] = size(maleData{3});
p_values = zeros(1, numCols);

% Perform F-test for each column
for j = 1:numCols
    [~, p_values(j)] = vartest2(maleData{1}(:, j), maleData{3}(:, j));
end

% Combine p-values using Fisher's method
chi2_stat = -2 * sum(log(p_values));
combined_p = 1 - chi2cdf(chi2_stat, 2 * length(p_values));

% Gender-specific psychometric plots of individual sessions
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1L3 Boost and alcohol');
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1L3 Post alcohol');

% Shift of inflection pointstronger in males
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'approachavoid', 2, 'y', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
[h_male1, p_male1] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000);
[h_male2, p_male2] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000);

[h_female1, p_female1] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000);
[h_female2, p_female2] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000);

% Greater influence on maleapproach rate in PC task
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot('approachavoid', 'y', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
T1 = featureForEachMale{1};
T2 = featureForEachMale{2};
T3 = featureForEachMale{3};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

data = [T1; T3];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T3'}, size(T3,1), 1)];
[d, p, stats] = manova1(data, group);

T1 = featureForEachFemale{1};
T2 = featureForEachFemale{2};
T3 = featureForEachFemale{3};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

data = [T1; T3];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T3'}, size(T3,1), 1)];
[d, p, stats] = manova1(data, group);

% Strong variance change observed in males


%% Figure 7
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


%% SI 1
% Psychometric mean analysisof approach rate
featureForEach = masterPsychometricFunctionPlot('approachavoid', 'n', ...
    'P2L1 BL for comb boost and alc','P2A Boost and alcohol');
T1 = featureForEach{1};
T2 = featureForEach{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

% Gender-specific psychometric meananalysis
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'approachavoid', 'y', 'P2L1 BL for comb boost and alc','P2A Boost and alcohol');

T1 = featureForEachMale{1};
T2 = featureForEachMale{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

T1 = featureForEachFemale{1};
T2 = featureForEachFemale{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

% Psychometric mean analysisof approach rate
featureForEach = masterPsychometricFunctionPlot('approachavoid', 'n', ...
    'P2L1L3 BL for comb boost and alc','P2A Boost and alcohol');
T1 = featureForEach{1};
T2 = featureForEach{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

% Gender-specific psychometric meananalysis
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'approachavoid', 'y', 'P2L1L3 BL for comb boost and alc','P2A Boost and alcohol');

T1 = featureForEachMale{1};
T2 = featureForEachMale{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

T1 = featureForEachFemale{1};
T2 = featureForEachFemale{2};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);


%% SI 2
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


%% SI 3
%
featureForEach = masterPsychometricFunctionPlot('time_in_feeder_25', 'n', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
T1 = featureForEach{1};
T2 = featureForEach{2};
T3 = featureForEach{3};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

data = [T1; T3];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T3'}, size(T3,1), 1)];
[d, p, stats] = manova1(data, group);

featureForEach = masterPsychometricFunctionPlot('time_in_feeder_25', 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
T1 = featureForEach{1};
T2 = featureForEach{2};
T3 = featureForEach{3};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

data = [T1; T3];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T3'}, size(T3,1), 1)];
[d, p, stats] = manova1(data, group);

% 
param_array = fitParamKernelDensity('shift', 'time_in_feeder_25', 2, 'n', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000);

param_array = fitParamKernelDensity('shift', 'time_in_feeder_25', 2, 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000);

%
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot('time_in_feeder_25', ...
    'y', 'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
T1 = featureForEachMale{1};
T2 = featureForEachMale{2};
T3 = featureForEachMale{3};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

data = [T1; T3];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T3'}, size(T3,1), 1)];
[d, p, stats] = manova1(data, group);

T1 = featureForEachFemale{1};
T2 = featureForEachFemale{2};
T3 = featureForEachFemale{3};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

data = [T1; T3];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T3'}, size(T3,1), 1)];
[d, p, stats] = manova1(data, group);

% 
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'time_in_feeder_25', 2, 'y', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
[h_male1, p_male1] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000);
[h_male2, p_male2] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000);

[h_female1, p_female1] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000);
[h_female2, p_female2] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000);

%
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot('time_in_feeder_25', ...
    'y', 'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
T1 = featureForEachMale{1};
T2 = featureForEachMale{2};
T3 = featureForEachMale{3};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

data = [T1; T3];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T3'}, size(T3,1), 1)];
[d, p, stats] = manova1(data, group);

T1 = featureForEachFemale{1};
T2 = featureForEachFemale{2};
T3 = featureForEachFemale{3};
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);

data = [T1; T3];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T3'}, size(T3,1), 1)];
[d, p, stats] = manova1(data, group);

% 
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'time_in_feeder_25', 2, 'y', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
[h_male1, p_male1] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000);
[h_male2, p_male2] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000);

[h_female1, p_female1] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000);
[h_female2, p_female2] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000);

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