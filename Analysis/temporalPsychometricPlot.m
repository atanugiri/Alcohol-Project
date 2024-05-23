% Author: Atanu Giri
% Date: 05/22/2024
%
% This function overlays psychometric plot of session 1-n for as an 
% average of all animals. 
%
% Example usage:
% temporalPsychometricPlot('approachavoid', 'n', 'P2L1L3 Boost and alcohol')

%% Invokes treatmentIDfun, fetchHealthDataTable, cleanBadSessionsFromTable, 
%% psychometricFunValues

function varargout = temporalPsychometricPlot(feature, splitByGender, trtGrp)

% feature = 'approachavoid'; splitByGender = 'y'; trtGrp = 'P2L1 BL for comb boost and alc';

% Connect to database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% Extract data table corresponding to treatment group
treatmentIDs = treatmentIDfun(trtGrp, conn);
treatmentIDs_str = strjoin(arrayfun(@num2str, treatmentIDs, 'UniformOutput', false), ',');
treatment_data = fetchHealthDataTable(feature, treatmentIDs_str, conn);
treatment_data = cleanBadSessionsFromTable(treatment_data, feature); % Remove bad sessions


if strcmpi(splitByGender, 'n')
    h = treatrmentGroupPlot(treatment_data);
    ylabel(sprintf('%s', feature), 'Interpreter','none');
    title(sprintf("%s", trtGrp), 'Interpreter','latex','FontSize',25);

elseif strcmpi(splitByGender, 'y')
    maleData = treatment_data(lower(treatment_data.gender) == 'male', :);
    femaleData = treatment_data(lower(treatment_data.gender) == 'female', :);

    subplot(1,2,1);
    h_male = treatrmentGroupPlot(maleData);
    title("Male", 'Interpreter','latex','FontSize',25);
    ylabel(sprintf('%s', feature), 'Interpreter','none');

    subplot(1,2,2);
    h_female = treatrmentGroupPlot(femaleData);
    title("Female", 'Interpreter','latex','FontSize',25);

    sgtitle(sprintf("%s", trtGrp), 'Interpreter','latex','FontSize',25);

    % Link axes to ensure the same scale
    linkaxes([subplot(1,2,1), subplot(1,2,2)], 'y');
end

% Figure name
if strcmpi(splitByGender, 'n')
    figname = sprintf('temporal_%s_%s',trtGrp,string(feature));
else
    figname = sprintf('temporal_%s_%s_MvF',trtGrp,string(feature));
end

% Save figure
scriptDir = fileparts(mfilename('fullpath'));
folderName = 'Fig files';
myPath = fullfile(scriptDir, folderName);
% Check if the folder exists, if not, create it
if ~exist(myPath, 'dir')
    mkdir(myPath);
end

savefig(gcf, fullfile(myPath, figname));




%% Description of treatrmentGroupPlot
function h = treatrmentGroupPlot(treatment_data_table)
    % Placeholder for all session data
    sessionData = cell(1,50);
    sessionAnimals = zeros(1, 50);

    animalList = unique(treatment_data_table.subjectid);
    for animal = 1:length(animalList)
        animalData = treatment_data_table(treatment_data_table.subjectid == animalList(animal),:);
        sessionList = unique(animalData.referencetime);

        for session = 1:length(sessionList)
            sesDataCrntAnml = animalData(animalData.referencetime == sessionList(session),:);
            sessionData{session} = [sessionData{session}; sesDataCrntAnml];
            sessionAnimals(session) = sessionAnimals(session) + 1; % Animal counter in session
        end

    end

    sessionData = sessionData(~cellfun(@isempty, sessionData));
    sessionAnimals = sessionAnimals(sessionAnimals ~= 0);

    % Plotting
    x = 1:4;
    Colors = parula(numel(sessionData));
    figure;

    legend_labels = cell(1, numel(sessionData));

    for session = 1:numel(sessionData)
        [~, avFeature, stdErr] = psychometricFunValues(sessionData{session}, feature);
        h(session) = plot(x, avFeature, 'LineWidth', 2, 'Color', Colors(session,:));
        hold on;
        legend_labels{session} = sprintf('session %d, n = %d', session, sessionAnimals(session));
        errorbar(x, avFeature,stdErr,'LineStyle', 'none','LineWidth', 1.5, 'Color','k');
    end

    hold off;
    legend(h, legend_labels, 'Location', 'best');
    xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);

    xticks(1:4);
    label = {'0.5','2','5','9'};
    set(gca,'xticklabel',label,'FontSize',15);
end

end