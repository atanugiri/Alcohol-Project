% Author: Atanu Giri
% Date: 11/07/2023

% This function analyzes the trajectory of the subject and determines
% whether the subject passes through the central zone. It outputs nan if
% the subject is already present in the zone initially.

function [passingCenter, timeInCenter, alreadyInCenter] = centralZoneFeatures(id,zoneSize)

% id = 266670; zoneSize = 0.4;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
% write query
query = sprintf("SELECT id, subjectid, trialname, referencetime, " + ...
    "playstarttrialtone, mazenumber, feeder, trialcontrolsettings, coordinatetimes2, " + ...
    "xcoordinates2, ycoordinates2 FROM live_table WHERE id = %d", id);
subject_data = fetch(conn,query);

try
    % convert all table entries from string to usable format
    subject_data.playstarttrialtone = str2double(subject_data.playstarttrialtone);
    if isnan(subject_data.playstarttrialtone)
        subject_data.playstarttrialtone = 2;
    end
    subject_data.feeder = str2double(subject_data.feeder);
    subject_data.trialcontrolsettings = string(subject_data.trialcontrolsettings);

    if contains(subject_data.trialcontrolsettings, "Diagonal","IgnoreCase",true)
        feeder = 1;
    elseif contains(subject_data.trialcontrolsettings, "Grid","IgnoreCase",true)
        feeder = 2;
    elseif contains(subject_data.trialcontrolsettings, "Horizontal","IgnoreCase",true)
        feeder = 3;
    elseif contains(subject_data.trialcontrolsettings, "Radial","IgnoreCase",true)
        feeder = 4;
    else
        feeder = subject_data.feeder;
    end

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
    rawData = table(subject_data.(size(subject_data,2) - 2){1}, subject_data.(size(subject_data,2) - 1){1}, ...
        subject_data.(size(subject_data,2)){1}, 'VariableNames',{'t','X','Y'});

    % remove nan entries
    validIdx = all(isfinite(rawData{:,:}),2);
    cleanedData = rawData(validIdx,:);

    % invoke coordinateNormalization function to normalize the coordinates
    [normX, normY] = coordinateNormalization(cleanedData.X, cleanedData.Y, id);
    cleanedDataWithTone = table(cleanedData.t, normX, normY, ...
        'VariableNames',{'t','X','Y'});

    % set playstarttrialtone and exclude the data before playstarttrialtone
    startingCoordinatetimes = cleanedDataWithTone.t(1); %subject_data.playstarttrialtone;
    toneFilter = cleanedDataWithTone.t >= startingCoordinatetimes;
    xAfterTone = cleanedDataWithTone.X(toneFilter);
    yAfterTone = cleanedDataWithTone.Y(toneFilter);
    tAfterTone = cleanedDataWithTone.t(toneFilter);

    % get the index in maze array
    maze = {'maze2','maze1','maze3','maze4'};
    mazeIndex = find(ismember(maze,subject_data.mazenumber));
    [xEdge, yEdge, ~, ~] = centralZoneEdges(mazeIndex,zoneSize,feeder);


    % passingCenter, timeInCenter
    if any(xAfterTone >= xEdge(1) & xAfterTone <= xEdge(2) & ...
            yAfterTone >= yEdge(1) & yAfterTone <= yEdge(2))
        passingCenter = 1;
        xCenterFilter = xAfterTone >= xEdge(1) & xAfterTone <= xEdge(2);
        yCenterFilter = yAfterTone >= yEdge(1) & yAfterTone <= yEdge(2);
        tCenter = tAfterTone(xCenterFilter & yCenterFilter);
        timeInCenter = tCenter(end) - tCenter(1);

    else
        passingCenter = 0;
        timeInCenter = 0;
    end

    % alreadyInCenter
    if (xAfterTone(1) >= xEdge(1) && xAfterTone(1) <= xEdge(2)) && ...
            (yAfterTone(1) >= yEdge(1) && yAfterTone(1) <= yEdge(2))
        alreadyInCenter = 1;
    else
        alreadyInCenter = 0;
    end

catch
    fprintf("Error in centralZoneFeatures.m for id: %d\n", id);
end

%% Plot figure
% h = trajectoryPlot(id);
% fig_name = sprintf('passingCentralZone id_%d',id);
end