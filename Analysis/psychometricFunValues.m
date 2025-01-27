% Author: Atanu Giri
% Date: 04/12/2024
%
% This function calculates the featureForEach and related information based
% on each animal and and each session.
%
function [featureForEach, animalName, dateList, trialCt] = psychometricFunValues(dataTable, feature)

animalList = unique(dataTable.subjectid);

featureForEach = [];
animalName = [];
dateList = [];
trialCt = [];
rowToUpdate = 0;

for animal = 1:length(animalList)
    animalData =  dataTable(dataTable.subjectid == animalList(animal), :);
    sessionList = unique(animalData.referencetime);

    featureForEach = [featureForEach; zeros(length(sessionList), 4)];
    animalName = [animalName; repelem(animalList(animal), length(sessionList), 1)];
    dateList = [dateList; sessionList];
    
    for session = 1:length(sessionList)
        sessionData = animalData(animalData.referencetime == sessionList(session), :);

        rowToUpdate = rowToUpdate + 1;

        for conc = 1:4
            feederToFetch = 5 - conc;
            dataFilter = sessionData.realFeederId == feederToFetch;
            featureArray = sessionData.(feature)(dataFilter, :);
            featureArray = featureArray(isfinite(featureArray));
            featureForEach(rowToUpdate, conc) = sum(featureArray)/length(featureArray);
            trialCt(rowToUpdate, conc) = length(featureArray);
        end % end of conc 1
    end % end of session 1
end % end of animal 1

% Remove rows if there is any nan
tf = arrayfun(@(x) any(isnan(featureForEach(x, :))), 1:size(featureForEach, 1));
featureForEach(tf', :) = [];
animalName(tf', :) = [];
dateList(tf', :) = [];
trialCt(tf', :) = [];