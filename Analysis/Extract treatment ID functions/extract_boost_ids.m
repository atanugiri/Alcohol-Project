% Author: Atanu Giri
% Date: 02/16/2024

function [boost_L1_id, Boost_L1L3_id, Boost_P2A_id] = extract_boost_ids(varargin)
% This function extracts boost treatment id's

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
   conn =  varargin{1};
end

% % Boost
% dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
% allDates = fetch(conn, dateQuery);
% allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
% startDate = datetime('11/02/2022', 'InputFormat', 'MM/dd/yyyy');
% endDate = datetime('12/01/2022', 'InputFormat', 'MM/dd/yyyy');
% endDate = endDate + days(1);
% 
% dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);
% idList = dataInRange.id;
% idList = strjoin(arrayfun(@num2str, idList, 'UniformOutput', false), ',');
% Boost_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
%     "subjectid, gender FROM live_table WHERE id IN (%s) " + ...
%     "AND genotype = 'lg_boost' " + ...
%     "AND UPPER(subjectid) <> UPPER('none') ORDER BY id;", idList);
% boost_Data = fetch(conn, Boost_Q);
% boost_id = boost_Data.id;

%% Boost L1 (database based query gives 3 extra dates)
dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
allDates = fetch(conn, dateQuery);
allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
startDate = datetime('11/02/2022', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('12/01/2022', 'InputFormat', 'MM/dd/yyyy');
endDate = endDate + days(1);

dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);
idList = dataInRange.id;
idList = strjoin(arrayfun(@num2str, idList, 'UniformOutput', false), ',');
Boost_L1_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE id IN (%s) AND health = 'N/A' " + ...
    "AND genotype = 'lg_boost' AND REPLACE(tasktypedone, ' ', '') = 'P2L1' " + ...
    "AND UPPER(subjectid) <> UPPER('none') ORDER BY id", idList);

boost_L1_Data = fetch(conn, Boost_L1_Q);
boost_L1_id = boost_L1_Data.id;

% Data summary
printTableSummary(boost_L1_Data);

%% Boost L1L3 (Dates not provided)
Boost_L1L3_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE health = 'N/A' AND " + ...
"genotype = 'lg_boost' AND REPLACE(tasktypedone, ' ', '') = 'P2L1L3' " + ...
"AND UPPER(subjectid) <> UPPER('none') ORDER BY id";

Boost_L1L3_Data = fetch(conn, Boost_L1L3_Q);
Boost_L1L3_id = Boost_L1L3_Data.id;

% Data summary
printTableSummary(Boost_L1L3_Data);

%% Boost P2A (Dates not provided)
Boost_P2A_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE health = 'N/A' AND " + ...
"genotype = 'lg_boost' AND REPLACE(tasktypedone, ' ', '') = 'P2A' " + ...
"AND UPPER(subjectid) <> UPPER('none') ORDER BY id";

Boost_P2A_Data = fetch(conn, Boost_P2A_Q);
Boost_P2A_id = Boost_P2A_Data.id;

% Data summary
printTableSummary(Boost_P2A_Data);

end