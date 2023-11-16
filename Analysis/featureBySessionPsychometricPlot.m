% Author: Atanu Giri
% Date: 11/12/2023

% function featureBySessionPsychometricPlot(feature)
%
% This function returns psychometric plot of a feature for each session as
% an avergare of all animal in that day
%
feature = 'approachavoid';
mergedTable = fetchGhrelinData(feature);

ghrToyratData = mergedTable(mergedTable.tasktypedone == 'ghr toyrat', :);
salToyratData = mergedTable(mergedTable.tasktypedone == 'sal toyrat', :);

uniqueGhrSession = unique(ghrToyratData.referencetime);
uniqueSalSession = unique(salToyratData.referencetime);

ghrSessionData = cell(1,5);
salSessionData = cell(1,5);

%% Ghrelin plot
for i = 1:5
    ghrSessionData{i} = ghrToyratData(ghrToyratData.referencetime == uniqueGhrSession(i),:);
    if isequal(feature, 'passing_center_25')
        tfGhr = isnan(ghrSessionData{i}.(feature));
        ghrSessionData{i}.(feature)(tfGhr) = 1;
    end

%     [featureForEach, avFeature, stdErr] = psychometricFunValues(ghrSessionData{i}, feature);
%     figure(i);
%     x = 1:4;
%     plot(x, avFeature, 'LineWidth', 2);
%     set(gcf, 'Windowstyle', 'docked');
%     title(sprintf('Ghrelin toyrat: %s', uniqueGhrSession(i)))
%     ylabel(fprintf('%s', feature));
%     label = [0.5 "" 2 "" 5 "" 9];
%     set(gca,'xticklabel',label,'TickLabelInterpreter','latex');
end

%% Saline plot
for i = 1:5
    salSessionData{i} = salToyratData(salToyratData.referencetime == uniqueSalSession(i),:);
    if isequal(feature, 'passing_center_25')
        tfSal = isnan(salSessionData{i}.(feature));
        salSessionData{i}.(feature)(tfSal) = 1;
    end

%     [featureForEach, avFeature, stdErr] = psychometricFunValues(salSessionData{i}, feature);
%     figure(5+i);
%     x = 1:4;
%     plot(x, avFeature, 'LineWidth', 2);
%     title(sprintf('Saline toyrat: %s', uniqueSalSession(i)));
%     set(gcf, 'Windowstyle', 'docked');
end

%% Description of psychometricFunValues
% function [featureForEach, avFeature, stdErr] = psychometricFunValues(dataTable, feature)
dataTable = ghrSessionData{1}; % For testing
uniqueSubjectid = unique(dataTable.subjectid);
featureForEach = zeros(length(uniqueSubjectid), 4);
stdErr = zeros(1,4);

for subject = 1:length(uniqueSubjectid)
    for conc = 1:4
        feederToFetch = 5 - conc;
        dataFilter = dataTable.subjectid == uniqueSubjectid(subject) & dataTable.feeder == feederToFetch;
        featureArray = dataTable.(feature)(dataFilter, :);
        featureArray = featureArray(isfinite(featureArray));
        featureForEach(subject, conc) = sum(featureArray)/length(featureArray);
    end
end

avFeature = mean(featureForEach, 'omitnan');
avFeature(isnan(avFeature)) = 0;

for conc = 1:4
    stdErr(conc) = std(featureForEach(:,conc))/sqrt(length(featureForEach(:,conc)));
end

% end % end of psychometricFunValues

% end