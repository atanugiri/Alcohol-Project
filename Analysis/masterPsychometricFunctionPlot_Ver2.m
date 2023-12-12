% Author: Atanu Giri
% Date: 12/04/2023

function featureForEachSubjectId = masterPsychometricFunctionPlot_Ver2(feature)
%
% This function takes 'feature' as input from 'ghrelin_featuretable' and
% returns psychometric plot for that feature as an average of all animals
%
feature = 'distance_until_limiting_time_stamp';
close all;

data = fetchGhrelinData(feature);
data(data.subjectid == "none",:) = [];
data(isoutlier(data.distance_until_limiting_time_stamp),:) = [];

data(data.subjectid == "bob" & data.referencetime == ...
    "09/12/2023",:) = []; % For toyrat experiment

otherFilter = input("Do you want to apply other filter? 'y' or 'n': ","s");

if strcmpi(otherFilter,'y')
    filterType = input("'health' or 'tasktypedone'? ","s");
    if strcmpi(filterType, 'tasktypedone')
        tasktypedoneList = unique(data.tasktypedone);
        fprintf('Unique tasktypedone:\n');
        fprintf('%s, ',tasktypedoneList);
        fprintf('\n');
        tasktypedone = input('Enter tasktypedone: ','s');
        data = data(data.tasktypedone == tasktypedone, :); % For ghr toyrat experiment

    end

end
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
    legend(sprintf('%s', tasktypedone));

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
    legend(["Female", "", "Male", ""]);
end

ylabel(sprintf('%s', feature), 'Interpreter','none');
xticks(1:4);
label = {'0.5','2','5','9'};
set(gca,'xticklabel',label,'FontSize',15);
% ylim([0,1]);





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
