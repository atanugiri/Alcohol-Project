% Author: Atanu Giri
% Date: 02/15/2024



% function test(varargin)
% Example usage test("P2L1 Ghrelin", "approachavoid")
varargin = ["P2L1 Ghrelin", "approachavoid"];

fprintf("Health types:\n");
fprintf("P2L1 Baseline, P2L1 Food deprivation, Initial task, Late task, P2L1 Saline, \n" + ...
    "P2L1 Ghrelin, P2L1L3 Saline, P2L1L3 Ghrelin, Sal toyrat, \n" + ...
    "Ghr toyrat, Sal toystick, Ghr toystick, Sal skewer, Ghr skewer, \n" + ...
    "Combined Sal toy, Combined Ghr toy\n");


if numel(varargin) >= 1
    treatment = varargin{1};
else
    treatment = input("Which health type do you want for treatment? ","s");
end

treatmentID = treatmentIDfun(treatment);
% Generate the idList from the filtered data
treatmentID = strjoin(arrayfun(@num2str, treatmentID, 'UniformOutput', false), ',');

if numel(varargin) >= 2
    feature = varargin{2};
else
    feature = input("Which feature do you want? ","s");
end

treatment_data = fetchHealthDataTable(feature, treatmentID);

trtmntFitData = extractFitData(treatment_data, feature);

fracOfSigTrmnt = caculateFractionOfSigmoid(trtmntFitData);



%% Description of caculateFractionOfSigmoid
function fractionOfSigmoid = caculateFractionOfSigmoid(fitData)

fractionOfSigmoid = zeros(1, length(fitData));

for animal = 1:length(fitData)
    allGoodness = [];
    for session = 1:length(fitData{animal})
        allGoodness = [allGoodness, fitData{animal}(session).goodness];
    end

    % Check for minimum fit
    minimumFit = 0.4;
    noOfSigmoid = sum(allGoodness >= minimumFit & allGoodness <= 1);
    fractionOfSigmoid(animal) = noOfSigmoid/length(allGoodness);

end
end


%% Description of extractFitData
function fitData = extractFitData(dataTable, feature)
% dataTable = ghrelin_toy_data; % for testing
% feature = 'approachavoid';

animalList = unique(dataTable.subjectid);
fitData = cell(1, length(animalList));

for animal = 1:length(animalList)
    animalData = dataTable(dataTable.subjectid == animalList(animal),:);
    sessionList = unique(animalData.referencetime);

    % Create a structure to store data for each animal
    animalFitData = struct('a', cell(1, length(sessionList)), ...
        'b', cell(1, length(sessionList)), ...
        'goodness', cell(1, length(sessionList)));

    for session = 1:length(sessionList)
        sessionData = animalData(animalData.referencetime == sessionList(session),:);
        [featureList, ~, ~] = psychometricFunValues(sessionData, feature);
        % Check for NaN values in y
        if any(isnan(featureList))
            disp('Skipping iteration due to NaN values in y.');
            continue; % Skip the current iteration
        end
        [a, b, goodness] = sigmoid_fit(featureList);

        % Store the values in the structure
        animalFitData(session).a = a;
        animalFitData(session).b = b;
        animalFitData(session).goodness = goodness;
    end % end of 1st session

    % Save the structure for the current animal
    fitData{animal} = animalFitData;
end % end of 1st animal
end


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

% end