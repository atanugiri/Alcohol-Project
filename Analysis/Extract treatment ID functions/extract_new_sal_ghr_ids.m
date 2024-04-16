% Author: Atanu Giri
% Date: 03/21/2024
%
% New saline ghrelin dates provided by Serina
%

function [new_sal_id, new_ghr_id] = extract_new_sal_ghr_ids(varargin)

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
   conn =  varargin{1};
end

dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
allDates = fetch(conn, dateQuery);
allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
startDate = datetime('03/18/2024', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('04/10/2024', 'InputFormat', 'MM/dd/yyyy');
endDate = endDate + days(1);

dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);
idList = dataInRange.id;
idList = strjoin(arrayfun(@num2str, idList, 'UniformOutput', false), ',');

new_sal_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE id IN (%s) " + ...
"AND UPPER(subjectid) <> UPPER('none') AND LOWER(health) = 'saline' ORDER BY id", idList);
new_sal_data = fetch(conn, new_sal_Q);
new_sal_id = new_sal_data.id;

new_ghr_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE id IN (%s) " + ...
"AND UPPER(subjectid) <> UPPER('none') AND LOWER(health) = 'ghrelin' ORDER BY id", idList);
new_ghr_data = fetch(conn, new_ghr_Q);
new_ghr_id = new_ghr_data.id;

end