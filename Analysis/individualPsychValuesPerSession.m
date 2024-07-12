% Author: Atanu Giri
% Date: 07/11/2024
%
% This function takes treatment group, feature and animal name as input and
% plots the psychometric values per session.
%
% Example usage:
% individualPsychPlotPerSession('approachavoid','P2L1 Ghrelin', 'sully')
%
function featureList = individualPsychValuesPerSession(feature, trtGroup, animal)

% feature = 'approachavoid'; trtGroup = 'P2L1 BL for comb boost and alc'; animal = 'aladdin';

% Connect to database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

treatmentIDs = treatmentIDfun(trtGroup, conn);
treatmentIDs_str = strjoin(arrayfun(@num2str, treatmentIDs, 'UniformOutput', false), ',');
treatment_data = fetchHealthDataTable(feature, treatmentIDs_str, conn);
treatment_data = cleanBadSessionsFromTable(treatment_data, feature); % Remove bad sessions

animalData = treatment_data(lower(treatment_data.subjectid) == lower(animal), :);
sessionList = unique(animalData.referencetime);

% Placeholder for each session output in matrix format
featureList = zeros(length(sessionList), 4);

for session = 1:length(sessionList)
    sessionData = animalData(animalData.referencetime == sessionList(session),:);
    featureList(session,:) = psychometricFunValues(sessionData, feature);

end % end of 1st session
end