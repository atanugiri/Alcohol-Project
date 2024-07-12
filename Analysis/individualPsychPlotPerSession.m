% Author: Atanu Giri
% Date: 04/04/2024
%
% This function takes treatment group, feature and animal name as input and
% plots the psychometric function per session.
%
% Example usage:
% individualPsychPlotPerSession('approachavoid','P2L1 Ghrelin', 'sully')

%% Invokes treatmentIDfun, fetchHealthDataTable, psychometricFunValues

function featureList = individualPsychPlotPerSession(feature, trtGroup, animal)

% feature = 'approachavoid'; trtGroup = 'P2L1 Boost'; animal = 'sully';

close all;

% Connect to database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

treatmentIDs = treatmentIDfun(trtGroup, conn);
treatmentIDs_str = strjoin(arrayfun(@num2str, treatmentIDs, 'UniformOutput', false), ',');
treatment_data = fetchHealthDataTable(feature, treatmentIDs_str, conn);
treatment_data = cleanBadSessionsFromTable(treatment_data, feature); % Remove bad sessions

more_data_query = sprintf("SELECT id, mazenumber, trialname FROM " + ...
    "live_table WHERE id IN (%s) ORDER BY id;", treatmentIDs_str);
more_data = fetch(conn, more_data_query);
treatment_data = innerjoin(treatment_data, more_data, "Keys", 'id');
animalData = treatment_data(lower(treatment_data.subjectid) == lower(animal), :);
sessionList = unique(animalData.referencetime);

% x = [1,2,3,4];
% Colors = parula(numel(sessionList));
% figure;

for session = 1:length(sessionList)
    sessionData = animalData(animalData.referencetime == sessionList(session),:);
    featureList = psychometricFunValues(sessionData, feature);

%     disp(sessionData);
%     fprintf('\n');
% 
%     % Check for NaN values in y
%     if any(isnan(featureList))
%         disp('Skipping iteration due to NaN values in y.');
%         continue; % Skip the current iteration
%     end
% 
%     plot(x, featureList, 'LineWidth', 2, 'Color', Colors(session,:), ...
%         'DisplayName', sessionList(session));
%     hold on;

end % end of 1st session

% ylim([0, 1]);
% title(sprintf('%s %s', trtGroup, animal));
% legend('show', 'Location', 'best');
% ylabel(sprintf('%s', feature), "Interpreter","none");
% 
% % Figure name
% figname = sprintf('%s_%s_%s_sessions_psych',trtGroup, animal, feature);
% 
% % Save figure
% scriptDir = fileparts(mfilename('fullpath'));
% folderName = 'Fig files';
% myPath = fullfile(scriptDir, folderName);
% % Check if the folder exists, if not, create it
% if ~exist(myPath, 'dir')
%     mkdir(myPath);
% end
% 
% savefig(gcf, fullfile(myPath, figname));

end