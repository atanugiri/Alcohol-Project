% Author: Atanu Giri
% Date: 11/12/2023

% function featureBySessionPsychometricPlot(feature)
%
% This function returns psychometric plot of a feature for each session as
% an avergare of all animal in that day
%
feature = 'logical_approach_3s_20';
mergedTable = fetchGhrelinData(feature);

% Remove bad entries
mergedTable(mergedTable.subjectid == "bob" & mergedTable.referencetime == ...
    "09/12/2023",:) = [];
mergedTable(mergedTable.subjectid == "none",:) = [];

ghrToyratData = mergedTable(mergedTable.tasktypedone == 'ghr toyrat', :);
salToyratData = mergedTable(mergedTable.tasktypedone == 'sal toyrat', :);

% myPlot(ghrToyratData, feature);
myPlot(salToyratData, feature);



%% Description of myPlot
function myPlot(dataTable, feature)
% dataTable = ghrToyratData; % for testing

sessionList = unique(dataTable.referencetime);
legendLabels = cell(1, 3);

for session = 6:6 %length(sessionList)
    sessionData = dataTable(dataTable.referencetime == sessionList(session),:);
    if isequal(feature, 'passing_center_25')
        tf = isnan(sessionData.(feature));
        sessionData.(feature)(tf) = 1;
    end

    [featureForEach, avFeature, stdErr] = psychometricFunValues(sessionData, feature);

    set(gcf, 'Windowstyle', 'docked');
    x = 1:4;
    plot(x, avFeature, 'LineWidth', 2,'Color','k');
    hold on;
%     legendLabels{session - 3} = sessionList(session);
    errorbar(x,avFeature,stdErr,'LineStyle','-','LineWidth',2,'Color','k');
end % end of session 1

% legend(legendLabels);
ylim([0,1]);
ylabel(sprintf('%s', feature), "FontSize",20,"Interpreter","none");
label = [0.5 "" 2 "" 5 "" 9];
set(gca,'xticklabel',label,'TickLabelInterpreter','latex');

end % End of myPlot



%% Description of psychometricFunValues
function [featureForEach, avFeature, stdErr] = psychometricFunValues(dataTable, feature)
% dataTable = ghrToyratData(ghrToyratData.referencetime == "09/12/2023",:); % For testing

uniqueSubjectid = unique(dataTable.subjectid);
featureForEach = zeros(length(uniqueSubjectid), 4);
stdErr = zeros(1,4);

for subject = 1:length(uniqueSubjectid)
    for conc = 1:4
        feederToFetch = 5 - conc;
        dataFilter = dataTable.subjectid == uniqueSubjectid(subject) & ...
            dataTable.realFeederId == feederToFetch;
        featureArray = dataTable.(feature)(dataFilter, :);
        featureArray = featureArray(isfinite(featureArray));
        featureForEach(subject, conc) = sum(featureArray)/length(featureArray);
    end
end

if size(featureForEach,1) == 1
    avFeature = featureForEach;
else
    avFeature = mean(featureForEach,'omitnan');
end
avFeature(isnan(avFeature)) = 0;

for conc = 1:4
    stdErr(conc) = std(featureForEach(:,conc))/sqrt(length(featureForEach(:,conc)));
end

end % end of psychometricFunValues

% end