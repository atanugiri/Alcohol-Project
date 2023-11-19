% Author: Atanu Giri
% Date: 11/02/2023

% This function takes the id as input and uses the corresponding date
% to remove the outlier/bad data of all the trials on the date.
% The clean data is used as reference to normalize the data for plotting trajectory

function [xCleaned,yCleaned] = cleanedDataOnDate(id)
% id = 265215;

datasource = 'live_database';
conn = database(datasource,'postgres','1234');
dateQuery = sprintf("SELECT referencetime FROM live_table WHERE id = %d;", id);
subjectData = fetch(conn,dateQuery);

% drop the timestamps from referencetime for clustering
referencetime = char(subjectData.referencetime);
currentDate = referencetime(1:10);

% Select data of same date
dataOnDateQuery = strcat("SELECT id, mazenumber, truexnose, trueynose " + ...
    "FROM live_table WHERE referencetime LIKE '",sprintf('%s',currentDate), "%';");
dataOnDate = fetch(conn,dataOnDateQuery);
close(conn);


% Accessing PGArray data as double
dataOnDate.(3) = transformPgarray(dataOnDate.(3));
dataOnDate.(4) = transformPgarray(dataOnDate.(4));
dataOnDate.mazenumber = string(dataOnDate.mazenumber);

mazeLabel = {'maze 2','maze 1','maze 3','maze 4'};
mazeData = cell(1,4);
mazeData{1} = dataOnDate(dataOnDate.mazenumber == 'maze 2', :);
mazeData{2} = dataOnDate(dataOnDate.mazenumber == 'maze 1', :);
mazeData{3} = dataOnDate(dataOnDate.mazenumber == 'maze 3', :);
mazeData{4} = dataOnDate(dataOnDate.mazenumber == 'maze 4', :);

xInMaze = cell(1,4);
yInMaze = cell(1,4);

for mazeId = 1:4
    xInMaze{mazeId} = vertcat(mazeData{mazeId}.xcoordinates2{:});
    yInMaze{mazeId} = vertcat(mazeData{mazeId}.ycoordinates2{:});
end

clear mazeData;

coordinate1Filter = xInMaze{1} >=0 & yInMaze{1} >=0;
coordinate2Filter = xInMaze{2} <=0 & yInMaze{2} >=0;
coordinate3Filter = xInMaze{3} <=0 & yInMaze{3} <=0;
coordinate4Filter = xInMaze{4} >=0 & yInMaze{4} <=0;

xInMaze{1} = xInMaze{1}(coordinate1Filter); yInMaze{1} = yInMaze{1}(coordinate1Filter);
xInMaze{2} = xInMaze{2}(coordinate2Filter); yInMaze{2} = yInMaze{2}(coordinate2Filter);
xInMaze{3} = xInMaze{3}(coordinate3Filter); yInMaze{3} = yInMaze{3}(coordinate3Filter);
xInMaze{4} = xInMaze{4}(coordinate4Filter); yInMaze{4} = yInMaze{4}(coordinate4Filter);



% Create a container for clean x and y coordinates
xCleaned = cell(1,4);
yCleaned = cell(1,4);

% populate clean x and y ordiantes for each maze using loop
for maze = 1:4
    xOriginal = xInMaze{maze};
    yOriginal = yInMaze{maze};
    % clean X axis data
    indexesToKeepOfX = indexesToKeepFun(xOriginal);
    xCleanedByXAxis = xOriginal(indexesToKeepOfX);
    yCleanedByXAxis = yOriginal(indexesToKeepOfX);

    indexesToKeepOfY = indexesToKeepFun(yCleanedByXAxis);
    xCleaned{maze} = xCleanedByXAxis(indexesToKeepOfY);
    yCleaned{maze} = yCleanedByXAxis(indexesToKeepOfY);

    %% Plotting
%     figure;
%     set(gcf, 'Windowstyle', 'docked');
%     subplot(1,2,1);
%     plot(xOriginal, yOriginal, '.');
%     subplot(1,2,2);
%     plot(xCleaned{maze}, yCleaned{maze}, '.');

end

end


%% Description of transformPgarray
function transformedData = transformPgarray(pgarrayData)
transformedData = cell(length(pgarrayData),1);
for idx = 1:length(pgarrayData)
    string_all_xcoordinates = string(pgarrayData(idx,1));
    reg_all_xcoordinates = regexprep(string_all_xcoordinates,'{|}','');
    split_all_xcoordinates = split(reg_all_xcoordinates,',');
    transformedData{idx,1} = str2double(split_all_xcoordinates);
end

end

%% Description of indexesToKeepFun
function indexesToKeep = indexesToKeepFun(dataArray)
[counts, edges] = histcounts(dataArray, 100);
theCDF = rescale(cumsum(counts) / sum(counts), 0, 100);
% Find the index of the 0.1% and 99.1% points
index1 = find(theCDF > 0.1, 1, 'first');
edge1 = edges(index1);
index2 = find(theCDF > 99.9, 1, 'first');
edge2 = edges(index2);
indexesToKeep = dataArray >= edge1 & dataArray <= edge2;
end
