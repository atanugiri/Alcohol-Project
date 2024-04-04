% Author: Atanu Giri
% Date: 03/24/2024

%% Invokes treatmentIDfun, fetchHealthDataTable, psychometricFunValues,
%% sigmoid_fit_for_cluster

function individualPsychometricPlotOverlay(feature, splitByGender, varargin)

% Example usage:
% individualPsychometricPlotOverlay("approachavoid", 'n', "P2L1 Ghrelin")

% feature = 'approachavoid';
% splitByGender = 'y';
% varargin = {'P2L1 Boost', 'P2L1 Ghrelin', 'P2L1 Alcohol', 'P2L1 Ghr alcohol'};

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
        [totalSessions(grp), hLines(grp)] = treatrmentGroupPlot(currentGrpData);
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

        for gender = 1:numel(genderData)
            subplot(1,2,gender);
            hold on;
        
            [totalSessions(gender), hLines(grp)] = treatrmentGroupPlot(genderData{gender});

            if gender == 1
                title("Male", 'Interpreter','latex','FontSize',25);
                ylabel(sprintf('%s', feature), 'Interpreter','none');
            elseif gender == 2
                title("Female", 'Interpreter','latex','FontSize',25);
            end

            text(min(xlim), max(ylim), sprintf('n = %s', num2str(totalSessions(gender))));

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
    function [totalSessions, hLines] = treatrmentGroupPlot(currentGrpData)

        totalSessions = 0;

        animalList = unique(currentGrpData.subjectid);

        for animal = 1:length(animalList)
            animalData = currentGrpData(currentGrpData.subjectid == animalList(animal),:);
            sessionList = unique(animalData.referencetime);

            totalSessions = totalSessions + length(sessionList);

            for session = 1:length(sessionList)
                sessionData = animalData(animalData.referencetime == sessionList(session),:);
                [featureList, ~, ~] = psychometricFunValues(sessionData, feature);

                % Check for NaN values in y
                if any(isnan(featureList))
                    disp('Skipping iteration due to NaN values in y.');
                    continue; % Skip the current iteration
                end

                hLines = plot(x, featureList, 'LineWidth', 2, 'Color', Colors(grp,:));

            end % end of 1st session

        end % end of 1st animal

    end

end
