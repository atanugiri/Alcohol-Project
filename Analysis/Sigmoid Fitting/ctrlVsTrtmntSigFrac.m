% Author: Atanu Giri
% Date: 01/21/2024

% This script plots bar graph of sigmoid fraction of sessions in 
% saline and ghrelin toyrat experiment

function ctrlVsTrtmntSigFrac

fprintf("Health types:\n");
fprintf("P2L1 Baseline, P2L1 Food deprivation, Initial task, Late task, P2L1 Saline, \n" + ...
    "P2L1 Ghrelin, P2L1L3 Saline, P2L1L3 Ghrelin, Sal toyrat, \n" + ...
    "Ghr toyrat, Sal toystick, Ghr toystick, Sal skewer, Ghr skewer, \n" + ...
    "Combined Sal toy, Combined Ghr toy\n");

control = input("Which health type do you want for control? ","s");
controlID = treatmentIDfun(control);

treatment = input("Which health type do you want for treatment? ","s");
treatmentID = treatmentIDfun(treatment);

% Generate the idList from the filtered data
controlID = strjoin(arrayfun(@num2str, controlID, 'UniformOutput', false), ',');
treatmentID = strjoin(arrayfun(@num2str, treatmentID, 'UniformOutput', false), ',');

feature = 'approachavoid';

control_toy_data = fetchHealthDataTable(feature, controlID);
% if ~strcmpi(feature,'approachavoid')
%     saline_toy_data(isoutlier(saline_toy_data.distance_until_limiting_time_stamp_old),:) = [];
% end

treatment_toy_data = fetchHealthDataTable(feature, treatmentID);

% Get common subjectids
uniqueSubjectidCtrl = unique(control_toy_data.subjectid);
uniqueSubjectidTrtmnt = unique(treatment_toy_data.subjectid);
commonSubjectId = intersect(uniqueSubjectidCtrl, uniqueSubjectidTrtmnt);

% Extract the data corresponding to common subjectids
control_toy_data = control_toy_data(ismember(control_toy_data.subjectid, commonSubjectId),:);
treatment_toy_data = treatment_toy_data(ismember(treatment_toy_data.subjectid, commonSubjectId),:);

ctrlFitData = extractFitData(control_toy_data, feature);
trtmntFitData = extractFitData(treatment_toy_data, feature);

fracOfSigCtrl = caculateFractionOfSigmoid(ctrlFitData);
fracOfSigTrmnt = caculateFractionOfSigmoid(trtmntFitData);

%% Barplot of sigmoid fit
figure;
subplot(1,2,1);
bar(1:length(fracOfSigCtrl), fracOfSigCtrl);
ylabel("Fraction of sigmoid", 'FontSize',25);
hold on;
subplot(1,2,2);
bar(1:length(fracOfSigTrmnt), fracOfSigTrmnt);
sgtitle(sprintf("%s vs % s", control, treatment));



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
        [featureListSaline, ~, ~] = psychometricFunValues(sessionData, feature);
        % Check for NaN values in y
        if any(isnan(featureListSaline))
            disp('Skipping iteration due to NaN values in y.');
            continue; % Skip the current iteration
        end
        [a, b, goodness] = sigmoid_fit(featureListSaline);

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

end