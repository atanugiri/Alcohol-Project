% Author: Atanu Giri
% Date: 04/15/2024

function [allA, allB, allC, allD, allRsq] = allFitParam(varargin)

scriptDir = fileparts(mfilename('fullpath'));
myPath = fullfile(scriptDir, 'Mat files/');

FitData = cell(1, numel(varargin));

for grp = 1:numel(varargin)
    loadFile = load(fullfile(myPath, varargin{grp}));
    FitData{grp} = loadFile.trtmntFitData;
end

allA = cell(1, numel(varargin));
allB = cell(1, numel(varargin));
allC = cell(1, numel(varargin));
allD = cell(1, numel(varargin));
allRsq = cell(1, numel(varargin));

for grp = 1:numel(varargin)
    currentFitData = FitData{grp};

    % Loop through each cell of FitData
    for animal = 1:numel(currentFitData)
        % Get the current struct
        currentAnimalData = currentFitData{animal};

        for session = 1:length(currentAnimalData)
            % Collect the fit params
            allA{grp} = [allA{grp}; currentAnimalData(session).a];
            allB{grp} = [allB{grp}; currentAnimalData(session).b];
            allC{grp} = [allC{grp}; currentAnimalData(session).c];
            allD{grp} = [allD{grp}; currentAnimalData(session).d];
            allRsq{grp} = [allRsq{grp}; currentAnimalData(session).goodness];
        end % end of 1st session
    end % end of 1st animal

end % end of 1st treatment group

end