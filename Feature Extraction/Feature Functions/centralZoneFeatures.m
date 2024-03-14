% Author: Atanu Giri
% Date: 11/07/2023

function [passingCenter, timeInCenter, alreadyInCenter] = centralZoneFeatures(id,zoneSize,varargin)
%
% This function analyzes the trajectory of the subject and determines
% whether the subject passes through the central zone. It outputs nan if
% the subject is already present in the zone initially.
%
% id = 265219; zoneSize = 0.4;

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
    conn =  varargin{1};
end

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

    % get the index in maze array
    maze = {'maze2','maze1','maze3','maze4'};
    mazeIndex = find(ismember(maze,subject_data.mazenumber));

    [xEdge, yEdge, ~, ~] = centralZoneEdges(mazeIndex,zoneSize,feeder);

    % set playstarttrialtone and exclude the data before playstarttrialtone
    startingCoordinatetimes = t(1); %subject_data.playstarttrialtone;
    toneFilter = t >= startingCoordinatetimes;
    xAfterTone = X(toneFilter);
    yAfterTone = Y(toneFilter);
    tAfterTone = t(toneFilter);

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