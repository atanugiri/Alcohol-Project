% Author: Atanu Giri
% Date: 02/15/2024

fig_directory = '/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Fig files/';

%% CDF plots
% [h, figname] = cdfOfFeature('distance_until_limiting_time_stamp', ...
%     'Alcohol BL', 'Alcohol', 'Boost');
% savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
% close(h);
% 
% [h, figname] = cdfOfFeature('entry_time_25', ...
%     'Alcohol BL', 'Alcohol', 'Boost');
% savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
% close(h);

%% Feature plots
featureForEach = masterPsychometricFunctionPlot('approachavoid', 'n', ...
    'P2L1 Boost','P2L1 Ghrelin','P2L1 Alcohol','P2L1 Ghr alcohol');
twoWayANOVAfun(featureForEach{:})


[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'approachavoid', 'y', ...
    'P2L1 Boost','P2L1 Ghrelin','P2L1 Alcohol','P2L1 Ghr alcohol');
twoWayANOVAfun(featureForEachMale{:})
twoWayANOVAfun(featureForEachFemale{:})


%% 4-param logistic fit plots
param_array = fitParamHistogram('shift', 'n', 'P2L1 BL for comb boost and alc_approachavoid_logistic4_fitting_param', ...
'P2L1 Boost and alcohol_approachavoid_logistic4_fitting_param');
[h, p] = kstest2(param_array{1}, param_array{2});
fprintf('p = %.4f\n', p);


[maleParam, femaleParam] = fitParamHistogram('shift', 'y', 'P2L1 BL for comb boost and alc_approachavoid_logistic4_fitting_param', ...
'P2L1 Boost and alcohol_approachavoid_logistic4_fitting_param');

[h_male, p_male] = bootstrap_kstest2(maleParam{1}, maleParam{2}, 1000);
[h_female, p_female] = kstest2(femaleParam{1}, femaleParam{2});

fprintf('Male: p = %.4f\n', p_male);
fprintf('Female: p = %.4f\n', p_female);



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

