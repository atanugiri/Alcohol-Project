% Author: Atanu Giri
% Date: 12/08/2023

datasource = 'live_database';
conn = database(datasource,'postgres','1234');
dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
allDates = fetch(conn, dateQuery);
allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
startDate = datetime('09/12/2023', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('10/31/2023', 'InputFormat', 'MM/dd/yyyy');
endDate = endDate + days(1);

dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);
idList = dataInRange.id;

tableName = 'ghrelin_featuretable';

for i = 1:length(idList)
    try
        id = idList(i);
        [distanceUntilLimitingTimeStamp,velocityUntilLimitingTimeStamp] = distanceVelocityFun(id);

        % Convert NaN values to NULL
        distanceUntilLimitingTimeStamp = handleNaN(distanceUntilLimitingTimeStamp);
        velocityUntilLimitingTimeStamp = handleNaN(velocityUntilLimitingTimeStamp);

        % Handle empty values
        distanceUntilLimitingTimeStamp = handleEmpty(distanceUntilLimitingTimeStamp);
        velocityUntilLimitingTimeStamp = handleEmpty(velocityUntilLimitingTimeStamp);

        % Convert text to double precision
        distanceUntilLimitingTimeStamp = convertToString(distanceUntilLimitingTimeStamp);
        velocityUntilLimitingTimeStamp = convertToString(velocityUntilLimitingTimeStamp);

        updateQuery = sprintf("UPDATE %s SET distance_until_limiting_time_stamp=%s, " + ...
            "velocity_until_limiting_time_stamp=%s WHERE id=%d", tableName, distanceUntilLimitingTimeStamp, ...
            velocityUntilLimitingTimeStamp, id);

        % Execute the update query here
        exec(conn,updateQuery);

    catch exception
        fprintf("Error in writeToFeaturetable for id = %d: %s\n", id, exception.message);
        continue;
    end
end

function value = handleNaN(value)
    if isnan(value)
        value = 'NULL';
    end
end

function value = handleEmpty(value)
    if isempty(value)
        value = 'NULL';
    end
end

function value = convertToString(value)
    % Convert to numeric if not NaN or empty
    if all(~isnan(value)) && all(~isempty(value))
        value = num2str(value); % Convert to string for uniformity
    end
end
