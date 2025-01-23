% Author: Atanu Giri
% Date: 01/22/2025
%
% This script plots the psychometric function at 2 different lightlevel for
% a specific health group.

function featureAnalysisAtLightLevel(treatmentGroup, feature, dataLabel, animalList)

% feature = 'approachavoid';
% treatmentGroup = 'P2L1L3 BL for comb boost and alc';

if nargin < 4
    animalList = {};
end

if nargin < 3
    dataLabel = {'group 1', 'group 2'};
end

% Connect to database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

treatmentIDs = treatmentIDfun(treatmentGroup, conn);
treatmentIDs_str = strjoin(arrayfun(@num2str, treatmentIDs, 'UniformOutput', false), ',');
treatment_data = fetchHealthDataTable(feature, treatmentIDs_str, conn);

% Filter by animalList
if ~isempty(animalList)
    treatment_data = treatment_data(ismember(treatment_data.subjectid, animalList), :);
end

% Additional query
addQuery = sprintf("SELECT id, lightlevel " + ...
    "FROM live_table WHERE id IN (%s) ORDER BY id", treatmentIDs_str);
addData = fetch(conn, addQuery);
treatment_data = innerjoin(treatment_data,addData,'Keys','id');
treatment_data = cleanBadSessionsFromTable(treatment_data, feature); % Remove bad sessions

treatment_data.lightlevel = str2double(string(treatment_data.lightlevel));

% Separate data based on light level
grp1Data = treatment_data(treatment_data.lightlevel == 1, :);
grp2Data = treatment_data(treatment_data.lightlevel ~= 1, :);

data = {grp1Data, grp2Data};

% Placehlders for function outputs
featureForEach = cell(1, numel(data));
avgFeature = cell(1, numel(data));
stdErr = cell(1, numel(data));

for grp = 1:numel(data)
    featureForEach{grp} = psychometricFunValuesPerSession(data{grp}, feature);
    avgFeature{grp} = mean(featureForEach{grp});
    stdErr{grp} = std(featureForEach{grp})/sqrt(size(featureForEach{grp}, 1));
end

% Plot
x = 1:4;
figure;
Colors = ['b', 'r'];
for grp = 1:numel(data)
    errorbar(x, avgFeature{grp}, stdErr{grp}, 'DisplayName', dataLabel{grp}, ...
        'LineWidth', 2, 'Color', Colors(grp));
    hold on;
end

hold off;

% Add label and legend
xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
ylabel(sprintf('%s', feature), 'Interpreter', 'none', 'FontSize', 25);
xticks(1:4);
label = {'0.5','2','5','9'};
set(gca,'xticklabel',label,'FontSize',15);

legend('show', 'Interpreter', 'none');