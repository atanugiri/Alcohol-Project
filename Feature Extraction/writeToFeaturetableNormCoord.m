% clear; clc;
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

for index = 1:length(idList)
    id = idList(index);
    try
        [normT, normX, normY] = extractNormalizedCoordinate(id);

        % Check for NaN values and convert them to NULL
        normT = handleNaN(normT);
        normX = handleNaN(normX);
        normY = handleNaN(normY);

        updateQuery = sprintf("UPDATE %s SET norm_t=%f, norm_x=%f, norm_y=%f " + ...
            "WHERE id=%d", tableName, normT, normX, normY, id);

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
