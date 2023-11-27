% Author: Atanu Giri
% Date: 11/22/2023

function [entryTime,logicalApproach,logicalApproach3s] = entryExitTimeStamp_ver2(id)

% id = 265378;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% write query
query = sprintf("SELECT id, subjectid, trialname, referencetime, " + ...
    "playstarttrialtone, mazenumber, feeder, trialcontrolsettings, coordinatetimes2, " + ...
    "truexnose, trueynose FROM live_table WHERE id = %d", id);
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

    % remove space from mazenumber
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
    rawData = table(subject_data.coordinatetimes2{1}, subject_data.truexnose{1}, ...
        subject_data.trueynose{1}, 'VariableNames',{'t','X','Y'});

    % remove nan entries
    validIdx = all(isfinite(rawData{:,:}),2);
    cleanedData = rawData(validIdx,:);

    maze = {'maze2','maze1','maze3','maze4'};
    % get the index in maze array
    mazeIndex = find(ismember(maze,subject_data.mazenumber));

    % invoke coordinateNormalization function to normalize the coordinates
%     [normX, normY] = coordinateNormalization(cleanedData.X, cleanedData.Y, id);
    [normX, normY] = coordinateNormalization_hard_coded(cleanedData.X, ...
        cleanedData.Y, mazeIndex);
    cleanedDataWithTone = table(cleanedData.t, normX, normY, ...
        'VariableNames',{'t','X','Y'});

    [~, ~, xEdgeReward, yEdgeReward] = centralZoneEdges(mazeIndex,0.4,feeder,0.15);

    %% entrytime, logicalApproach
    pcFilter = cleanedDataWithTone.t >= 12 & cleanedDataWithTone.t <= 25;
    xPCrange = cleanedDataWithTone.X(pcFilter); % pc = present cost
    yPCrange = cleanedDataWithTone.Y(pcFilter);
    tPCrange = cleanedDataWithTone.t(pcFilter);


    if any(xPCrange >= xEdgeReward(1) & xPCrange <= xEdgeReward(2) & ...
            yPCrange >= yEdgeReward(1) & yPCrange <= yEdgeReward(2))
        logicalApproach = 1;
    else
        logicalApproach = 0;
    end

    if logicalApproach == 0
        entryTime = [];

    elseif logicalApproach == 1
        for i = 1:length(xPCrange)
            if xPCrange(i) >= xEdgeReward(1) && xPCrange(i) <= xEdgeReward(2) && ...
                    yPCrange(i) >= yEdgeReward(1) && yPCrange(i) <= yEdgeReward(2)
                entryTime = tPCrange(i) - tPCrange(1);
                break;
            end
        end

    else
        entryTime = -9999;
    end

    %% logicalApproach3s
    if isempty(entryTime)
        logicalApproach3s = 0;
    else
        xFeederFilter = xPCrange >= xEdgeReward(1) & xPCrange <= xEdgeReward(2);
        yFeederFilter = yPCrange >= yEdgeReward(1) & yPCrange <= yEdgeReward(2);
        timeInFeeder = tPCrange(xFeederFilter & yFeederFilter);
        timeInFeeder = length(timeInFeeder)*0.1;

        if timeInFeeder >= 3
            logicalApproach3s = 1;
        else
            logicalApproach3s = 0;
        end
    end

catch
    sprintf("An error occured for id = %d\n", id);
end

%% Plotting
% h = trajectoryPlot(id);
end