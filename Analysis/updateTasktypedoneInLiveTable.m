datasource = 'live_database';
conn = database(datasource, 'postgres', '1234');


% dateQuery = "SELECT id FROM live_table WHERE referencetime LIKE '%10/27/2023%' ORDER BY id";

dateQuery = "SELECT id, referencetime, animalid, health, notes FROM live_table WHERE " + ...
"referencetime LIKE '%11/02/2023%' AND animalid IN ('Phoebe') ORDER BY id";
dateData = fetch(conn, dateQuery);

% Specify the new value
newHealth = 'ghr toystick'; % 'sal toyrat'

% Build and execute the SQL UPDATE statement for each ID
for index = 1:length(dateData.id)
    id = dateData.id(index);
    updateSQL = sprintf("UPDATE live_table SET health = '%s' WHERE id = %d", newHealth, id);
    exec(conn, updateSQL);
end
