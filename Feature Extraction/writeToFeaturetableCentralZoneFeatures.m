% Author: Atanu Giri
% Date: 11/11/2023

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

%% Add new column
% alterQuery = "ALTER TABLE ghrelin_featuretable " + ...
%     "ALTER COLUMN passing_center TYPE text, " + ...
%     "ALTER COLUMN time_in_center TYPE text";
% exec(conn, alterQuery);

tableName = 'ghrelin_featuretable';

for i = 1:length(idList)
    try
        id = idList(i);
        [passingCenter, timeInCenter] = centralZoneFeatures(id, 0.10);

        % Convert NaN values to NULL
        passingCenter = handleNaN(passingCenter);
        timeInCenter = handleNaN(timeInCenter);

        % Handle empty values
        passingCenter = handleEmpty(passingCenter);
        timeInCenter = handleEmpty(timeInCenter);

        % Convert text to double precision
        passingCenter = convertToString(passingCenter);
        timeInCenter = convertToString(timeInCenter);

        updateQuery = sprintf("UPDATE %s SET passing_center_10=%s, time_in_center_10=%s " + ...
            "WHERE id=%d", tableName, passingCenter, timeInCenter, id);

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
