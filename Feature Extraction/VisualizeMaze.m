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
liveTableData.(4) = transformPgarray(liveTableData.(4));
liveTableData.(5) = transformPgarray(liveTableData.(5));

plotType = input('Ploy type? (all or session): ', 's');
if strcmpi(plotType, 'all')
    x = vertcat(liveTableData.(4){:});
    y = vertcat(liveTableData.(5){:});
    plot(x,y,'.');
end

if strcmpi(plotType, 'session')
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
            x = vertcat(currentData.(4){:});
            y = vertcat(currentData.(5){:});

            scaleType = input("Scale type? ('norm' or 'non-norm'): ", 's');

            if strcmpi(scaleType, 'non-norm')
                plot(x,y,'k.');
                hold on;
            else

            id = currentData.id(1);

%             if ismember(maze, [1, 3, 4]) % Strictly case by case
                [xNormalized, yNormalized] = ...
                    coordinateNormalization_hard_coded(x, y, maze);
%             else
%                 [xNormalized, yNormalized] = coordinateNormalization(x, y, id);
% %             end
            
            plot(xNormalized,yNormalized,'k.');
            title(sprintf('Trials: %d',height(currentData)));
            
            mazeMethods(maze,0.25,0.4);
            end % end of if-else
        end % End of maze 1
        
        sgtitle(sprintf('%s', dateList(date)));

    end % end of date 1
end


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
