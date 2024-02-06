% Author: Atanu Giri
% Date: 12/04/2023

function featureForEachSubjectId = masterPsychometricFunctionPlot(feature)
%
% This function takes 'feature' as input from 'ghrelin_featuretable' and
% returns psychometric plot for that feature as an average of all animals
%
feature = 'distance_until_limiting_time_stamp_old';
close all;

fprintf("Health types:\n");
fprintf("P2L1 Baseline, P2L1 Food deprivation, Initial task, Late task, P2L1 Saline, " + ...
    "P2L1 Ghrelin, P2L1L3 Saline, P2L1L3 Ghrelin, Sal toyrat, " + ...
    "Ghr toyrat, Sal toystick, Ghr toystick, Sal skewer, Ghr skewer\n");
treatment = input("Which health type do you want to analyze? ","s");


if strcmpi(treatment, "P2L1 Baseline")
    [id, ~, ~, ~] = extract_treatment_ids;
elseif strcmpi(treatment, "P2L1 Food deprivation")
    [~, id, ~, ~] = extract_treatment_ids;
elseif strcmpi(treatment, "Initial task")
    [~, ~, id, ~] = extract_treatment_ids;
elseif strcmpi(treatment, "Late task")
    [~, ~, ~, id] = extract_treatment_ids;

elseif strcmpi(treatment, "P2L1 Saline")
    [id, ~, ~, ~] = extract_sal_ghr_ids;
elseif strcmpi(treatment, "P2L1 Ghrelin")
    [~, id, ~, ~] = extract_sal_ghr_ids;
elseif strcmpi(treatment, "P2L1L3 Saline")
    [~, ~, id, ~] = extract_sal_ghr_ids;
elseif strcmpi(treatment, "P2L1L3 Ghrelin")
    [~, ~, ~, id] = extract_sal_ghr_ids;

elseif strcmpi(treatment, "Sal toyrat")
    [id, ~, ~, ~, ~, ~] = extract_toy_expt_ids;
elseif strcmpi(treatment, "Ghr toyrat")
    [~, id, ~, ~, ~, ~] = extract_toy_expt_ids;
elseif strcmpi(treatment, "Sal toystick")
    [~, ~, id, ~, ~, ~] = extract_toy_expt_ids;
elseif strcmpi(treatment, "Ghr toystick")
    [~, ~, ~, id, ~, ~] = extract_toy_expt_ids;
elseif strcmpi(treatment, "Sal skewer")
    [~, ~, ~, ~, id, ~] = extract_toy_expt_ids;
elseif strcmpi(treatment, "Ghr skewer")
    [~, ~, ~, ~, ~, id] = extract_toy_expt_ids;
end

% Generate the idList from the filtered data
idList = strjoin(arrayfun(@num2str, id, 'UniformOutput', false), ',');

% Extract table corresponding to idList
data = fetchHealthDataTable(feature, idList);
% data(isoutlier(data.distance_until_limiting_time_stamp_old),:) = [];

% Visualize histogram
histogram(data.(feature));
set(gcf,'Windowstyle', 'docked');
close(gcf);

% Plotting
x = 1:4;
figure;
hold on;

splitByGender = input("Do you want to split by gender? ('y', 'n'): ","s");

if strcmpi(splitByGender, 'n')
    [~, avFeature, stdErr] = psychometricFunValues(data, feature);
    plot(x, avFeature, 'LineWidth', 2, 'Color', 'k');
    errorbar(x,avFeature,stdErr,'LineStyle', 'none', 'LineWidth', 1.5, ...
        'CapSize', 0, 'Color','k');
    legend(sprintf('%s', treatment));

elseif strcmpi(splitByGender, 'y')
    femaleData = data(strcmpi(data.gender,"female"),:);
    maleData = data(strcmpi(data.gender,"male"),:);
    [~, avFeatureF, stdErrF] = psychometricFunValues(femaleData, feature);
    [~, avFeatureM, stdErrM] = psychometricFunValues(maleData, feature);
    avFeature = [avFeatureF; avFeatureM];
    stdErr = [stdErrF; stdErrM];
    color = ['r';'b'];
    for gender = 1:2
        plot(x, avFeature(gender,:), 'LineWidth', 2, 'Color', color(gender));
        errorbar(x, avFeature(gender,:), stdErr(gender,:),'LineStyle', ...
            'none', 'LineWidth', 1.5, 'CapSize', 0, 'Color','k');
    end
    legend([sprintf("%s Female", "", "%s Male", "", treatment, treatment)]);
end

ylabel(sprintf('%s', feature), 'Interpreter','none');
xticks(1:4);
label = {'0.5','2','5','9'};
set(gca,'xticklabel',label,'FontSize',15);

% Save figure
figname = sprintf('%s_%s',treatment,string(feature));
myPath = "/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Fig files";
savefig(gcf, fullfile(myPath, figname));




%% Description of psychometricFunValues
    function [featureForEach, avFeature, stdErr] = psychometricFunValues(dataTable, feature)
        uniqueSubjectid = unique(dataTable.subjectid);
        featureForEach = zeros(length(uniqueSubjectid), 4);
        stdErr = zeros(1,4);

        for subject = 1:length(uniqueSubjectid)
            for conc = 1:4
                feederToFetch = 5 - conc;
                dataFilter = dataTable.subjectid == uniqueSubjectid(subject) ...
                    & dataTable.realFeederId == feederToFetch;
                featureArray = dataTable.(feature)(dataFilter, :);
                featureArray = featureArray(isfinite(featureArray));
                featureForEach(subject, conc) = sum(featureArray)/length(featureArray);
            end
        end

        avFeature = mean(featureForEach);

        for conc = 1:4
            stdErr(conc) = std(featureForEach(:,conc))/sqrt(length(featureForEach(:,conc)));
        end

    end % end of psychometricFunValues

end % end of masterPsychometricFunctionPlot_Ver2
