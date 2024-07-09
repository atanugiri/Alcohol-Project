% Author: Atanu Giri
% Date: 06/11/2024
function varargout = allFitParamBySession(trtmntName)

% trtmntName = 'P2L1L3 Boost and alcohol_approachavoid_logistic4_fitting_param.mat';

scriptDir = fileparts(mfilename('fullpath'));
myPath = fullfile(scriptDir, 'Mat files/');

if contains(trtmntName, 'logistic4')

    loadFile = load(fullfile(myPath, trtmntName));
    [fitParam, R_squared, animal] = helperFun(loadFile);

    %% Remove negative slopes (Optional)
    for session = 1:numel(fitParam)
        sessFitParam = fitParam{session};
        sessFitParam = cell2mat(sessFitParam);
        ngtvSlpFltr = sessFitParam(:,2) <= 0;
        sessFitParam = sessFitParam(~ngtvSlpFltr, :);

        sessRsq = R_squared{session};
        sessRsq = cell2mat(sessRsq);
        sessRsq = sessRsq(~ngtvSlpFltr, :);

        sessAnimal = animal{session};
        sessAnimal = string(sessAnimal);
        sessAnimal = sessAnimal(~ngtvSlpFltr, :);

        allRsq{session} = sessRsq;
        LA{session} = sessFitParam(:,1);
        slope{session} = sessFitParam(:,2);
        shift{session} = sessFitParam(:,3);
        UA{session} = sessFitParam(:,4);
        animals{session} = sessAnimal;
    end

    varargout = {LA, slope, shift, UA, allRsq, animals};
end
end



%% Description of helperFun
function [fitParam, R_squared, animal] = helperFun(loadFile)
currentFitData = loadFile.trtmntFitData;

sessionFitData = cell(1, size(currentFitData,2));
fitParam = cell(1, size(currentFitData,2));
R_squared = cell(1, size(currentFitData,2));
animal = cell(1, size(currentFitData,2));

for session = 1:numel(sessionFitData)
    crntSesData = currentFitData(:,session);
    crntSesData = crntSesData(~cellfun(@isempty, crntSesData));

    sessionFitData{session} = crntSesData;
    fitParam{session} = cellfun(@(x) x.fit_params, crntSesData, 'UniformOutput', false);
    R_squared{session} = cellfun(@(x) x.R_squared, crntSesData, 'UniformOutput', false);
    animal{session} = cellfun(@(x) x.Animal, crntSesData, 'UniformOutput', false);
end

end