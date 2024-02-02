% Author: Atanu Giri
% Date: 12/11/2023

% clear; clc;
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
% dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
% allDates = fetch(conn, dateQuery);
% allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
% startDate = datetime('09/12/2023', 'InputFormat', 'MM/dd/yyyy');
% endDate = datetime('12/11/2023', 'InputFormat', 'MM/dd/yyyy');
% endDate = endDate + days(1);
% 
% dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);
% idList = dataInRange.id;

loadFile = load("emptyIDs.mat");
idList = loadFile.emptyIDs;

tableName = 'ghrelin_featuretable';

parfor index = 1:length(idList)
    id = idList(index);
    try
        [normT, normX, normY] = extractNormalizedCoordinate(id);

        norm_t_string = sprintf('ARRAY[%s]', strjoin(cellstr(num2str(normT, '%.6f')), ','));
        norm_x_string = sprintf('ARRAY[%s]', strjoin(cellstr(num2str(normX, '%.6f')), ','));
        norm_y_string = sprintf('ARRAY[%s]', strjoin(cellstr(num2str(normY, '%.6f')), ','));


        updateQuery = sprintf("UPDATE %s SET norm_t=%s, norm_x=%s, norm_y=%s " + ...
            "WHERE id=%d", tableName, norm_t_string, norm_x_string, norm_y_string, id);

        exec(conn, updateQuery);

    catch ME
        fprintf("Calculation error in %d: %s\n", id, ME.message);
        continue;
    end
end