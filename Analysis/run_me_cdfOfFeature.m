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

[h, figname] = cdfOfFeature('acc_outlier_move_median', ...
    'Alcohol BL', 'Alcohol', 'Boost');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('stoppingpts_per_unittravel_method6', ...
    'Alcohol BL', 'Alcohol', 'Boost');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('rotationpts_per_unittravel_method4', ...
    'Alcohol BL', 'Alcohol', 'Boost');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

%%
[h, figname] = cdfOfFeature('distance_until_limiting_time_stamp', ...
    'P2L1 Saline', 'P2L1 Ghrelin', 'Alcohol');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('entry_time_25', ...
    'P2L1 Saline', 'P2L1 Ghrelin', 'Alcohol');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('acc_outlier_move_median', ...
    'P2L1 Saline', 'P2L1 Ghrelin', 'Alcohol');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('stoppingpts_per_unittravel_method6', ...
    'P2L1 Saline', 'P2L1 Ghrelin', 'Alcohol');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('rotationpts_per_unittravel_method4', ...
    'P2L1 Saline', 'P2L1 Ghrelin', 'Alcohol');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

%% 
[h, figname] = cdfOfFeature('distance_until_limiting_time_stamp', ...
    'P2L1 Saline', 'Alcohol', 'Sal alcohol');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('entry_time_25', ...
    'P2L1 Saline', 'Alcohol', 'Sal alcohol');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('acc_outlier_move_median', ...
    'P2L1 Saline', 'Alcohol', 'Sal alcohol');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('stoppingpts_per_unittravel_method6', ...
    'P2L1 Saline', 'Alcohol', 'Sal alcohol');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('rotationpts_per_unittravel_method4', ...
    'P2L1 Saline', 'Alcohol', 'Sal alcohol');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

%% 
[h, figname] = cdfOfFeature('distance_until_limiting_time_stamp', ...
    'P2L1 Ghrelin', 'Alcohol', 'Ghr alcohol', 'Alcohol bl', 'Boost');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('entry_time_25', ...
    'P2L1 Ghrelin', 'Alcohol', 'Ghr alcohol', 'Alcohol bl', 'Boost');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('acc_outlier_move_median', ...
    'P2L1 Ghrelin', 'Alcohol', 'Ghr alcohol', 'Alcohol bl', 'Boost');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('stoppingpts_per_unittravel_method6', ...
    'P2L1 Ghrelin', 'Alcohol', 'Ghr alcohol', 'Alcohol bl', 'Boost');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

[h, figname] = cdfOfFeature('rotationpts_per_unittravel_method4', ...
    'P2L1 Ghrelin', 'Alcohol', 'ghr alcohol', 'Alcohol bl', 'Boost');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);

%% 
[h, figname] = cdfOfFeatureByGender('distance_until_limiting_time_stamp', ...
    'P2L1 Ghrelin', 'Alcohol', 'Ghr alcohol', 'Alcohol bl', 'Boost');
savefig(h, fullfile(fig_directory, sprintf('%s.fig',figname)));
close(h);