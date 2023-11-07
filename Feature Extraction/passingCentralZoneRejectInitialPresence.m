% Author: Atanu Giri
% Date: 12/12/2022
% This function analyzes the trajectory of the subject and determines
% whether the subject passes through the central zone. It outputs nan if
% the subject is already present in the zone initially.

function result = passingCentralZoneRejectInitialPresence(id,zoneSize)
% close all; clc;
% id = 137351; zoneSize = 0.5;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
% write query
query = sprintf("SELECT id, subjectid, trialname, referencetime, " + ...
    "playstarttrialtone, mazenumber, feeder, coordinatetimes2, xcoordinates2, " + ...
    "ycoordinates2  FROM live_table WHERE id = %d", id);
subject_data = fetch(conn,query);

try
    % convert all table entries from string to usable format
    subject_data.playstarttrialtone = str2double(subject_data.playstarttrialtone);
    subject_data.feeder = str2double(subject_data.feeder);
    subject_data.mazenumber = char(lower(strrep(subject_data.mazenumber,' ','')));

    % Accessing PGArray data as double
    for column = size(subject_data,2) - 2:size(subject_data,2)
        stringAllRows = string(subject_data.(column));
        regAllRows = regexprep(stringAllRows,'{|}','');
        splitAllRows = split(regAllRows,',');
        doubleData = str2double(splitAllRows);
        subject_data.(column){1} = doubleData;
    end

    % includes the data before playstarttrialtone
    rawData = table(subject_data.coordinatetimes2{1}, subject_data.xcoordinates2{1}, ...
        subject_data.ycoordinates2{1}, 'VariableNames',{'t','X','Y'});

    % remove nan entries
    validIdx = all(isfinite(rawData{:,:}),2);
    cleanedData = rawData(validIdx,:);

    % invoke coordinateNormalization function to normalize the coordinates
    [normX, normY] = coordinateNormalization(cleanedData.X, cleanedData.Y, id);
    cleanedDataWithTone = table(cleanedData.t, normX, normY, ...
        'VariableNames',{'t','X','Y'});

    % set playstarttrialtone and exclude the data before playstarttrialtone
    startingCoordinatetimes = subject_data.playstarttrialtone;
    xNormalized = cleanedDataWithTone.X(cleanedDataWithTone.t >= startingCoordinatetimes);
    yNormalized = cleanedDataWithTone.Y(cleanedDataWithTone.t >= startingCoordinatetimes);

    % set figure limit
    maze = {'maze2','maze1','maze3','maze4'};
    % get the index in maze array
    mazeIndex = find(ismember(maze,subject_data.mazenumber));
    feeder = subject_data.feeder;
    [xEdge, yEdge, ~, ~] = centralZoneEdges(mazeIndex,zoneSize,feeder);
    result = 0;
    % return nan if the subject already present in the central zone
    if (xNormalized(1) > xEdge(1) && xNormalized(1) < xEdge(2)) && ...
            (yNormalized(1) > yEdge(1) && yNormalized(1) < yEdge(2))
        result = nan;
        % check if trajectory goes through central zone
    else
        for i = 1:length(xNormalized)
            if (xNormalized(i) > xEdge(1) && xNormalized(i) < xEdge(2)) && ...
                    (yNormalized(i) > yEdge(1) && yNormalized(i) < yEdge(2))
                result = 1;
            end
        end
    end

catch
    fprintf("Error in passingCentralZoneRejectInitialPresence.m for id: %d\n", id);
end
%% Plot figure
% h = trajectoryPlot(id);
% fig_name = sprintf('passingCentralZone id_%d',id);
end