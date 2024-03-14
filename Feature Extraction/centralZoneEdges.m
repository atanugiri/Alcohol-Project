% Author: Atanu Giri
% Date: 11/17/2023

function [xEdgeCenter,yEdgeCenter,xEdgeReward,yEdgeReward] = ...
centralZoneEdges(mazeIndex,zoneSize,feeder,feederSize)
%
% This function chooses the maze and feeder in which the trial is taking
% place. It returns the edges of the central zone and reaward feeder 
% according to the input size.
%
% mazeIndex = 1; feeder = 4; zoneSize = 0.4;
if nargin < 4
    feederSize = 0.25; % Default value if not provided
end

switch mazeIndex
    case 1
        % Maze2 a.k.a 1st quadrant
        xMid = 0.5; yMid = 0.5;
        xEdgeCenter = [(xMid - zoneSize/2) (xMid + zoneSize/2)];
        yEdgeCenter = [(yMid - zoneSize/2) (yMid + zoneSize/2)];
        xEdgeOfRZ = {[(1-feederSize) 1.05],[-0.05 feederSize], ...
            [-0.05 feederSize],[(1-feederSize) 1.05]};
        yEdgeOfRZ = {[-0.05 feederSize],[-0.05 feederSize], ...
            [(1-feederSize) 1.05],[(1-feederSize) 1.05]};
        xEdgeReward = xEdgeOfRZ{feeder}; yEdgeReward = yEdgeOfRZ{feeder};

    case 2
        % Maze1 a.k.a 2nd quadrant
        xMid = -0.5; yMid = 0.5;
        xEdgeCenter = [(xMid - zoneSize/2) (xMid + zoneSize/2)];
        yEdgeCenter = [(yMid - zoneSize/2) (yMid + zoneSize/2)];
        xEdgeOfRZ = {[-1.05 (-1+feederSize)],[-1.05 (-1+feederSize)], ...
            [-feederSize 0.05],[-feederSize 0.05]};
        yEdgeOfRZ = {[(1-feederSize) 1.05],[-0.05 feederSize], ...
            [-0.05 feederSize],[(1-feederSize) 1.05]};
        xEdgeReward = xEdgeOfRZ{feeder}; yEdgeReward = yEdgeOfRZ{feeder};

    case 3
        % Maze3 a.k.a 3rd quadrant
        xMid = -0.5; yMid = -0.5;
        xEdgeCenter = [(xMid - zoneSize/2) (xMid + zoneSize/2)];
        yEdgeCenter = [(yMid - zoneSize/2) (yMid + zoneSize/2)];
        xEdgeOfRZ = {[-feederSize 0.05],[-1.05 (-1+feederSize)], ...
            [-1.05 (-1+feederSize)],[-feederSize 0.05]};
        yEdgeOfRZ = {[-1.05 (-1+feederSize)],[-1.05 (-1+feederSize)], ...
            [-feederSize 0.05],[-feederSize 0.05]};
        xEdgeReward = xEdgeOfRZ{feeder}; yEdgeReward = yEdgeOfRZ{feeder};

    case 4
        % Maze4 a.k.a 4th quadrant
        xMid = 0.5; yMid = -0.5;
        xEdgeCenter = [(xMid - zoneSize/2) (xMid + zoneSize/2)];
        yEdgeCenter = [(yMid - zoneSize/2) (yMid + zoneSize/2)];
        xEdgeOfRZ = {[-0.05 feederSize],[(1-feederSize) 1.05], ...
            [(1-feederSize) 1.05],[-0.05 feederSize]};
        yEdgeOfRZ = {[-feederSize 0.05],[-feederSize 0.05], ...
            [-1.05 (-1+feederSize)],[-1.05 (-1+feederSize)]};
        xEdgeReward = xEdgeOfRZ{feeder}; yEdgeReward = yEdgeOfRZ{feeder};
    otherwise
        warning('Unexpected maze number.')

end
end