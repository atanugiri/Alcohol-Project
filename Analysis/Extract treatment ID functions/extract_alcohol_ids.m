% Author: Atanu Giri
% Date: 03/21/2024
%
% Extracts ids for alcohol for different task types.
%
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

% Remove bad data based on video
aladdinFilter = string(alcohol_L1_male_Data.subjectid) == 'aladdin' & ...
    contains(string(alcohol_L1_male_Data.referencetime), '11/03/2022');
jimiFilter = string(alcohol_L1_male_Data.subjectid) == 'jimi' & ...
    contains(string(alcohol_L1_male_Data.referencetime), '11/03/2022');
alcohol_L1_male_Data(aladdinFilter | jimiFilter,:) = [];

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
% Remove bad data based on video
fionaFilter = string(alcohol_L1_female_Data.subjectid) == 'fiona' & ...
    contains(string(alcohol_L1_female_Data.referencetime), '11/08/2022');
alcohol_L1_female_Data(fionaFilter, :) = [];

alcohol_L1_Data = vertcat(alcohol_L1_male_Data, alcohol_L1_female_Data);

alcohol_L1_id = alcohol_L1_Data.id;

% Data summary
if numel(varargin) <= 1 % To supress output using 'noPrint' 
    printTableSummary(alcohol_L1_Data);
end


%% Alcohol L1L3 [Matched exactly with dates provided]
alcohol_L1L3_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table " + ...
    "WHERE UPPER(subjectid) <> UPPER('none') " + ...
    "AND genotype = 'lg_etoh' AND health = 'N/A' " + ...
    "AND REPLACE(tasktypedone, ' ', '') = 'P2L1L3' ORDER BY id";

alcohol_L1L3_Data = fetch(conn, alcohol_L1L3_Q);

add_alcohol_L1L3_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table " + ...
    "WHERE UPPER(subjectid) <> UPPER('none') " + ...
    "AND health ILIKE 'No Injection%' " + ...
    "AND REPLACE(tasktypedone, ' ', '') = 'P2L1L3' ORDER BY id";
add_alcohol_L1L3_Data = fetch(conn, add_alcohol_L1L3_Q);

alcohol_L1L3_Data = vertcat(alcohol_L1L3_Data, add_alcohol_L1L3_Data);
alcohol_L1L3_id = alcohol_L1L3_Data.id;

% Data summary
if numel(varargin) <= 1 % To supress output using 'noPrint' 
    printTableSummary(alcohol_L1L3_Data);
end


%% Alcohol P2A
alcohol_P2A_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table " + ...
    "WHERE UPPER(subjectid) <> UPPER('none') " + ...
    "AND genotype = 'lg_etoh' AND health = 'N/A' " + ...
    "AND REPLACE(tasktypedone, ' ', '') = 'P2A' ORDER BY id";

alcohol_P2A_Data = fetch(conn, alcohol_P2A_Q);
alcohol_P2A_id = alcohol_P2A_Data.id;

% Data summary
if numel(varargin) <= 1 % To supress output using 'noPrint' 
    printTableSummary(alcohol_P2A_Data);
end

end