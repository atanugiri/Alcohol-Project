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

tableName = 'ghrelin_featuretable';

%% Add new column
% alterQuery = "ALTER TABLE ghrelin_featuretable " + ...
%     "ADD COLUMN passing_center text, " + ...
%     "ADD COLUMN time_in_center text";
% exec(conn, alterQuery);

% Iterate over 'id' values and call the function
for i = 1:length(idList)
    try
        id = idList(i);
        [passingCenter, timeInCenter] = centralZoneFeatures(id,0.4);

        % Convert NaN values to 'NULL' for text columns
        passingCenter = num2str(passingCenter);
        timeInCenter = num2str(timeInCenter);

        passingCenter = strrep(passingCenter, 'NaN', 'NULL');
        timeInCenter = strrep(timeInCenter, 'NaN', 'NULL');

        % Handle empty strings
        if isempty(passingCenter)
            passingCenter = 'NULL';
        end
        if isempty(timeInCenter)
            timeInCenter = 'NULL';
        end

       updateQuery = sprintf("UPDATE %s SET passing_center=%s, time_in_center=%s " + ...
            "WHERE id=%d", tableName, passingCenter, timeInCenter, id);

    catch
        fprintf("Error in writeToFeaturetable for id = %d\n", id);
        continue;
    end
end
