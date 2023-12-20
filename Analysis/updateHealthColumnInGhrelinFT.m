datasource = 'live_database';
conn = database(datasource, 'postgres', '1234');

%% Change health for a range of date
% dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
% allDates = fetch(conn, dateQuery);
% allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
% startDate = datetime('09/12/2023', 'InputFormat', 'MM/dd/yyyy');
% endDate = datetime('11/30/2023', 'InputFormat', 'MM/dd/yyyy');
% endDate = endDate + days(1);
% dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);
% idList = strjoin(arrayfun(@num2str, dataInRange.id, 'UniformOutput', false), ',');
% 
% dateQuery = sprintf("SELECT id, referencetime, animalid, health, notes, tasktypedone " + ...
%     "FROM live_table WHERE id IN (%s) ORDER BY id;", idList);
% dateData = fetch(conn, dateQuery);

%% Change health for a single date
dateQuery = "SELECT id, referencetime, animalid, health, notes FROM live_table WHERE " + ...
    "referencetime LIKE '%12/11/2023%' ORDER BY id";
dateData = fetch(conn, dateQuery);

% dateData.animalid = string(dateData.animalid);
% dateData = dateData(~ismember(dateData.animalid, ["Susan", "Linda", "Julie", "Phoebe"]),:);

% Iterate through each row
for i = 1:size(dateData, 1)
    % Replace 'health' with 'notes'
    newHealth = dateData.notes{i};
% newHealth = "Ghrelin ToySkewer";

    % Update the database with the modified data for the current row
    updateQuery = sprintf("UPDATE live_table SET health='%s' WHERE id=%d", ...
        newHealth, dateData.id(i));
    exec(conn, updateQuery);
end
