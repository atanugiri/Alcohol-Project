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