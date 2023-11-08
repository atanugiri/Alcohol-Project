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

% Iterate over 'id' values and call the function
for i = 1:length(idList)
    try
        id = idList(i);
        [passingCenter, timeInCenter] = centralZoneFeatures(id,0.4);

        % Check if result is NaN and handle accordingly
        if isnan(passingCenter)
            query = sprintf("INSERT INTO %s (id, passingCenter, timeInCenter) " + ...
                "VALUES (%d, NULL, %f)", tableName, id, timeInCenter);
        
        elseif isequal(passingCenter, 1)
            query = sprintf("INSERT INTO %s (id, passingCenter, timeInCenter) " + ...
                "VALUES (%d, %f, %f)", tableName, id, passingCenter, timeInCenter);

        else
            query = sprintf("INSERT INTO %s (id, passingCenter, timeInCenter) " + ...
                "VALUES (%d, %f, NULL)", tableName, id, passingCenter);
        end

        exec(conn, query);

    catch
        fprintf("Error in writeToFeaturetable for id = %d\n", id);
        continue;
    end
end
