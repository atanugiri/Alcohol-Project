% Author: Atanu Giri
% Date: 07/12/2024
%
function calculateFractionOfSigmoid(varargin)
varargin = {'P2L1 BL for comb boost and alc_approachavoid_logistic4_fitting_param.mat', ...
    'P2L1L3 BL for comb boost and alc_approachavoid_logistic4_fitting_param.mat', ...
    'P2A Boost and alcohol_approachavoid_logistic4_fitting_param.mat'};

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