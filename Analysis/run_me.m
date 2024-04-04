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


featureForEach = masterPsychometricFunctionPlot('distance_until_limiting_time_stamp', 'n', ...
    'P2L1 Boost','P2L1 Ghrelin','P2L1 Alcohol','P2L1 Ghr alcohol');
twoWayANOVAfun(featureForEach{:})


featureForEach = masterPsychometricFunctionPlot('time_in_feeder_25', 'n', ...
    'P2L1 Boost','P2L1 Ghrelin','P2L1 Alcohol','P2L1 Ghr alcohol');
twoWayANOVAfun(featureForEach{:})

featureForEach = masterPsychometricFunctionPlot('approachavoid', 'n', ...
    'P2L1L3 Boost','P2L1L3 Ghrelin','P2L1L3 Alcohol','P2L1L3 Ghr alcohol');
twoWayANOVAfun(featureForEach{:})

featureForEach = masterPsychometricFunctionPlot('distance_until_limiting_time_stamp', 'n', ...
    'P2L1L3 Boost','P2L1L3 Ghrelin','P2L1L3 Alcohol','P2L1L3 Ghr alcohol');
twoWayANOVAfun(featureForEach{:})

featureForEach = masterPsychometricFunctionPlot('time_in_feeder_25', 'n', ...
    'P2L1L3 Boost','P2L1L3 Ghrelin','P2L1L3 Alcohol','P2L1L3 Ghr alcohol');
twoWayANOVAfun(featureForEach{:})

[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'approachavoid', 'y', ...
    'P2L1 Boost','P2L1 Ghrelin','P2L1 Alcohol','P2L1 Ghr alcohol');
twoWayANOVAfun(featureForEachMale{:})
twoWayANOVAfun(featureForEachFemale{:})

[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'distance_until_limiting_time_stamp', 'y', ...
    'P2L1 Boost','P2L1 Ghrelin','P2L1 Alcohol','P2L1 Ghr alcohol');
twoWayANOVAfun(featureForEachMale{:})
twoWayANOVAfun(featureForEachFemale{:})

[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'time_in_feeder_25', 'y', ...
    'P2L1 Boost','P2L1 Ghrelin','P2L1 Alcohol','P2L1 Ghr alcohol');
twoWayANOVAfun(featureForEachMale{:})
twoWayANOVAfun(featureForEachFemale{:})

[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'approachavoid', 'y', ...
    'P2L1L3 Boost','P2L1L3 Ghrelin','P2L1L3 Alcohol','P2L1L3 Ghr alcohol');
twoWayANOVAfun(featureForEachMale{:})
twoWayANOVAfun(featureForEachFemale{:})

[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'distance_until_limiting_time_stamp', 'y', ...
    'P2L1L3 Boost','P2L1L3 Ghrelin','P2L1L3 Alcohol','P2L1L3 Ghr alcohol');
twoWayANOVAfun(featureForEachMale{:})
twoWayANOVAfun(featureForEachFemale{:})

[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'time_in_feeder_25', 'y', ...
    'P2L1L3 Boost','P2L1L3 Ghrelin','P2L1L3 Alcohol','P2L1L3 Ghr alcohol');
twoWayANOVAfun(featureForEachMale{:})
twoWayANOVAfun(featureForEachFemale{:})



