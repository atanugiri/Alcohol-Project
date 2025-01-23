% Author: Atanu Giri
% Date: 04/04/2024
%
% This function takes treatment group, feature and animal name as input and
% plots the psychometric function per session.
%
% Example usage:
% individualPsychPlotPerSession('approachavoid','P2L1 Ghrelin', {'sully'})

%% Invokes individualPsychValuesPerSession

function individualPsychPlotPerSession(feature, trtGroup, animalList)

datasource = 'live_database';
conn = database(datasource, 'postgres', '1234');

treatmentIDs = treatmentIDfun(trtGroup, conn);
treatmentIDs_str = strjoin(arrayfun(@num2str, treatmentIDs, 'UniformOutput', false), ',');

% Fetch norm_x, norm_y, norm_t
treatment_data = fetchHealthDataTable(feature, treatmentIDs_str, conn);
treatment_data = cleanBadSessionsFromTable(treatment_data, feature); % Remove bad sessions

% Filter treatment_data by animalList
treatment_data = treatment_data(ismember(treatment_data.subjectid, animalList), :);

x = 1:4;

for animal = 1:numel(animalList)
    animalData = treatment_data(ismember(treatment_data.subjectid, animalList{animal}), :);
    featureForEach = psychometricFunValuesPerSession(animalData, feature);

    % Plot figure
    figure;
    Colors = parula(size(featureForEach, 1));

    for session = 1:size(featureForEach, 1)
        plot(x, featureForEach(session, :), 'LineWidth', 2, 'Color', Colors(session,:), ...
            'DisplayName', sprintf('session_%d%', session));
        hold on;
    end

    hold off;
    % ylim([0, 1]);
    xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
    ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize', 25);
    xticks(1:4);
    label = {'0.5','2','5','9'};
    set(gca,'xticklabel',label,'FontSize',15);
    legend('show', 'Interpreter', 'none');
    title(sprintf('Individual psychometric function: %s', animalList{animal}), 'Interpreter','none');

    % Save figure
    figname = sprintf('%s_%s_%s_sessions_psych',trtGroup, animalList{animal}, feature);
    scriptDir = fileparts(mfilename('fullpath'));
    folderName = 'Fig files';
    myPath = fullfile(scriptDir, folderName);
    % Check if the folder exists, if not, create it
    if ~exist(myPath, 'dir')
        mkdir(myPath);
    end

    savefig(gcf, fullfile(myPath, figname));
end