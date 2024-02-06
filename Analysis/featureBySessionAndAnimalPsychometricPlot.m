% Author: Atanu Giri
% Date: 11/14/2023

% function featureBySessionAndAnimalPsychometricPlot(feature)
%
% This function returns psychometric plot of a feature for each session and
% animal
%
feature = 'passing_center_40';
clc;
mergedTable = fetchGhrelinData(feature);

ghrToyratData = mergedTable(mergedTable.tasktypedone == 'ghr toyrat', :);
salToyratData = mergedTable(mergedTable.tasktypedone == 'sal toyrat', :);

%% Ghrelin, saline plot
myPlot(salToyratData, feature);
% myPlot(ghrToyratData, feature);


%% Description of myPlot
function myPlot(dataTable, feature)
% dataTable = ghrToyratData; % For testing
sessionList = unique(dataTable.referencetime);
for session = 1:length(sessionList)
    sessionData = dataTable(dataTable.referencetime == sessionList(session),:);
    if isequal(feature, 'passing_center_25')
        tf = isnan(sessionData.(feature));
        sessionData.(feature)(tf) = 1;
    end

    animalList = unique(sessionData.subjectid);

    figure(session);
    set(gcf, 'Windowstyle', 'docked');

    for animal = 1:length(animalList)
        animalData = sessionData(sessionData.subjectid ...
            == animalList(animal),:);
        [featureForEach, noOfTrials] = psychometricFunValues(animalData, feature);
        columns = ceil(length(animalList)/2);
        subplot(2,columns,animal);
        x = 1:4;
        plot(x, featureForEach, 'LineWidth', 2);
        hold on;
        ylabel(sprintf('%s', feature), 'Interpreter','none');
        label = [0.5 "" 2 "" 5 "" 9];
        set(gca,'xticklabel',label,'FontSize',15);
        title(sprintf('%s. %d, %d, %d, %d', animalList(animal), ...
            noOfTrials(1), noOfTrials(2), noOfTrials(3), noOfTrials(4)));
        sgtitle(sprintf('Toyrat: %s', sessionList(session)));

    end % End of animal 1
hold off;

end % End of session 1

end % End of myPlot


%% Description of psychometricFunValues
function [featureForEach, noOfTrials] = psychometricFunValues(dataTable, feature)
% dataTable = animalData; % For testing
featureForEach = zeros(1, 4);
noOfTrials = zeros(1,4);

for conc = 1:4
    feederToFetch = 5 - conc;
    dataFilter = dataTable.realFeederId == feederToFetch;
    featureArray = dataTable.(feature)(dataFilter, :);
    featureArray = featureArray(isfinite(featureArray));
    noOfTrials(conc) = length(featureArray);
    featureForEach(conc) = sum(featureArray)/length(featureArray);
end

featureForEach(isnan(featureForEach)) = 0;

end % end of psychometricFunValues
% end