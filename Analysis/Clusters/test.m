% Author: Atanu Giri
% Date: 03/12/2024

loadFile = load('P2L1 Ghrelin_approachavoid_fitting_param.mat');
FitData = loadFile.trtmntFitData;

allA = [];
allB = [];
allC = [];

% Loop through each cell of FitData
for i = 1:numel(FitData)
    % Get the current struct
    currentData = FitData{i};

    for j = 1:length(currentData)
        if currentData(j).fitIndex == 2
            % Collect the 'a' value
            allA = [allA; currentData(j).a];
            allB = [allB; currentData(j).b];
            allC = [allC; currentData(j).c];

        end
    end
end

biplot(allA, allB, allC)