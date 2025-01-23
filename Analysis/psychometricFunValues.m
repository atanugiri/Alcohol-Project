% Author: Atanu Giri
% Date: 04/12/2024
%
% This function calculates the average value, standatrd error of a 
% psychometric function based on each animal and and each session.
%

function [featureForEach, avFeature, stdErr] = psychometricFunValues(dataTable, feature)

animalList = unique(dataTable.subjectid);

featureForEach = [];
animalSession = [];
rowToUpdate = 0;

for animal = 1:length(animalList)
    animalData =  dataTable(dataTable.subjectid == animalList(animal), :);
    sessionList = unique(animalData.referencetime);

    featureForEach = [featureForEach; zeros(length(sessionList), 4)];
    animalSession = [animalSession; repelem(animalList(animal), length(sessionList), 1)];

    for session = 1:length(sessionList)
        sessionData = animalData(animalData.referencetime == sessionList(session), :);

        rowToUpdate = rowToUpdate + 1;

        for conc = 1:4
            feederToFetch = 5 - conc;
            dataFilter = sessionData.realFeederId == feederToFetch;
            featureArray = sessionData.(feature)(dataFilter, :);
            featureArray = featureArray(isfinite(featureArray));
            featureForEach(rowToUpdate, conc) = sum(featureArray)/length(featureArray);
        end % end of conc 1
    end % end of session 1
end % end of animal 1

% Remove rows if there is any nan
tf = arrayfun(@(x) any(isnan(featureForEach(x, :))), 1:size(featureForEach, 1));
featureForEach(tf', :) = [];

% Calculate average
avFeature = mean(featureForEach);

% Calculate standard error
std_dev = std(featureForEach);
stdErr = std_dev ./sqrt(size(featureForEach, 1));

end