% Author: Atanu Giri
% Date: 01/02/2024

function [Sal_P2L1_id, Ghr_P2L1_id, Sal_P2L1L3_id, Ghr_P2L1L3_id] = extract_sal_ghr_ids

datasource = 'live_database';
conn = database(datasource,'postgres','1234');
dateQuery = "SELECT id, referencetime, health, tasktypedone, subjectid FROM live_table " + ...
    "ORDER BY id";

allData = fetch(conn, dateQuery);
allData.referencetime = datetime(allData.referencetime, 'Format', 'MM/dd/yyyy');
allData.health = string(allData.health);
allData.subjectid = string(allData.subjectid);

allData(allData.subjectid == "none",:) = [];

startDate = datetime('06/27/2022', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('08/04/2022', 'InputFormat', 'MM/dd/yyyy');

endDate = endDate + days(1);
dataInRange = allData(allData.referencetime >= startDate & allData.referencetime <= endDate, :);

% Sal P2L1 ids
Sal_health_filter = contains(strrep(dataInRange.health, ' ',''), ...
    strrep("Hour Saline",' ',''), "IgnoreCase", true);
P2L1_task_filter = contains(strrep(dataInRange.tasktypedone, ' ',''), ...
    strrep("P2L1",' ',''), "IgnoreCase", true);

Sal_P2L1_data = dataInRange(Sal_health_filter & P2L1_task_filter, :);
Sal_P2L1_id = Sal_P2L1_data.id;

% Ghr P2L1 ids
Ghr_health_filter = contains(strrep(dataInRange.health, ' ',''), ...
    strrep("Hour Ghrelin",' ',''), "IgnoreCase", true) | ...
    contains(strrep(dataInRange.health, ' ',''), ...
    strrep("Hours Ghrelin",' ',''), "IgnoreCase", true);

Ghr_P2L1_data = dataInRange(Ghr_health_filter & P2L1_task_filter, :);
Ghr_P2L1_id = Ghr_P2L1_data.id;

% Sal P2L1L3 ids
P2L1L3_task_filter = contains(strrep(dataInRange.tasktypedone, ' ',''), ...
    strrep("P2L1L3",' ',''), "IgnoreCase", true);

Sal_P2L1L3_data = dataInRange(Sal_health_filter & P2L1L3_task_filter, :);
Sal_P2L1L3_id = Sal_P2L1L3_data.id;

% Ghr P2L1L3 ids
Ghr_P2L1L3_data = dataInRange(Ghr_health_filter & P2L1L3_task_filter, :);
Ghr_P2L1L3_id = Ghr_P2L1L3_data.id;
end