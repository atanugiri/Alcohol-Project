% Author: Atanu Giri
% Date: 02/15/2024

% function test(varargin)
% Example usage test("P2L1 Ghrelin", "approachavoid")

datasource = 'live_database';
conn = database(datasource,'postgres','1234');

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

treatmentID = treatmentIDfun(treatment, conn);
% Generate the idList from the filtered data
treatmentID = strjoin(arrayfun(@num2str, treatmentID, 'UniformOutput', false), ',');

if numel(varargin) >= 2
    feature = varargin{2};
else
    feature = input("Which feature do you want? ","s");
end

treatment_data = fetchHealthDataTable(feature, treatmentID, conn);

trtmntFitData = extractFitData(treatment_data, feature);



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
    animalFitData = struct('animal', cell(1, length(sessionList)), ...
        'date', cell(1, length(sessionList)), ...
        'fitIndex', cell(1, length(sessionList)), ...
        'a', cell(1, length(sessionList)), ...
        'b', cell(1, length(sessionList)), ...
        'c', cell(1, length(sessionList)), ...
        'goodness', cell(1, length(sessionList)));

    for session = 1:length(sessionList)
        sessionData = animalData(animalData.referencetime == sessionList(session),:);
        [featureList, ~, ~] = psychometricFunValues(sessionData, feature);
        % Check for NaN values in y
        if any(isnan(featureList))
            disp('Skipping iteration due to NaN values in y.');
            continue; % Skip the current iteration
        end

        % Fitting
        [fitIndex, a, b, c, goodness] = sigmoid_fit_for_cluster(featureList);

        % Store the values in the structure
        animalFitData(session).animal = animalList(animal);
        animalFitData(session).date = sessionList(session);
        animalFitData(session).fitIndex = fitIndex;
        animalFitData(session).a = a;
        animalFitData(session).b = b;
        animalFitData(session).c = c;
        animalFitData(session).goodness = goodness;
    end % end of 1st session

    % Save the structure for the current animal
    fitData{animal} = animalFitData;
end % end of 1st animal
end
% end