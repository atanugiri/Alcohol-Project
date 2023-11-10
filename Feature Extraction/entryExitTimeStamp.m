function [entryTime,exitTime,logicalApproach,logicalApproach2s] = entryExitTimeStamp(id)

% id = 265215;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% write query
query = sprintf("SELECT id, subjectid, trialname, referencetime, " + ...
    "playstarttrialtone, mazenumber, feeder, coordinatetimes2, xcoordinates2, " + ...
    "ycoordinates2 FROM live_table WHERE id = %d", id);
subject_data = fetch(conn,query);

try
    % convert all table entries from string to usable format
    subject_data.playstarttrialtone = str2double(subject_data.playstarttrialtone);
    if isnan(subject_data.playstarttrialtone)
        subject_data.playstarttrialtone = 2;
    end
    subject_data.feeder = str2double(subject_data.feeder);
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
    feeder = subject_data.feeder;

    [~, ~, xEdgeOfFeeder, yEdgeOfFeeder] = centralZoneEdges(mazeIndex,0.4,feeder);
    
    %% entrytime, exittime, logicalApproach
    entryTime = nan;
    for i = 1:length(xAfterTone)
        if (xAfterTone(i) >= xEdgeOfFeeder(1) && xAfterTone(i) <= xEdgeOfFeeder(2)) && ...
                (yAfterTone(i) >= yEdgeOfFeeder(1) && yAfterTone(i) <= yEdgeOfFeeder(2))
            entryPointIndex = i;
            entryTime = tAfterTone(i) - tAfterTone(1);
            break;
        end
    end
    
    % Check if entry point was found
    if isnan(entryTime)
        exitTime = nan;
    else
        for i = entryPointIndex+1:length(xAfterTone)
            % Check if current x and y coordinates are outside rectangular zone
            if xAfterTone(i) < xEdgeOfFeeder(1) || xAfterTone(i) > xEdgeOfFeeder(2) || ...
                    yAfterTone(i) < yEdgeOfFeeder(1) || yAfterTone(i) > yEdgeOfFeeder(2)
                exitPointIndex = i;
                exitTime = tAfterTone(i) - tAfterTone(1);

%                 plot(xAfterTone(i),yAfterTone(i),'ko','MarkerSize',10,'LineWidth',2);
                break;
            else
                exitPointIndex = nan;
                exitTime = nan;
            end
        end
    end

    if isnan(entryTime)
        logicalApproach = 0;
    else
        logicalApproach = 1;
    end

    %% logicalApproach2s
    if isnan(entryTime)
        logicalApproach2s = 0;
    else
        xFeederFilter = xAfterTone >= xEdgeOfFeeder(1) & xAfterTone <= xEdgeOfFeeder(2);
        yFeederFilter = yAfterTone >= yEdgeOfFeeder(1) & yAfterTone <= yEdgeOfFeeder(2);
        timeInFeeder = tAfterTone(xFeederFilter & yFeederFilter);
        timeInFeeder = length(timeInFeeder)*0.1;
        
        if timeInFeeder >= 2
            logicalApproach2s = 1;
        else
            logicalApproach2s = 0;
        end
    end
    

catch
    sprintf("An error occured for id = %d\n", id);
end

%% Plotting
% h = trajectoryPlot(id);
end