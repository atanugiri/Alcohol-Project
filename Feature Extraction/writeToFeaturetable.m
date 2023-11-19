% clear; clc;
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
allDates = fetch(conn, dateQuery);
allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
startDate = datetime('09/25/2023', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('09/27/2023', 'InputFormat', 'MM/dd/yyyy');
endDate = endDate + days(1);

dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);
idList = dataInRange.id;

tableName = 'ghrelin_featuretable';

%% Add new columns example
% alterQuery = "ALTER TABLE ghrelin_featuretable " + ...
%     "ADD COLUMN entry_time text, " + ...
%     "ADD COLUMN exit_time text, " + ...
%     "ADD COLUMN logical_approach text, " + ...
%     "ADD COLUMN logical_approach_2s text";
% exec(conn, alterQuery);

for index = 1:length(idList)
    id = idList(index);
    try
        [entryTime, exitTime, logicalApproach, logicalApproach5s] = entryExitTimeStamp(id);

        % Convert NaN values to NULL
        entryTime = handleNaN(entryTime);
        exitTime = handleNaN(exitTime);
        logicalApproach = handleNaN(logicalApproach);
        logicalApproach5s = handleNaN(logicalApproach5s);

        % Handle empty values
        entryTime = handleEmpty(entryTime);
        exitTime = handleEmpty(exitTime);
        logicalApproach = handleEmpty(logicalApproach);
        logicalApproach5s = handleEmpty(logicalApproach5s);

        % Convert NaN values to 'NULL' for text columns
        entryTime = convertToString(entryTime);
        exitTime = convertToString(exitTime);
        logicalApproach = convertToString(logicalApproach);
        logicalApproach5s = convertToString(logicalApproach5s);

        updateQuery = sprintf("UPDATE %s SET entry_time_nose_20=%s, exit_time_nose_20=%s, " + ...
            "logical_approach_nose_20=%s, logical_approach_nose_5s_20=%s WHERE id=%d", tableName, ...
            entryTime, exitTime, logicalApproach, logicalApproach5s, id);

        exec(conn, updateQuery);

    catch ME
        fprintf("Calculation error in %d: %s\n", id, ME.message);
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