% function extractFittingParamBySession(treatment, feature, fitType)

scriptDir = fileparts(mfilename('fullpath'));
folderName = 'Mat files';
myPath = fullfile(scriptDir, folderName);
% Check if the folder exists, if not, create it
if ~exist(myPath, 'dir')
    mkdir(myPath);
end

fileName = 'P2L1L3 boost and alcohol_approachavoid_logistic4_fitting_param.mat';
loadFile = load(fullfile(myPath, fileName));
[~,name,~] = fileparts(fileName);
data = loadFile.trtmntFitData;


for i = 1:size(data, 2)
    trtmntFitData = data(:,i);
    save(fullfile(myPath, sprintf("%s_S%d.mat", fileName, i)), "trtmntFitData");
end