datasource = 'live_database';
conn = database(datasource, 'postgres', '1234');


% dateQuery = "SELECT id FROM live_table WHERE referencetime LIKE '%10/27/2023%' ORDER BY id";

dateQuery = "SELECT id, referencetime, animalid, tasktypedone, notes FROM live_table WHERE " + ...
"referencetime LIKE '%10/31/2023%' AND animalid IN ('Phoebe') ORDER BY id";
dateData = fetch(conn, dateQuery);

% Specify the new value
newTaskType = 'ghr toystick'; % 'ghr toyrat'

% Build and execute the SQL UPDATE statement for each ID
for index = 1:length(dateData.id)
    id = dateData.id(index);
    updateSQL = sprintf("UPDATE live_table SET tasktypedone = '%s' WHERE id = %s", newTaskType, num2str(id));
    exec(conn, updateSQL);
end

% Close the database connection
close(conn);
