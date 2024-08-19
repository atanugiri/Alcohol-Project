% Author: Atanu Giri
% Date: 02/15/2024

fig_directory = '/Users/atanugiri/Downloads/Alcohol Project/Analysis/Fig files/';

%% Figure 1
% Psychometric plots of individual sessions 
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


%% ToDo

[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'approachavoid', 'y', ...
    'P2L1 BL for comb boost and alc','P2L1 Boost and alcohol','P2L1 Post alcohol');


%% 4-param logistic fit plots
[maleParam, femaleParam] = fitParamKernelDensity('shift', 'approachavoid', 2, 'y', ...
    'P2L1 BL for comb boost and alc', 'P2L1 Boost and alcohol');




%% Chi-sqaure test on pie chart
param = {'LA', 'slope', 'shift', 'UA'};
for i = 1:numel(param)
    [ct_in_part_L1_BL, totalNonSig_L1_BL] = pieChartPlot( ...
        'P2L1 BL for comb boost and alc_approachavoid_logistic4_fitting_param.mat', param{i});

    [ct_in_part_L1_Alc, totalNonSig_L1_Alc] = pieChartPlot( ...
        'P2L1 Boost and alcohol_approachavoid_logistic4_fitting_param.mat', param{i});

    [ct_in_part_L1L3_BL, totalNonSig_L1L3_BL] = pieChartPlot( ...
        'P2L1L3 BL for comb boost and alc_approachavoid_logistic4_fitting_param.mat', param{i});

    [ct_in_part_L1L3_Alc, totalNonSig_L1L3_Alc] = pieChartPlot( ...
        'P2L1L3 Boost and alcohol_approachavoid_logistic4_fitting_param.mat', param{i});

    if i <= 1
        group_L1_BL = [ct_in_part_L1_BL, totalNonSig_L1_BL];
        group_L1_Alc = [ct_in_part_L1_Alc, totalNonSig_L1_Alc];

        group_L1L3_BL = [ct_in_part_L1L3_BL, totalNonSig_L1L3_BL];
        group_L1L3_Alc = [ct_in_part_L1L3_Alc, totalNonSig_L1L3_Alc];

    else
        group_L1_BL = [group_L1_BL, ct_in_part_L1_BL];
        group_L1_Alc = [group_L1_Alc, ct_in_part_L1_Alc];

        group_L1L3_BL = [group_L1L3_BL, ct_in_part_L1L3_BL];
        group_L1L3_Alc = [group_L1L3_Alc, ct_in_part_L1L3_Alc];

    end
end

contingencyTable = [group_L1_BL; group_L1_Alc];

% Use chi2cont from MATLAB File Exchange
[chi2, p, df] = chi2cont(contingencyTable);

% Display the results
disp('Chi-Square Statistic:');
disp(chi2);
disp('p-value:');
disp(p);


%% Variance analysis


%% Individual difference (07/26/2024)
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


%% Individual difference (07/11/2024)
% Define the male names and treatment groups
% males = {'aladdin', 'carl', 'jafar', 'jimi', 'jr', 'kobe', 'mike', 'scar', 'simba', 'sully'};
females = {'alexis', 'fiona', 'harley', 'juana', 'kryssia', 'neftali', 'raven', 'renata', 'sarah', 'shakira'};
treatmentGrps = {'P2L1 BL for comb boost and alc', 'P2L1L3 BL for comb boost and alc', ...
    'P2A Boost and alcohol'};

% Initialize a cell array to store the feature lists
featureLists = cell(numel(treatmentGrps), numel(females));

nrows = size(featureLists, 1);
ncols = size(featureLists, 2);

parfor grp = 1:nrows
    tempRow = cell(1, ncols);

    for animal = 1:ncols
        tempRow{animal} = individualPsychValuesPerSession('approachavoid', ...
            treatmentGrps{grp}, females{animal});
    end

    featureLists(grp, :) = tempRow;
end


%% Cluster for individual difference (07/17/2024)
males = {'aladdin', 'carl', 'jafar', 'jimi', 'jr', 'kobe', 'mike', 'scar', ...
    'simba', 'sully'};
% males = {'alexis', 'fiona', 'harley', 'juana', 'kryssia', 'neftali', ...
%     'raven', 'renata', 'sarah', 'shakira'};

featureList = {'LA', 'slope', 'shift', 'UA', 'Rsq'};
treatmentGroups = {'P2L1 BL for comb boost and alc_approachavoid_logistic4_fitting_param.mat', ...
    'P2A Boost and alcohol_approachavoid_logistic4_fitting_param.mat', ...
    'P2L1L3 BL for comb boost and alc_approachavoid_logistic4_fitting_param.mat'};

maleParams = cell(1, numel(treatmentGroups));
stdErrMales = cell(1, numel(treatmentGroups));

% Initialize each cell as a struct with feature names
for grp = 1:numel(treatmentGroups)
    maleParams{grp} = struct();
    stdErrMales{grp} = struct();
    for featureIdx = 1:numel(featureList)
        feature = featureList{featureIdx};
        maleParams{grp}.(feature) = [];
        stdErrMales{grp}.(feature) = [];
    end
end


for featureIdx = 1:numel(featureList)
    feature = featureList{featureIdx};
    [~, maleParam, stdErrMale] = indivAnimalParamCompPlot(feature, 'y', ...
        treatmentGroups{:});
    %     [~, ~, ~, ~, maleParam, stdErrMale] = indivAnimalParamCompPlot(feature, 'y', ...
    %         treatmentGroups{:});

    for grp = 1:numel(treatmentGroups)
        maleParams{grp}.(feature) = maleParam(:, grp);
        stdErrMales{grp}.(feature) = stdErrMale(:, grp);
    end
end

featureBiplotForIndivAnimal(featureList, males, treatmentGroups, maleParams);
