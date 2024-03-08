function [distanceUntilLimitingTimeStamp,velocityUntilLimitingTimeStamp] = distanceVelocityFun(id)

% id = 265302;
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% write query
query = sprintf("SELECT id, norm_t, " + ...
    "norm_x, norm_y FROM ghrelin_featuretable WHERE id = %d", id);
subject_data = fetch(conn,query);

liveTableQuery = sprintf("SELECT id, playstarttrialtone " + ...
    "FROM live_table WHERE id = %d", id);
liveTableData = fetch(conn, liveTableQuery);

subject_data = innerjoin(liveTableData, subject_data, 'Keys', 'id');

try
    subject_data.playstarttrialtone = str2double(subject_data.playstarttrialtone);
    if isnan(subject_data.playstarttrialtone)
        subject_data.playstarttrialtone = 2;
    end

    % Accessing PGArray data as double
    for column = size(subject_data,2) - 2:size(subject_data,2)
        stringAllRows = string(subject_data.(column));
        regAllRows = regexprep(stringAllRows,'{|}','');
        splitAllRows = split(regAllRows,',');
        doubleData = str2double(splitAllRows);
        subject_data.(column){1} = doubleData;
    end

    X = subject_data.norm_x{1};
    Y = subject_data.norm_y{1};
    t = subject_data.norm_t{1};

    % Remove time stamps before tone
    startingCoordinatetimes = subject_data.playstarttrialtone;
    X = X(t >= startingCoordinatetimes);
    Y = Y(t >= startingCoordinatetimes);
    t = t(t >= startingCoordinatetimes);

    limitingTimeIndex = find(t == 20);

    distanceUntilLimitingTimeStamp = 0;
    for i = 1:length(X(1:limitingTimeIndex))-1
        distanceUntilLimitingTimeStamp = distanceUntilLimitingTimeStamp + ...
            sqrt((X(i+1)-X(i))^2 + (Y(i+1)-Y(i))^2);
    end

    velocityUntilLimitingTimeStamp = distanceUntilLimitingTimeStamp/ ...
        (t(limitingTimeIndex) - t(1));

catch
    sprintf("An error occured for id = %d\n", id);
end
end
