% Author: Atanu Giri
% Date: 03/15/2024

[featureForEachMale, featureForEachFemale] = masterPsychometricFunctionPlot( ...
    'distance_until_limiting_time_stamp', 'y', 'P2L1 Saline', 'P2L1 Ghrelin');


controlMale = featureForEachMale{1};
treatmentMale = featureForEachMale{2};

controlFemale = featureForEachFemale{1};
treatmentFemale = featureForEachFemale{2};

% Perform 2-way ANOVA for male
responseDataMale = vertcat(controlMale, treatmentMale);
groupMale = [repmat({'Control'}, size(controlMale, 1), size(controlMale, 2)); ...
    repmat({'Treatment'}, size(treatmentMale, 1), size(treatmentMale, 2))];
concMale = repelem(1:4, (size(controlMale, 1) + size(treatmentMale, 1)), 1);

[p_male, tbl_male] = anovan(responseDataMale(:), {groupMale(:), concMale(:)}, ...
    'varnames', {'group', 'concentration'}, 'model', 2, 'display', 'off');

anovaTableMale = cell2table(tbl_male);

% Perform 2-way ANOVA for female
responseDataFemale = vertcat(controlFemale, treatmentFemale);
groupFemale = [repmat({'Control'}, size(controlFemale, 1), size(controlFemale, 2)); ...
    repmat({'Treatment'}, size(treatmentFemale, 1), size(treatmentFemale, 2))];
concFemale = repelem(1:4, (size(controlFemale, 1) + size(controlFemale, 1)), 1);

[p_female, tbl_female] = anovan(responseDataFemale(:), {groupFemale(:), concFemale(:)}, ...
    'varnames', {'group', 'concentration'}, 'model', 2, 'display', 'off');

anovaTableFemale = cell2table(tbl_female);

% Print text
sprintf("Male control vs treatment = %.4e\n", p_male)
sprintf("Male control vs treatment = %.4e\n", p_female)

