% Author: Atanu Giri
% Date: 02/15/2024

fig_directory = '/Users/atanugiri/Downloads/Alcohol Project/Analysis/Fig files/';

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

power = estimateKStest2Power(param_array{1}, param_array{2}, 1000);
power = estimateKStest2Power(param_array{1}, param_array{3}, 1000);

% Increased approach rate during conflict task
featureForEach = masterPsychometricFunctionPlot('approachavoid', 'n', ...
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

%% Figure 2
% Gender-specific psychometric plots of individual sessions
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1 BL for comb boost and alc');
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2A Boost and alcohol');

% Inflection pointshift observed in males
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'approachavoid', 2, 'y', ...
    'P2L1 BL for comb boost and alc', 'P2A Boost and alcohol', 'P2L1 Post alcohol');

[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000, 42);
[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000, 42);
power = estimateKStest2Power(maleParam{1}, maleParam{2}, 1000);
power = estimateKStest2Power(maleParam{1}, maleParam{3}, 1000);

[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000, 42);
[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000, 42);
power = estimateKStest2Power(femaleParam{1}, femaleParam{2}, 1000);
power = estimateKStest2Power(femaleParam{1}, femaleParam{3}, 1000);

% AA influencesapproach rate in males
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'approachavoid', 'y', 'P2L1 BL for comb boost and alc','P2A Boost and alcohol', ...
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

% Unchanged variance in approach rates
[maleData,femaleData] = varianceAnalysis('approachavoid', 'y', ...
    'P2L1 BL for comb boost and alc', 'P2A Boost and alcohol', 'P2L1 Post alcohol');

[p_values, combined_p] = FisherMethod(maleData);
[p_values, combined_p] = FisherMethod(femaleData);

% Gender-specificpsychometric plots
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1L3 BL for comb boost and alc');

% Inflection pointshift observed in males
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'approachavoid', 2, 'y', ...
    'P2L1L3 BL for comb boost and alc', 'P2A Boost and alcohol', 'P2L1L3 Post alcohol');

[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000, 42);
[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000, 42);
power = estimateKStest2Power(maleParam{1}, maleParam{2}, 1000);
power = estimateKStest2Power(maleParam{1}, maleParam{3}, 1000);

[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000, 42);
[h_female, p_female] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000, 42);
power = estimateKStest2Power(femaleParam{1}, femaleParam{2}, 1000);
power = estimateKStest2Power(femaleParam{1}, femaleParam{3}, 1000);

% AA exerts stronger influenceon male approach rate
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'approachavoid', 'y', 'P2L1L3 BL for comb boost and alc','P2A Boost and alcohol', ...
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

% Males exhibitvariance change
[maleData,femaleData] = varianceAnalysis('approachavoid', 'y', ...
    'P2L1L3 BL for comb boost and alc', 'P2A Boost and alcohol', 'P2L1L3 Post alcohol');
[p_values, combined_p] = FisherMethod(maleData);
[p_values, combined_p] = FisherMethod(femaleData);

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
power = estimateKStest2Power(param_array{1}, param_array{2}, 1000);
power = estimateKStest2Power(param_array{1}, param_array{3}, 1000);

