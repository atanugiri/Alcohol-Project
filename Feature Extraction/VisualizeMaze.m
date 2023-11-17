% Author: Atanu Giri
% Date: 11/15/2023

datasource = 'live_database';
conn = database(datasource,'postgres','1234');
dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
allDates = fetch(conn, dateQuery);
allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
startDate = datetime('09/12/2023', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('10/31/2023', 'InputFormat', 'MM/dd/yyyy');
endDate = endDate + days(1);

dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);

idList = strjoin(arrayfun(@num2str, dataInRange.id, 'UniformOutput', false), ',');

liveTableQuery = sprintf("SELECT id, referencetime, mazenumber, xcoordinates2, " + ...
    "ycoordinates2 FROM live_table WHERE id IN (%s) ORDER BY id;", idList);
liveTableData = fetch(conn, liveTableQuery);
close(conn);

liveTableData.referencetime = datetime(liveTableData.referencetime, 'Format', 'MM/dd/yyyy');
liveTableData.mazenumber = string(liveTableData.mazenumber);
liveTableData.xcoordinates2 = transformPgarray(liveTableData.xcoordinates2);
liveTableData.ycoordinates2 = transformPgarray(liveTableData.ycoordinates2);

plotType = input('Ploy type? (all or session): ', 's');
if strcmpi(plotType, 'all')
    x = vertcat(liveTableData.xcoordinates2{:});
    y = vertcat(liveTableData.ycoordinates2{:});
    plot(x,y,'.');
end

if strcmpi(plotType, 'session')
    liveTableData.referencetime = string(liveTableData.referencetime);
    dateList = unique(liveTableData.referencetime);

    for date = 5:6 %1:length(dateList)
        dateData = liveTableData(liveTableData.referencetime == dateList(date), :);
        mazeData = cell(1,4);
        mazeData{1} = dateData(dateData.mazenumber == "maze 1", :);
        mazeData{2} = dateData(dateData.mazenumber == "maze 2", :);
        mazeData{3} = dateData(dateData.mazenumber == "maze 3", :);
        mazeData{4} = dateData(dateData.mazenumber == "maze 4", :);

        figure(date);
        set(gcf, 'Windowstyle', 'docked');

        for maze = 1:4
            subplot(2,2,maze);
            hold on;
            currentData = mazeData{maze};
            x = vertcat(currentData.xcoordinates2{:});
            y = vertcat(currentData.ycoordinates2{:});
            id = currentData.id(1);
            [xNormalized, yNormalized] = coordinateNormalization(x, y, id);
            plot(xNormalized,yNormalized,'k.');
            title(sprintf('Trials: %d',height(currentData)));
            plotFeeders(maze);
        end % End of maze 1
        sgtitle(sprintf('%s', dateList(date)));

    end % end of date 1
end


%% Description of transformPgarray
function transformedData = transformPgarray(pgarrayData)

% pgarrayData = liveTableData.xcoordinates2; % For testing
transformedData = cell(length(pgarrayData),1);
for idx = 1:length(pgarrayData)
    string_all_xcoordinates = string(pgarrayData(idx,1));
    reg_all_xcoordinates = regexprep(string_all_xcoordinates,'{|}','');
    split_all_xcoordinates = split(reg_all_xcoordinates,',');
    transformedData{idx,1} = str2double(split_all_xcoordinates);
end

end

%% Description of plot feeder
function plotFeeders(maze)
grayFace = [0.3 0.3 0.3 0.3];
switch maze
    case 1
        rectangle('Position',[-1.05 0.75 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        rectangle('Position',[-1.05 -0.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        rectangle('Position',[-0.25 -0.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        rectangle('Position',[-0.25 0.75 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);

    case 2
        rectangle('Position',[0.75 -0.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        rectangle('Position',[-0.05 -0.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        rectangle('Position',[-0.05 0.75 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        rectangle('Position',[0.75 0.75 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
    case 3
        rectangle('Position',[-0.25 -1.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        rectangle('Position',[-0.25 -0.25 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        rectangle('Position',[-1.05 -0.25 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        rectangle('Position',[-1.05 -1.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
    case 4
        rectangle('Position',[-0.05 -0.25 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        rectangle('Position',[0.75 -0.25 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        rectangle('Position',[0.75 -1.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        rectangle('Position',[-0.05 -1.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
end
end