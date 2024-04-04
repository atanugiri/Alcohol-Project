% Author: Atanu Giri
% Date: 03/21/2024

function [alcohol_bl_id, alcohol_L1_id, alcohol_L1L3_id, alcohol_P2A_id] = ...
    extract_alcohol_ids(varargin)

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
   conn =  varargin{1};
end

%% Alcohol baseline
dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
allDates = fetch(conn, dateQuery);
allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
startDate = datetime('09/19/2022', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('10/03/2022', 'InputFormat', 'MM/dd/yyyy');
endDate = endDate + days(1);

dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);
idList = dataInRange.id;
idList = strjoin(arrayfun(@num2str, idList, 'UniformOutput', false), ',');
alc_bl_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender FROM live_table WHERE id IN (%s) " + ...
    "AND UPPER(subjectid) <> UPPER('none') ORDER BY id", idList);
alc_bl_Data = fetch(conn, alc_bl_Q);
alcohol_bl_id = alc_bl_Data.id;


% % Alcohol
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

% alcohol_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
%     "subjectid, gender FROM live_table WHERE id IN (%s) " + ...
%     "AND genotype = 'lg_etoh' " + ...
%     "AND UPPER(subjectid) <> UPPER('none') ORDER BY id;", idList);
% alcohol_Data = fetch(conn, alcohol_Q);
% alcohol_id = alcohol_Data.id;

%% Alcohol L1
alcohol_L1_male_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE (referencetime " + ...
    "LIKE '%11/03/2022%' OR referencetime LIKE '%11/08/2022%' OR " + ...
    "referencetime LIKE '%11/15/2022%' OR referencetime LIKE '%11/17/2022%' OR " + ...
    "referencetime LIKE '%11/22/2022%' OR referencetime LIKE '%11/30/2022%') " + ...
    "AND gender ILIKE 'Male' AND UPPER(subjectid) <> UPPER('none') " + ...
    "AND genotype = 'lg_etoh' AND health = 'N/A' " + ...
    "AND REPLACE(tasktypedone, ' ', '') = 'P2L1' ORDER BY id";
alcohol_L1_male_Data = fetch(conn, alcohol_L1_male_Q);

alcohol_L1_female_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE (referencetime " + ...
    "LIKE '%11/03/2022%' OR referencetime LIKE '%11/08/2022%' OR " + ...
    "referencetime LIKE '%11/10/2022%' OR referencetime LIKE '%11/15/2022%' OR " + ...
    "referencetime LIKE '%11/17/2022%' OR referencetime LIKE '%11/22/2022%' OR " + ...
    "referencetime LIKE '%01/20/2023%') " + ...
    "AND gender ILIKE 'Female' AND UPPER(subjectid) <> UPPER('none') " + ...
    "AND genotype = 'lg_etoh' AND health = 'N/A' " + ...
    "AND REPLACE(tasktypedone, ' ', '') = 'P2L1' ORDER BY id";

alcohol_L1_female_Data = fetch(conn, alcohol_L1_female_Q);
alcohol_L1_Data = vertcat(alcohol_L1_male_Data, alcohol_L1_female_Data);

alcohol_L1_id = alcohol_L1_Data.id;

% Data summary
printTableSummary(alcohol_L1_Data);


%% Alcohol L1L3 [Matched exactly with dates provided]
alcohol_L1L3_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table " + ...
"WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND genotype = 'lg_etoh' AND health = 'N/A' " + ...
"AND REPLACE(tasktypedone, ' ', '') = 'P2L1L3' ORDER BY id";

alcohol_L1L3_Data = fetch(conn, alcohol_L1L3_Q);
alcohol_L1L3_id = alcohol_L1L3_Data.id;

% Data summary
printTableSummary(alcohol_L1L3_Data);


%% Alcohol P2A
alcohol_P2A_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table " + ...
"WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND genotype = 'lg_etoh' AND health = 'N/A' " + ...
"AND REPLACE(tasktypedone, ' ', '') = 'P2A' ORDER BY id";

alcohol_P2A_Data = fetch(conn, alcohol_P2A_Q);
alcohol_P2A_id = alcohol_P2A_Data.id;

% Data summary
printTableSummary(alcohol_P2A_Data);

end