% Atanu Giri
% Date: long time ago
%
% This script modifies the health column as necessary after validation 
% w.r.t. Excel sheet or notes column in live_database
%

datasource = 'live_database';
conn = database(datasource, 'postgres', '1234');

%% Change health for a range of date
dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
allDates = fetch(conn, dateQuery);
allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
startDate = datetime('04/08/2024', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('04/10/2024', 'InputFormat', 'MM/dd/yyyy');
endDate = endDate + days(1);
dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);
idList = strjoin(arrayfun(@num2str, dataInRange.id, 'UniformOutput', false), ',');

dateQuery = sprintf("SELECT id, referencetime, animalid, health, notes, tasktypedone " + ...
    "FROM live_table WHERE id IN (%s) ORDER BY id;", idList);
dateData = fetch(conn, dateQuery);

%% Change health for a single date
% dateQuery = "SELECT id, referencetime, animalid, health, notes FROM live_table WHERE " + ...
%     "referencetime LIKE '%03/18/2024%' ORDER BY id";
% dateData = fetch(conn, dateQuery);

% dateData.animalid = string(dateData.animalid);
% dateData = dateData(~ismember(dateData.animalid, ["Susan", "Linda", "Julie", "Phoebe"]),:);

% for col = 1:size(dateData)
%     dateData.(col) = string(dateData.(col));
% end

% Iterate through each row
for i = 1:size(dateData, 1)
    % Replace 'health' with 'notes'
    currentID = dateData.id(i);
    note = dateData.notes{i};

    % Update the database with the modified data for the current row
    if contains(lower(note), 'saline')
        updateQuery = sprintf("UPDATE live_table SET health='Saline' WHERE id=%d", currentID);
    elseif contains(lower(note), 'ghrelin')
        updateQuery = sprintf("UPDATE live_table SET health='Ghrelin' WHERE id=%d", currentID);
    end
    exec(conn, updateQuery);
end