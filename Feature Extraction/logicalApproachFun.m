% Author: Atanu Giri
% Date: 11/22/2023

function [logicalApproach, timeInFeeder, entryTime] = logicalApproachFun(id)

% id = 265227;
% make connection with database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% write query
liveTableQuery = sprintf("SELECT id, subjectid, trialname, referencetime, " + ...
    "playstarttrialtone, mazenumber, feeder, trialcontrolsettings " + ...
    "FROM live_table WHERE id = %d", id);
liveTableData = fetch(conn, liveTableQuery);

featureTableQuery = sprintf("SELECT id, norm_t, norm_x, norm_y FROM " + ...
    "ghrelin_featuretable WHERE id = %d", id);
featureTableData = fetch(conn, featureTableQuery);

subject_data = innerjoin(liveTableData, featureTableData, 'Keys', 'id');

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

    t = subject_data.norm_t{1};
    X = subject_data.norm_x{1};
    Y = subject_data.norm_y{1};

    maze = {'maze2','maze1','maze3','maze4'};
    % get the index in maze array
    mazeIndex = find(ismember(maze, subject_data.mazenumber));

    [~, ~, xEdgeReward, yEdgeReward] = centralZoneEdges(mazeIndex,0.4,feeder,0.20);

    %% logicalApproach
    pcFilter = t >= 2 & t <= 15; % pc = present cost
    xPCrange = X(pcFilter); 
    yPCrange = Y(pcFilter);
    tPCrange = t(pcFilter);

    if any(xPCrange >= xEdgeReward(1) & xPCrange <= xEdgeReward(2) & ...
            yPCrange >= yEdgeReward(1) & yPCrange <= yEdgeReward(2))
        logicalApproach = 1;
    else
        logicalApproach = 0;
    end


    %% timeInFeeder
    if ~isequal(logicalApproach,1)
        timeInFeeder = 0;
    else
        xFeederFilter = xPCrange >= xEdgeReward(1) & xPCrange <= xEdgeReward(2);
        yFeederFilter = yPCrange >= yEdgeReward(1) & yPCrange <= yEdgeReward(2);
        timeInFeeder = tPCrange(xFeederFilter & yFeederFilter);
        timeInFeeder = length(timeInFeeder)*0.1;
    end

    %% Entrytime
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

catch
    sprintf("An error occured for id = %d\n", id);
end

%% Plotting
% h = trajectoryPlot(id);
end