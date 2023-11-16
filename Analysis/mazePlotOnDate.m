% Date: 10/29/2023
% Author: Atanu Giri

close all; clear; clc;
loadFile = load('salineGhrelinData2.mat');
data = loadFile.data;

data.referencetime = string(data.referencetime);
uniqueDates = unique(data.referencetime);
fprintf('Unique dates:\n');
numPerLine = 10;
numValues = length(uniqueDates);
for i = 1:numPerLine:numValues
    fprintf('%s, ', uniqueDates(i:min(i+numPerLine-1, numValues)));
    fprintf('\n');
end

inputDate = input('Which health types do you want to analyze? ', 's');
dataOnDate = data(data.referencetime == inputDate, :);

fileName = regexprep(inputDate, '/','_');

mazeData = cell(1,4);
mazeData{1} = dataOnDate(dataOnDate.mazenumber == 'maze 1', :);
mazeData{2} = dataOnDate(dataOnDate.mazenumber == 'maze 2',:);
mazeData{3} = dataOnDate(dataOnDate.mazenumber == 'maze 3',:);
mazeData{4} = dataOnDate(dataOnDate.mazenumber == 'maze 4',:);

salineDirectory = '/Users/atanugiri/Downloads/Saline Ghrelin Project/Saline Plots';
ghrelinDirectory = '/Users/atanugiri/Downloads/Saline Ghrelin Project/Ghrelin Plots';

for maze = 1:4
    dataToPlot = mazeData{maze};
    figure;
    set(gcf, 'Windowstyle', 'docked');
    for row = 1:height(dataToPlot)
        plot(dataToPlot.xcoordinates2{row}, dataToPlot.ycoordinates2{row}, '.');
        hold on;
    end
    saveas(gcf, fullfile(ghrelinDirectory, sprintf('Maze %d_%s.fig', maze, fileName)));
end