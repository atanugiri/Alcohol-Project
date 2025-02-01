% Author: Atanu Giri
% Date: 01/19/2024
%
% This function calculates the average value of feature for each session 
% (based on number of animals participated), standatrd error, and total 
% number of trials in each session
%
function [featureForEach, stdErr, trialCt] = psychometricFunValuesPerSession(dataTable, ...
    feature, specificAnimals)

if nargin < 3
    specificAnimals = {};
end

if ~isempty(specificAnimals)
    dataTable = dataTable(ismember(dataTable.subjectid, specificAnimals), :);
end

% Initiate placeholders
dates = datetime(dataTable.referencetime, 'InputFormat', 'MM/dd/yyyy');
dates = datetime(dates, 'Format', 'MM/dd/uuuu');
dates = string(sort(dates));
sessionList = unique(dates);
featureForEach = zeros(length(sessionList), 4);
stdErr = zeros(length(sessionList), 4);
trialCt = zeros(length(sessionList), 4);

for session = 1:length(sessionList)
    sessionData = dataTable(dataTable.referencetime == sessionList(session), :);
    animalList = unique(sessionData.subjectid);

    % fprintf('Number of animals in session %d: %d\n', session, length(animalList));

    tempFeature = zeros(length(animalList),4);

    for animal = 1:length(animalList)
        animalData = sessionData(sessionData.subjectid == animalList(animal), :);
        for conc = 1:4
            feederToFetch = 5 - conc;
            dataFilter = animalData.realFeederId == feederToFetch;
            featureArray = animalData.(feature)(dataFilter, :);
            featureArray = featureArray(isfinite(featureArray));
            tempFeature(animal, conc) = sum(featureArray)/length(featureArray);
            trialCt(session, conc) = trialCt(session, conc) + length(featureArray);
        end % end of conc 1
    end % end of animal 1

    featureForEach(session, :) = mean(tempFeature, 1, 'omitmissing');
    std_dev = std(tempFeature, 1, 'omitmissing');
    stdErr(session, :) = std_dev ./sqrt(size(tempFeature, 1));
end % end of session 1

% Remove rows if there is any nan
tf = arrayfun(@(x) any(isnan(featureForEach(x, :))), 1:size(featureForEach, 1));
featureForEach(tf', :) = [];
stdErr(tf', :) = [];
trialCt(tf', :) = [];