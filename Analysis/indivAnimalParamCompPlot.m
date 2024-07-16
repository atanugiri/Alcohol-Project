% Author: Atanu Giri
% Date: 07/15/2024
%
% This function plots bar of parameters of individual animals for input
% logistic parameter and treatment group names.
%
% Possible parameter names
% logistic4 fit: 'LA', 'slope', 'shift', 'UA', 'Rsq'

function varargout = indivAnimalParamCompPlot(param_name, splitByGender, varargin)

% param_name = 'shift';
% splitByGender = 'y';
% varargin = {'P2L1 BL for comb boost and alc_approachavoid_logistic4_fitting_param.mat', ...
%     'P2L1L3 BL for comb boost and alc_approachavoid_logistic4_fitting_param.mat', ...
%     'P2A Boost and alcohol_approachavoid_logistic4_fitting_param.mat'};

scriptDir = fileparts(mfilename('fullpath'));
myPath = fullfile(scriptDir, 'Clusters/Mat files/');

param_array = cell(1, numel(varargin));
animals = cell(1, numel(varargin));

for grp = 1:numel(varargin)
    loadFile = load(fullfile(myPath, varargin{grp}));
    [LA, slope, shift, UA, Rsq, animal] = helperFun(loadFile);
    featureMap = struct('LA', LA, 'slope', slope, 'shift', shift, 'UA', UA, ...
        'Rsq', Rsq);

    param_array{grp} = featureMap.(param_name);
    animals{grp} = animal;
end

males = {'aladdin', 'carl', 'jafar', 'jimi', 'jr', 'kobe', 'mike', 'scar', ...
    'simba', 'sully'};
females = {'alexis', 'fiona', 'harley', 'juana', 'kryssia', 'neftali', ...
    'raven', 'renata', 'sarah', 'shakira'};

% Figure path
folderName = 'Fig files';
figPath = fullfile(scriptDir, folderName);

if ~exist(myPath, 'dir')
    mkdir(myPath);
end

% Seperate param_array into male and female
if strcmpi(splitByGender, 'y')
    [maleParam, stdErrMale] = calculateParamValandStdErr(males);
    [femaleParam, stdErrFemale] = calculateParamValandStdErr(females);

    % Create the bar plot
    myPlot(maleParam, stdErrMale);
    set(gca, 'XTickLabel', males);
    xlabel('Male');
    maleFigname = sprintf('indivBarPlotOf_%s_male', param_name);
    savefig(gcf, fullfile(figPath, maleFigname));

    myPlot(femaleParam, stdErrFemale);
    set(gca, 'XTickLabel', females);
    xlabel('Female');
    femaleFigname = sprintf('indivBarPlotOf_%s_female', param_name);
    savefig(gcf, fullfile(figPath, femaleFigname));

    varargout{1} = males;
    varargout{2} = maleParam;
    varargout{3} = stdErrMale;
    varargout{4} = females;
    varargout{5} = femaleParam;
    varargout{6} = stdErrFemale;

elseif strcmpi(splitByGender, 'n')
    allAnimals = [males, females];
    [param, stdErr] = calculateParamValandStdErr(allAnimals);
    myPlot(param, stdErr);
    set(gca, 'XTickLabel', allAnimals);
    xlabel('Animals');
    figname = sprintf('indivBarPlotOf_%s', param_name);
    savefig(gcf, fullfile(figPath, figname));

    varargout{1} = allAnimals;
    varargout{2} = param;
    varargout{3} = stdErr;
end






%% Description of helperFun
    function [LA, slope, shift, UA, R_squared, animal] = helperFun(loadFile)
        currentFitData = loadFile.trtmntFitData;
        currentFitData = currentFitData(~cellfun(@isempty, currentFitData));

        R_squared = cellfun(@(x) x.R_squared, currentFitData, 'UniformOutput', false);
        R_squared = cell2mat(R_squared);

        fitParam = cellfun(@(x) x.fit_params, currentFitData, 'UniformOutput', false);
        fitParam = cell2mat(fitParam);
        LA = fitParam(:,1);
        slope = fitParam(:,2);
        shift = fitParam(:,3);
        UA = fitParam(:,4);

        animal = cellfun(@(x) x.Animal, currentFitData, 'UniformOutput', false);
        animal = string(animal);
    end

%% Description of calculateParamValandStdErr
    function [param_values, stdErr] = calculateParamValandStdErr(animalsToUse)
        param_values = zeros(numel(animalsToUse), numel(varargin));
        stdErr = zeros(numel(animalsToUse), numel(varargin));

        % Calculate param_values and stdErr
        for ii = 1:numel(animalsToUse)
            for j = 1:numel(varargin)
                currentAnimal = animalsToUse{ii};
                animalData = param_array{j}(ismember(animals{j}, currentAnimal));
                param_values(ii, j) = mean(animalData, 'omitnan');
                stdErr(ii, j) = std(animalData) / sqrt(length(animalData));
            end
        end
    end

%% Description of myPlot
    function myPlot(param_values, stdErr)
        figure;
        hBar = bar(param_values, 'grouped', 'EdgeColor','none');
        hold on;

        % Get the number of groups and the number of bars in each group
        [n_rows, n_cols] = size(param_values);

        % Calculate the x positions for the error bars
        x = nan(n_rows, n_cols);
        for i = 1:n_cols
            x(:, i) = hBar(i).XEndPoints;
        end

        % Add error bars
        for i = 1:n_cols
            errorbar(x(:, i), param_values(:, i), stdErr(:, i), 'k', 'linestyle', 'none', 'LineWidth', 1);
        end

        hold off;

        % Legend
        legendLabels = cell(1,numel(varargin));
        for jj = 1:numel(varargin)
            result = regexp(varargin{jj}, '^[^_]+', 'match');
            extracted_part = result{1};
            legendLabels{jj} = extracted_part;
        end
        legend(legendLabels, 'Location','best', 'Interpreter','none');
        ylabel(sprintf('%s', param_name), "Interpreter", "none");
    end
end