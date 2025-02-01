% Author: Atanu Giri
% Date: 01/31/2025
%
function trialCt = countSessionAndTrial(feature, trtGroup, animalList, conn)

if nargin < 4
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
end

treatmentIDs = treatmentIDfun(trtGroup, conn);
treatmentIDs_str = strjoin(arrayfun(@num2str, treatmentIDs, 'UniformOutput', false), ',');

% Fetch norm_x, norm_y, norm_t
treatment_data = fetchHealthDataTable(feature, treatmentIDs_str, conn);

% L1 and L3 task in L1L3 will naturally have 20 trials
trtGroupsToExclude = {'P2L1L3 BL for comb boost and alc L1', ...
    'P2L1L3 BL for comb boost and alc L3','P2L1L3 Boost and alcohol L1', ...
    'P2L1L3 Boost and alcohol L3', 'P2L1L3 Post alcohol L1', ...
    'P2L1L3 Post alcohol L3'};

if ~ismember(trtGroup,trtGroupsToExclude)
    treatment_data = cleanBadSessionsFromTable(treatment_data, feature); % Remove bad sessions
end

% Filter treatment_data by animalList
treatment_data = treatment_data(ismember(treatment_data.subjectid, animalList), :);
[~, ~, trialCt] = psychometricFunValuesPerSession(treatment_data, feature, animalList);