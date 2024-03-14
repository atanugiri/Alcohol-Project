% Author: Atanu Giri
% Date: 11/22/2022
% This function takes raw x,y coordinates and id as input and
% normalizes it with respect to the cleanedDataOnDate.

%% Invokes cleanedDataOnDate

function [xNormalized, yNormalized] = coordinateNormalization(xCoordinate, yCoordinate, id, varargin)
% loadFile = load('xyData.mat');
% xCoordinate = loadFile.x; yCoordinate = loadFile.y;
% id = 265406;

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
    conn =  varargin{1};
end

% remove nan entries
badDataWithTone = table(xCoordinate,yCoordinate,'VariableNames',{'X','Y'});
validIdx = all(isfinite(badDataWithTone{:,:}),2);
cleanedData = badDataWithTone(validIdx,:);

% call cleanedDataOnDate to normalize the data for plotting trajectory
[xCleanedByYAxis,yCleanedByYAxis] = cleanedDataOnDate(id, conn);

% normalize the coordinates between 0 and 1
quadrant1Flag = cleanedData.X >= 0 & cleanedData.Y >= 0;
quadrant2Flag = cleanedData.X <= 0 & cleanedData.Y >= 0;
quadrant3Flag = cleanedData.X <= 0 & cleanedData.Y <= 0;

if (sum(quadrant1Flag)/length(quadrant1Flag) > 0.6)
    xNormalized = (xCoordinate - min(xCleanedByYAxis{1}))/...
        (max(xCleanedByYAxis{1}) - min(xCleanedByYAxis{1}));
    yNormalized = (yCoordinate - min(yCleanedByYAxis{1}))/...
        (max(yCleanedByYAxis{1}) - min(yCleanedByYAxis{1}));

elseif (sum(quadrant2Flag)/length(quadrant2Flag) > 0.6)
    xNormalized = (xCoordinate - max(xCleanedByYAxis{2}))/...
        (max(xCleanedByYAxis{2}) - min(xCleanedByYAxis{2}));
    yNormalized = (yCoordinate - min(yCleanedByYAxis{2}))/...
        (max(yCleanedByYAxis{2}) - min(yCleanedByYAxis{2}));

elseif (sum(quadrant3Flag)/length(quadrant3Flag) > 0.6)
    xNormalized = (xCoordinate - max(xCleanedByYAxis{3}))/...
        (max(xCleanedByYAxis{3}) - min(xCleanedByYAxis{3}));
    yNormalized = (yCoordinate - max(yCleanedByYAxis{3}))/...
        (max(yCleanedByYAxis{3}) - min(yCleanedByYAxis{3}));

else
    xNormalized = (xCoordinate - min(xCleanedByYAxis{4}))/...
        (max(xCleanedByYAxis{4}) - min(xCleanedByYAxis{4}));
    yNormalized = (yCoordinate - max(yCleanedByYAxis{4}))/...
        (max(yCleanedByYAxis{4}) - min(yCleanedByYAxis{4}));
end

end