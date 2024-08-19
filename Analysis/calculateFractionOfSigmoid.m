% Author: Atanu Giri
% Date: 07/12/2024
%
% Plots the fraction of sigmoid of individual animals for input treatment
% group/s. If the psychometric function is sigmoid or not is decided by a 
% threshold R^2 value of the fit
%
function [non_sig_count, total] = calculateFractionOfSigmoid(gender, feature, fitType, varargin)
% gender = 'female'; feature = 'approachavoid'; fitType = 2;
% varargin = {'P2L1 BL for comb boost and alc', ...
%     'P2L1L3 BL for comb boost and alc', 'P2A Boost and alcohol'};

% Files to fetch
fitTypeNames = ["logistic3", "logistic4", "GP"];
files = strcat(varargin, '_', feature, sprintf('_%s_fitting_param', fitTypeNames(fitType)));

% Fetch mat files where R^2 values are stored.
scriptDir = fileparts(mfilename('fullpath'));
myPath = fullfile(scriptDir, 'Clusters/Mat files/');

allRsq = cell(1, numel(varargin));
animals = cell(1, numel(varargin));

for grp = 1:numel(varargin)
    loadFile = load(fullfile(myPath, files{grp}));
    [R_squared, animal] = helperFun(loadFile);

    allRsq{grp} = R_squared;
    animals{grp} = animal;
end

% List of males and females
males = {'aladdin', 'carl', 'jafar', 'jimi', 'jr', 'kobe', 'mike', 'scar', ...
    'simba', 'sully'};
females = {'alexis', 'fiona', 'harley', 'juana', 'kryssia', 'neftali', ...
    'raven', 'renata', 'sarah', 'shakira'};

% Calculate fraction of sigmoid for each animal by gender
if strcmpi(gender, 'male')
    fracOfSig = fracOfSigFun(males);
elseif strcmpi(gender, 'female')
    fracOfSig = fracOfSigFun(females);
else
    error('Use correct input for gender');
end

non_sig_count = sum(fracOfSig < 0.7);
total = length(fracOfSig);

% Create the bar plot
figure;
bar(fracOfSig', 'grouped', 'EdgeColor','none');
hold on;
yline(0.7, '--r', 'LineWidth', 1.5); % User defined threshold

ylabel('Fraction of sigmoid');
if strcmpi(gender, 'male')
    xlabel('Male');
    set(gca, 'XTickLabel', males);

elseif strcmpi(gender, 'female')
    xlabel('Female');
    set(gca, 'XTickLabel', females);
end

% Save figure
folderName = 'Fig files';
figPath = fullfile(scriptDir, folderName);
% Check if the folder exists, if not, create it
if ~exist(myPath, 'dir')
    mkdir(myPath);
end

% Figure name
figname = sprintf('FracOfSig_%s', gender);
savefig(gcf, fullfile(figPath, figname));


%% Description of fracOfSigFun
    function fracOfSig = fracOfSigFun(animalList)
        fracOfSig = zeros(numel(varargin), numel(animalList));
        for i = 1:numel(varargin)
            for j = 1:numel(animalList)
                currentAnimal = animalList(j);
                animalData = allRsq{i}(ismember(animals{i},currentAnimal));
                sigFilter = animalData >= 0.9;
                fracOfSig(i,j) = sum(sigFilter)/length(animalData);

            end
        end
    end


%% Description of helperFun
    function [R_squared, animal] = helperFun(loadFile)
        currentFitData = loadFile.trtmntFitData;
        currentFitData = currentFitData(~cellfun(@isempty, currentFitData));
        R_squared = cellfun(@(x) x.R_squared, currentFitData, 'UniformOutput', false);
        R_squared = cell2mat(R_squared);
        animal = cellfun(@(x) x.Animal, currentFitData, 'UniformOutput', false);
        animal = string(animal);
    end
end