param_array = fitParamKernelDensity('shift', 'approachavoid', 2, 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
[h, p] = bootstrap_kstest2(param_array{1}, param_array{2}, 1000, 42);
[h, p] = bootstrap_kstest2(param_array{1}, param_array{3}, 1000, 42);
power = estimateKStest2Power(param_array{1}, param_array{2}, 1000);
power = estimateKStest2Power(param_array{1}, param_array{3}, 1000);

% Greater influence onapproach rate in conflict task
featureForEach = masterPsychometricFunctionPlot('approachavoid', 'n', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');

group_1_data = py.numpy.array(featureForEach{1});
group_2_data = py.numpy.array(featureForEach{2});
group_3_data = py.numpy.array(featureForEach{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
disp(result);
result = py.manovaTest.manovaTest(group_1_data, group_3_data);
disp(result);


featureForEach = masterPsychometricFunctionPlot('approachavoid', 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');

group_1_data = py.numpy.array(featureForEach{1});
group_2_data = py.numpy.array(featureForEach{2});
group_3_data = py.numpy.array(featureForEach{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
disp(result);
result = py.manovaTest.manovaTest(group_1_data, group_3_data);
disp(result);

% Conflict task exhibits greater variance change
data = varianceAnalysis('approachavoid', 'n', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');
[p_values, combined_p] = FisherMethod(data);

data = varianceAnalysis('approachavoid', 'n', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
[p_values, combined_p] = FisherMethod(data);


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
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot('approachavoid', 'y', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');

group_1_data = py.numpy.array(featureForEachMale{1});
group_2_data = py.numpy.array(featureForEachMale{2});
group_3_data = py.numpy.array(featureForEachMale{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
disp(result);
result = py.manovaTest.manovaTest(group_1_data, group_3_data);
disp(result);

group_1_data = py.numpy.array(featureForEachFemale{1});
group_2_data = py.numpy.array(featureForEachFemale{2});
group_3_data = py.numpy.array(featureForEachFemale{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
disp(result);
result = py.manovaTest.manovaTest(group_1_data, group_3_data);
disp(result);

% Slight variance change observed for both genders
[maleData,femaleData] = varianceAnalysis('approachavoid', 'y', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol', 'P2L1 Post alcohol');

[p_values, combined_p] = FisherMethod(maleData);
[p_values, combined_p] = FisherMethod(femaleData);


% Gender-specific psychometric plots of individual sessions
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1L3 Boost and alcohol');
individualPsychometricPlotOverlay('approachavoid', 'y', 'P2L1L3 Post alcohol');

% Shift of inflection pointstronger in males
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'approachavoid', 2, 'y', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');
[h_male1, p_male1] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000, 42);
[h_male2, p_male2] = bootstrap_kstest2(maleParam{1}, maleParam{3}, 1000, 42);
power = estimateKStest2Power(maleParam{1}, maleParam{2}, 1000);
power = estimateKStest2Power(maleParam{1}, maleParam{3}, 1000);

[h_female1, p_female1] = bootstrap_kstest2(femaleParam{1}, femaleParam{2}, 1000, 42);
[h_female2, p_female2] = bootstrap_kstest2(femaleParam{1}, femaleParam{3}, 1000, 42);
power = estimateKStest2Power(femaleParam{1}, femaleParam{2}, 1000);
power = estimateKStest2Power(femaleParam{1}, femaleParam{3}, 1000);

% Greater influence on maleapproach rate in PC task
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot('approachavoid', 'y', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');

group_1_data = py.numpy.array(featureForEachMale{1});
group_2_data = py.numpy.array(featureForEachMale{2});
group_3_data = py.numpy.array(featureForEachMale{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
disp(result);
result = py.manovaTest.manovaTest(group_1_data, group_3_data);
disp(result);

group_1_data = py.numpy.array(featureForEachFemale{1});
group_2_data = py.numpy.array(featureForEachFemale{2});
group_3_data = py.numpy.array(featureForEachFemale{3});
result = py.manovaTest.manovaTest(group_1_data, group_2_data);
disp(result);
result = py.manovaTest.manovaTest(group_1_data, group_3_data);
disp(result);

% Strong variance change observed in males
[maleData,femaleData] = varianceAnalysis('approachavoid', 'y', ...
    'P2L1L3 BL for comb boost and alc', 'P2L1L3 Boost and alcohol', 'P2L1L3 Post alcohol');

[p_values, combined_p] = FisherMethod(maleData);
[p_values, combined_p] = FisherMethod(femaleData);


%% SI 1
% Psychometric mean analysisof approach rate
featureForEach = masterPsychometricFunctionPlot('approachavoid', 'n', ...
    'P2L1 BL for comb boost and alc','P2A Boost and alcohol', 'P2L1 Post alcohol');

% Gender-specific psychometric meananalysis
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'approachavoid', 'y', 'P2L1 BL for comb boost and alc','P2A Boost and alcohol', ...
    'P2L1 Post alcohol');

% Psychometric mean analysisof approach rate
featureForEach = masterPsychometricFunctionPlot('approachavoid', 'n', ...
    'P2L1L3 BL for comb boost and alc','P2A Boost and alcohol', 'P2L1L3 Post alcohol');

% Gender-specific psychometric meananalysis
[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'approachavoid', 'y', 'P2L1L3 BL for comb boost and alc','P2A Boost and alcohol', ...
    'P2L1L3 Post alcohol');


%% SI 2
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