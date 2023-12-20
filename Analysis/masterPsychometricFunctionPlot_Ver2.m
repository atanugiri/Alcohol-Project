% Author: Atanu Giri
% Date: 12/04/2023

function featureForEachSubjectId = masterPsychometricFunctionPlot_Ver2(feature)
%
% This function takes 'feature' as input from 'ghrelin_featuretable' and
% returns psychometric plot for that feature as an average of all animals
%
% feature = 'entry_time_20';
close all;

fprintf("Health types:\n");
fprintf("Sal toyrat, Ghr toyrat, Sal toystick, Ghr toystick, Sal skewer, Ghr skewer\n");
health = input("Which health type do you want to analyze? ","s");

if strcmpi(health, "Sal toyrat")
    [id, ~, ~, ~, ~, ~] = extract_health_ids;
elseif strcmpi(health, "Ghr toyrat")
    [~, id, ~, ~, ~, ~] = extract_health_ids;
elseif strcmpi(health, "Sal toystick")
    [~, ~, id, ~, ~, ~] = extract_health_ids;
elseif strcmpi(health, "Ghr toystick")
    [~, ~, ~, id, ~, ~] = extract_health_ids;
elseif strcmpi(health, "Sal skewer")
    [~, ~, ~, ~, id, ~] = extract_health_ids;
elseif strcmpi(health, "Ghr skewer")
    [~, ~, ~, ~, ~, id] = extract_health_ids;
end

% Generate the idList from the filtered data
idList = strjoin(arrayfun(@num2str, id, 'UniformOutput', false), ',');

% Extract table corresponding to idList
data = fetchHealthDataTable(feature, idList);
data(isoutlier(data.distance_until_limiting_time_stamp),:) = [];

femaleData = data(strcmpi(data.gender,"female"),:);
maleData = data(strcmpi(data.gender,"male"),:);

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
    legend(sprintf('%s', health));

elseif strcmpi(splitByGender, 'y')
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
    legend([sprintf("%s Female", "", "%s Male", "", health, health)]);
end

ylabel(sprintf('%s', feature), 'Interpreter','none');
xticks(1:4);
label = {'0.5','2','5','9'};
set(gca,'xticklabel',label,'FontSize',15);

% Save figure
figname = sprintf('%s_%s',health,string(feature));
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
