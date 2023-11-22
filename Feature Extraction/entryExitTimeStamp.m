% Author: Atanu Giri
% Date: 11/09/2023

function [entryTime,exitTime,logicalApproach,logicalApproach5s] = entryExitTimeStamp(id)

% id = 266661;
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
    toneFilter = cleanedDataWithTone.t >= startingCoordinatetimes;
    xAfterTone = cleanedDataWithTone.X(toneFilter);
    yAfterTone = cleanedDataWithTone.Y(toneFilter);
    tAfterTone = cleanedDataWithTone.t(toneFilter);

    % set flags
    toneTimeIndex = find(cleanedDataWithTone.t == startingCoordinatetimes);
    limitingTimeIndex = find(tAfterTone == 20);
    maze = {'maze2','maze1','maze3','maze4'};

    % get the index in maze array
    mazeIndex = find(ismember(maze,subject_data.mazenumber));

    [~, ~, xEdgeReward, yEdgeReward] = centralZoneEdges(mazeIndex,0.4,feeder,0.20);

    %% entrytime, exittime, logicalApproach
    if any(xAfterTone >= xEdgeReward(1) & xAfterTone <= xEdgeReward(2) & ...
            yAfterTone >= yEdgeReward(1) & yAfterTone <= yEdgeReward(2))
        logicalApproach = 1;
    else
        logicalApproach = 0;
    end

    if logicalApproach == 0
        entryTime = [];
    
    elseif logicalApproach == 1
        for i = 1:length(xAfterTone)
            if xAfterTone(i) >= xEdgeReward(1) && xAfterTone(i) <= xEdgeReward(2) && ...
                    yAfterTone(i) >= yEdgeReward(1) && yAfterTone(i) <= yEdgeReward(2)
                entryPointIndex = i;
                entryTime = tAfterTone(i) - tAfterTone(1);
                break;
            end
        end

    else
        entryTime = -9999;
    end

    % Check if entry point was found
    if isempty(entryTime)
        exitTime = [];
    else
        for i = entryPointIndex+1:length(xAfterTone)
            % Check if current x and y coordinates are outside rectangular zone
            if xAfterTone(i) < xEdgeReward(1) || xAfterTone(i) > xEdgeReward(2) || ...
                    yAfterTone(i) < yEdgeReward(1) || yAfterTone(i) > yEdgeReward(2)
                exitPointIndex = i;
                exitTime = tAfterTone(i) - tAfterTone(1);

                %                 plot(xAfterTone(i),yAfterTone(i),'ko','MarkerSize',10,'LineWidth',2);
                break;
            else
                exitPointIndex = nan;
                exitTime = -9999;
            end
        end
    end

    %% logicalApproach2s
    if isempty(entryTime)
        logicalApproach5s = 0;
    else
        xFeederFilter = xAfterTone >= xEdgeReward(1) & xAfterTone <= xEdgeReward(2);
        yFeederFilter = yAfterTone >= yEdgeReward(1) & yAfterTone <= yEdgeReward(2);
        timeInFeeder = tAfterTone(xFeederFilter & yFeederFilter);
        timeInFeeder = length(timeInFeeder)*0.1;

        if timeInFeeder >= 5
            logicalApproach5s = 1;
        else
            logicalApproach5s = 0;
        end
    end


catch
    sprintf("An error occured for id = %d\n", id);
end

%% Plotting
% h = trajectoryPlot(id);
end