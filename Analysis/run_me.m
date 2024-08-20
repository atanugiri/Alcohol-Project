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
fprintf('p = %.4f\n', p);

param_array = fitParamKernelDensity('shift', 'approachavoid', 2, 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2A Boost and alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000);
fprintf('p = %.4f\n', p);

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

fprintf('Male: p = %.4f\n', p_male);
fprintf('Female: p = %.4f\n', p_female);

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

fprintf('Male: p = %.4f\n', p_male);
fprintf('Female: p = %.4f\n', p_female);

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
fprintf('p = %.4f\n', p);

param_array = fitParamKernelDensity('shift', 'time_in_feeder_25', 2, 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2A Boost and alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000);
fprintf('p = %.4f\n', p);

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

fprintf('Male: p = %.4f\n', p_male);
fprintf('Female: p = %.4f\n', p_female);

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

fprintf('Male: p = %.4f\n', p_male);
fprintf('Female: p = %.4f\n', p_female);


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
    'P2L1 Boost and alcohol');
figure;
pie([count1, total1 - count1]);

[count2, total2] = calculateFractionOfSigmoid('female', 'approachavoid', 2, ...
    'P2L1 Boost and alcohol');
figure;
pie([count2, total2 - count2]);

p = chi2test([count1, (total1 - count1); count2, (total2 - count2)]);
fprintf('p = %.4f\n', p);


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
fprintf('p = %.4f\n', p);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000);
fprintf('p = %.4f\n', p);

param_array = fitParamKernelDensity('shift', 'approachavoid', 2, 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000);
fprintf('p = %.4f\n', p);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000);
fprintf('p = %.4f\n', p);

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


%% Figure 4
% Gender-specific psychometric plots of individual sessions


%% ToDo
