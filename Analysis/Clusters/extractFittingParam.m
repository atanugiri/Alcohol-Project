% Author: Atanu Giri
% Date: 02/15/2024

%% Invokes treatmentIDfun, fetchHealthDataTable, psychometricFunValues, 
%% sigmoid_fit_for_cluster

function extractFittingParam(treatment, feature, varargin)

% Example usage extractFittingParam("P2L1 Ghrelin", "approachavoid")

% treatment = 'P2L1 Ghrelin';
% feature = 'approachavoid';

% Connect to database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

treatmentID = treatmentIDfun(treatment, conn);
treatmentID = strjoin(arrayfun(@num2str, treatmentID, 'UniformOutput', false), ',');
treatment_data = fetchHealthDataTable(feature, treatmentID, conn);

% File where the fitting results (.mat) and fit plot (pdf) will be saved
fileName = sprintf("%s_%s_fitting_param", treatment, feature);

scriptDir = fileparts(mfilename('fullpath'));
folderName = 'Mat files';
myPath = fullfile(scriptDir, folderName);
% Check if the folder exists, if not, create it
if ~exist(myPath, 'dir')
    mkdir(myPath);
end

% Get fit values
trtmntFitData = extractFitData(treatment_data, feature);

% Save for further analysis
save(fullfile(myPath, sprintf("%s.mat", fileName)), "trtmntFitData");


%% Description of extractFitData
function fitData = extractFitData(dataTable, feature, varargin)

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
        [h, fitIndex, a, b, c, goodness] = sigmoid_fit_for_cluster(featureList);
        title(sprintf(['Animal: %s, Session: %s, Fittype: %d\na = %.3f, ' ...
            'b = %.3f, c = %.3f\nR^2 = %.3f'], ...
            animalList(animal), sessionList(session), fitIndex, a, b, c, goodness));

        % Save plots
        figFolderName = "Fig files";
        myPdfPath = fullfile(scriptDir, figFolderName);
        % Check if the folder exists, if not, create it
        if ~exist(myPdfPath, 'dir')
            mkdir(myPdfPath);
        end

        pdf_file = fullfile(myPdfPath, sprintf("%s.pdf", fileName));
        
        % Save the figure to a PDF file with a separate page for each figure
        if animal == 1 && session == 1
            exportgraphics(h, pdf_file, 'ContentType', 'vector');
        else
            exportgraphics(h, pdf_file, 'ContentType', 'vector', 'Append', true);
        end

        close(h);
       
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

end