% Author: Atanu Giri
% Date: 07/12/2024
%
function calculateFractionOfSigmoid(gender, varargin)
% gender = 'female';
% varargin = {'P2L1 BL for comb boost and alc_approachavoid_logistic4_fitting_param.mat', ...
%     'P2L1L3 BL for comb boost and alc_approachavoid_logistic4_fitting_param.mat', ...
%     'P2A Boost and alcohol_approachavoid_logistic4_fitting_param.mat'};

scriptDir = fileparts(mfilename('fullpath'));
myPath = fullfile(scriptDir, 'Clusters/Mat files/');

allRsq = cell(1, numel(varargin));
animals = cell(1, numel(varargin));

for grp = 1:numel(varargin)
    loadFile = load(fullfile(myPath, varargin{grp}));
    [R_squared, animal] = helperFun(loadFile);

    allRsq{grp} = R_squared;
    animals{grp} = animal;
end

males = {'aladdin', 'carl', 'jafar', 'jimi', 'jr', 'kobe', 'mike', 'scar', ...
    'simba', 'sully'};
females = {'alexis', 'fiona', 'harley', 'juana', 'kryssia', 'neftali', ...
    'raven', 'renata', 'sarah', 'shakira'};

fracOfSig = zeros(numel(varargin), numel(males));

if strcmpi(gender, 'male')
    for grp = 1:numel(varargin)
        for i = 1:numel(males)
            currentAnimal = males(i);
            animalData = allRsq{grp}(ismember(animals{grp},currentAnimal));
            sigFilter = animalData >= 0.9;
            fracOfSig(grp,i) = sum(sigFilter)/length(animalData);

        end
    end


elseif strcmpi(gender, 'female')
    for grp = 1:numel(varargin)
        for i = 1:numel(females)
            currentAnimal = females(i);
            animalData = allRsq{grp}(ismember(animals{grp},currentAnimal));
            sigFilter = animalData >= 0.9;
            fracOfSig(grp,i) = sum(sigFilter)/length(animalData);

        end
    end

else
    error('Use correct input for gender');
end

% Create the bar plot
figure;
bar(fracOfSig', 'grouped', 'EdgeColor','none');
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