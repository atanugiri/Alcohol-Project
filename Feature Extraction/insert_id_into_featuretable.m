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

% Iterate over 'id' values
for i = 1:length(idList)
    try
        id = idList(i);
        query = sprintf("INSERT INTO %s (id) VALUES (%d)", tableName, id);
        exec(conn,query);

    catch exception
       fprintf("Error in insert_id for id = %d\n", id);
       disp(exception.message);
    end
end

close(conn);  % Close the database connection