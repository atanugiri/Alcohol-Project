% Author: Atanu Giri
% Date: 01/27/2025
%
treatmentGroups = 'P2L1L3 Baseline L3';
feature = 'approachavoid';

% Connect to database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

treatmentIDs = treatmentIDfun(treatmentGroups, conn);
treatmentIDs_str = strjoin(arrayfun(@num2str, treatmentIDs, 'UniformOutput', false), ',');
treatment_data = fetchHealthDataTable(feature, treatmentIDs_str, conn);

% Additional query
addQuery = sprintf("SELECT id, intensityofcost3 " + ...
    "FROM live_table WHERE id IN (%s) ORDER BY id", treatmentIDs_str);
addData = fetch(conn, addQuery);
treatment_data = innerjoin(treatment_data,addData,'Keys','id');

% Use regexprep to remove any non-numeric characters from the intensityofcost1 column
treatment_data.intensityofcost3 = str2double(regexprep( ...
    string(treatment_data.intensityofcost3), '[^\d.]', ''));

males = {'aladdin', 'carl', 'jafar', 'jimi', 'johnny', 'jr', 'kobe', ...
'mike', 'scar', 'simba', 'sully'};
females = {'alexis', 'andrea', 'fiona', 'harley', 'juana', 'kryssia', ...
'neftali', 'raissa', 'raven', 'renata', 'sarah', 'shakira'};

maleData = treatment_data(ismember(treatment_data.subjectid, males),:);
femaleData = treatment_data(ismember(treatment_data.subjectid, females),:);

[avFeature_male, stdErr_male, allCost_male] = psychometricFunValuesCost(maleData, feature);
[avFeature_female, stdErr_female, allCost_female] = psychometricFunValuesCost(femaleData, feature);

% Plot
figure;
errorbar(1:length(allCost_male), avFeature_male, stdErr_male, ...
    'DisplayName','Male', 'LineWidth',2);
hold on;
errorbar(1:length(allCost_male), avFeature_female, stdErr_female, ...
    'DisplayName','Female', 'LineWidth',2);

hold off;
legend('show', 'Interpreter', 'none');


%% description of psychometricFunValuesCost
function [avFeature, stdErr, allCost] = psychometricFunValuesCost(data, feature)

data = sortrows(data, "intensityofcost3");
allCost = unique(data.intensityofcost3);
animalList = unique(data.subjectid);

allFeatures = zeros(length(animalList), length(allCost));

for cost = 1:length(allCost)
    for animal = 1:length(animalList)
        currentData = data(data.subjectid == animalList(animal) ...
            & data.intensityofcost3 == allCost(cost), :);
        featureList = currentData.(feature);
        featureList = featureList(isfinite(featureList));
        allFeatures(animal, cost) = sum(featureList)/length(featureList);
    end
end

avFeature = mean(allFeatures);
stdErr = std(allFeatures) ./sqrt(size(featureList, 1));

end