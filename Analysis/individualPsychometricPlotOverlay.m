% Author: Atanu Giri
% Date: 03/24/2024
%
% This function takes feature, splitByGender, and treatment group name/s as
% input and overlays the psychometric function plots per session.
%
% Example usage:
% individualPsychometricPlotOverlay("approachavoid", 'n', "P2L1 Ghrelin")

%% Invokes treatmentIDfun, fetchHealthDataTable, psychometricFunValues

function individualPsychometricPlotOverlay(feature, splitByGender, varargin)

% feature = 'approachavoid'; splitByGender = 'y';
% varargin = {'P2L1 BL for comb boost and alc'};

% Connect to database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

treatmentGroups = cell(1, numel(varargin));
for i = 1:numel(varargin)
    treatmentGroups{i} = varargin{i};
end

treatmentIDs = cell(1, numel(treatmentGroups));
for i = 1:numel(treatmentGroups)
    treatmentIDs{i} = treatmentIDfun(treatmentGroups{i}, conn);
end

% Generate the idList from the filtered data
treatmentIDs_str = cellfun(@(x) strjoin(arrayfun(@num2str, x, 'UniformOutput', ...
    false), ','), treatmentIDs, 'UniformOutput', false);
treatment_data = cell(1, numel(treatmentIDs_str));
for i = 1:numel(treatmentIDs_str)
    treatment_data{i} = fetchHealthDataTable(feature, treatmentIDs_str{i}, conn);
end

% Plotting
x = 1:4;
figure;
hold on;
Colors = lines(numel(treatmentIDs));


if strcmpi(splitByGender, 'n')
    for grp = 1:numel(treatmentGroups)
        currentGrpData = treatment_data{grp};
        [totalSessions(grp), validSessions(grp), hLines(grp)] = ...
            treatrmentGroupPlot(currentGrpData);
        text(min(xlim), max(ylim), sprintf('n = %s', num2str(validSessions(grp))));
        fprintf('Total sessions = %d\n', totalSessions(grp));
        fprintf('Valid sessions = %d\n', validSessions(grp));

    end

    % Add x ticklabel
    ylabel(sprintf('%s', feature), 'Interpreter','none');
    xticks(1:4);
    label = {'0.5','2','5','9'};
    set(gca,'xticklabel',label,'FontSize',15);

elseif strcmpi(splitByGender, 'y')
    for grp = 1:numel(treatmentGroups)
        currentGrpData = treatment_data{grp};
        maleData = currentGrpData(lower(currentGrpData.gender) == 'male', :);
        femaleData = currentGrpData(lower(currentGrpData.gender) == 'female', :);

        genderData = {maleData, femaleData};
        totalSessions = zeros(1,2);
        validSessions = zeros(1,2);

        for gender = 1:numel(genderData)
            subplot(1,2,gender);
            hold on;

            [totalSessions(gender), validSessions(gender), hLines(grp)] = ...
                treatrmentGroupPlot(genderData{gender});
            fprintf('Total sessions = %d\n', totalSessions(gender));
            fprintf('Valid sessions = %d\n', validSessions(gender));

            if gender == 1
                title("Male", 'Interpreter','latex','FontSize',25);
                ylabel(sprintf('%s', feature), 'Interpreter','none');
            elseif gender == 2
                title("Female", 'Interpreter','latex','FontSize',25);
            end

            text(min(xlim), max(ylim), sprintf('n = %s', num2str(validSessions(gender))));

            xticks(1:4);
            label = {'0.5','2','5','9'};
            set(gca,'xticklabel',label,'FontSize',15);
        end

    end % end of 1st treatment group

end

% Add legends
legend(hLines, treatmentGroups, 'Location', 'best');
hold off;

% Figure name
if strcmpi(splitByGender, 'n')
    figname = sprintf('%s_%s_indiv_psych',[treatmentGroups{:}],string(feature));
else
    figname = sprintf('%s_%s_MvF_indiv_psych',[treatmentGroups{:}],string(feature));
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
    function [totalSessions, validSessions, hLines] = treatrmentGroupPlot(currentGrpData)

        totalSessions = 0; % total sessions counter
        validSessions = 0; % valid sessions counter

        animalList = unique(currentGrpData.subjectid);

        for animal = 1:length(animalList)
            animalData = currentGrpData(currentGrpData.subjectid == animalList(animal),:);
            sessionList = unique(animalData.referencetime);
            totalSessions = totalSessions + numel(sessionList); % total sessions counter

            %% Reduce the number of plots for clarity if needed
%             if numel(sessionList) >= 5
%                 randomIdx = randperm(numel(sessionList));
%                 sessionList = sessionList(randomIdx(1:5));
%             end

            for session = 1:length(sessionList)
                sessionData = animalData(animalData.referencetime == sessionList(session),:);
                if height(sessionData) >= 40
                    %                     fprintf('%d trials in session\n', height(sessionData));

                    try
                        [featureList, ~, ~] = psychometricFunValues(sessionData, feature);

                        % If all of approach rate = 0, sensor not working.
                        % Exclude session
                        if all(featureList == 0)
                            continue;
                        end

                        % For sanity check
                        if all(featureList == 0)
                            fprintf('%2f ', featureList);
                            fprintf('\n');
                        end

                        hLines = plot(x, featureList, 'LineWidth', 2, 'Color', Colors(grp,:));
                        validSessions = validSessions + 1;
                    catch
                        fprintf('Something wrong :( \n')
                    end
                end

            end % end of 1st session

        end % end of 1st animal

    end

end