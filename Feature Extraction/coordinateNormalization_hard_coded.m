function [xNormalized, yNormalized] = ...
coordinateNormalization_hard_coded(xCoordinate, yCoordinate, maze)

% [xCleanedByYAxis,yCleanedByYAxis] = cleanedDataOnDate(id);

switch maze
    case 1 % Maze 2 aka q1
        xNormalized = (xCoordinate - 200)/(960 - 200);
        yNormalized = (yCoordinate - 50)/(810 - 50);
    case 2 % Maze 1 aka q2
        xNormalized = (xCoordinate + 200 )/(960 - 200);
        yNormalized = (yCoordinate - 50)/(810 - 50);
    case 3 % Maze 3 aka q3
        xNormalized = (xCoordinate + 200)/(960 - 200);
        yNormalized = (yCoordinate + 50)/(810 - 50);
    case 4 % Maze 4 aka q4
        xNormalized = (xCoordinate - 200)/(960 - 200);
        yNormalized = (yCoordinate + 50)/(810 - 50);
end
end