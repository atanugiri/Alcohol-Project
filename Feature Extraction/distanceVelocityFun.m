function [distanceUntilLimitingTimeStamp,velocityUntilLimitingTimeStamp] = distanceVelocityFun(id)

id = 265218;
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% write query
query = sprintf("SELECT id, coordinatetimes2, " + ...
    "xcoordinates2, ycoordinates2 FROM live_table WHERE id = %d", id);
subject_data = fetch(conn,query);

try
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
    [X, Y] = coordinateNormalization(cleanedData.X, cleanedData.Y, id);
    t = cleanedData.t;

    limitingTimeIndex = find(t == 15);

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
