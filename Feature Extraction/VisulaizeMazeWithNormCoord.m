% Author: Atanu Giri
% Date: 01/15/2024

%
% This function gives normalized scatter plot for all animal trajectories
% for the session
%

datasource = 'live_database';
conn = database(datasource,'postgres','1234');
dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
allDates = fetch(conn, dateQuery);
allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
allDates = sortrows(allDates, 'referencetime');
startDate = datetime('09/12/2023', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('09/20/2023', 'InputFormat', 'MM/dd/yyyy');
endDate = endDate + days(1);

dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);

idList = strjoin(arrayfun(@num2str, dataInRange.id, 'UniformOutput', false), ',');

liveTableQuery = sprintf("SELECT id, referencetime, mazenumber " + ...
    "FROM live_table WHERE id IN (%s) ORDER BY id;", idList);
liveTableData = fetch(conn, liveTableQuery);

featuretableQurey = sprintf("SELECT id, norm_x, norm_y FROM ghrelin_featuretable " + ...
    "WHERE id IN (%s) ORDER BY id", idList);
featuretableData = fetch(conn, featuretableQurey);

liveTableData = innerjoin(liveTableData, featuretableData, 'Keys', 'id');


liveTableData.referencetime = datetime(liveTableData.referencetime, 'Format', 'MM/dd/yyyy');
liveTableData.mazenumber = string(liveTableData.mazenumber);
liveTableData.(size(liveTableData,2) - 1) = transformPgarray(liveTableData.(size(liveTableData,2) - 1));
liveTableData.(size(liveTableData,2)) = transformPgarray(liveTableData.(size(liveTableData,2)));


liveTableData.referencetime = string(liveTableData.referencetime);
dateList = unique(liveTableData.referencetime);

for date = 1:length(dateList)
    dateData = liveTableData(liveTableData.referencetime == dateList(date), :);
    mazeData = cell(1,4);
    mazeData{1} = dateData(dateData.mazenumber == "maze 2", :);
    mazeData{2} = dateData(dateData.mazenumber == "maze 1", :);
    mazeData{3} = dateData(dateData.mazenumber == "maze 3", :);
    mazeData{4} = dateData(dateData.mazenumber == "maze 4", :);

    figure(date);
    set(gcf, 'Windowstyle', 'docked');

    for maze = 1:4
        if maze == 1
            subplot(2,2,2);
        elseif maze == 2
            subplot(2,2,1);
        else
            subplot(2,2,maze);
        end

        hold on;
        currentData = mazeData{maze};
        x = vertcat(currentData.(size(liveTableData,2) - 1){:});
        y = vertcat(currentData.(size(liveTableData,2)){:});

        plot(x,y,'k.');

        title(sprintf('Trials: %d',height(currentData)));

        mazeMethods(maze,0.25,0.5);
    end % End of maze 1

    sgtitle(sprintf('%s', dateList(date)));

end % end of date 1


%% Description of transformPgarray
function transformedData = transformPgarray(pgarrayData)

% pgarrayData = liveTableData.(3); % For testing
transformedData = cell(length(pgarrayData),1);
for idx = 1:length(pgarrayData)
    string_all_xcoordinates = string(pgarrayData(idx,1));
    reg_all_xcoordinates = regexprep(string_all_xcoordinates,'{|}','');
    split_all_xcoordinates = split(reg_all_xcoordinates,',');
    transformedData{idx,1} = str2double(split_all_xcoordinates);
end

end
