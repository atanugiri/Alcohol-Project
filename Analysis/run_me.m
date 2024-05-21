% Author: Atanu Giri
% Date: 02/15/2024

fig_directory = '/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Fig files/';

%%
[h, figname] = cdfOfFeature('distance_until_limiting_time_stamp', ...
    'Alcohol BL', 'Alcohol', 'Boost');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('entry_time_25', ...
    'Alcohol BL', 'Alcohol', 'Boost');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

%% Statistics
featureForEach = masterPsychometricFunctionPlot('approachavoid', 'n', ...
    'P2L1 Boost','P2L1 Ghrelin','P2L1 Alcohol','P2L1 Ghr alcohol');
twoWayANOVAfun(featureForEach{:})


[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'approachavoid', 'y', ...
    'P2L1 Boost','P2L1 Ghrelin','P2L1 Alcohol','P2L1 Ghr alcohol');
twoWayANOVAfun(featureForEachMale{:})
twoWayANOVAfun(featureForEachFemale{:})

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

contingencyTable = [group_L1_BL; group_L1_Alc];x

% Use chi2cont from MATLAB File Exchange
[chi2, p, df] = chi2cont(contingencyTable);

% Display the results
disp('Chi-Square Statistic:');
disp(chi2);
disp('p-value:');
disp(p);

