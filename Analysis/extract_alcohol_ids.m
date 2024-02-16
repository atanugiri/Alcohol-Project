function [alcohol_bl_id, boost_id, alcohol_id, sal_alc_id, ghr_alc_id] = ...
    extract_alcohol_ids

datasource = 'live_database';
conn = database(datasource,'postgres','1234');

% Alcohol baseline
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
    "AND UPPER(subjectid) <> UPPER('none') ORDER BY id;", idList);
alc_bl_Data = fetch(conn, alc_bl_Q);
alcohol_bl_id = alc_bl_Data.id;

% Boost
dateQuery = "SELECT id, referencetime FROM live_table ORDER BY id";
allDates = fetch(conn, dateQuery);
allDates.referencetime = datetime(allDates.referencetime, 'Format', 'MM/dd/yyyy');
startDate = datetime('11/02/2022', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('12/01/2022', 'InputFormat', 'MM/dd/yyyy');
endDate = endDate + days(1);

dataInRange = allDates(allDates.referencetime >= startDate & allDates.referencetime <= endDate, :);
idList = dataInRange.id;
idList = strjoin(arrayfun(@num2str, idList, 'UniformOutput', false), ',');
Boost_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender FROM live_table WHERE id IN (%s) " + ...
    "AND genotype = 'lg_boost' " + ...
    "AND UPPER(subjectid) <> UPPER('none') ORDER BY id;", idList);
boost_Data = fetch(conn, Boost_Q);
boost_id = boost_Data.id;

% Alcohol
alcohol_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender FROM live_table WHERE id IN (%s) " + ...
    "AND genotype = 'lg_etoh' " + ...
    "AND UPPER(subjectid) <> UPPER('none') ORDER BY id;", idList);
alcohol_Data = fetch(conn, alcohol_Q);
alcohol_id = alcohol_Data.id;


% Saline alcohol
sal_alc_male_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender FROM live_table WHERE (referencetime " + ...
    "LIKE '%12/17/2022%' OR referencetime LIKE '%01/05/2023%') AND gender " + ...
    "ILIKE 'Male' AND UPPER(subjectid) <> UPPER('none')";
sal_alc_male_Data = fetch(conn, sal_alc_male_Q);

sal_alc_female_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender FROM live_table WHERE (referencetime " + ...
    "LIKE '%12/19/2022%' OR referencetime LIKE '%01/04/2023%' OR " + ...
    "referencetime LIKE '%01/25/2023%') AND gender ILIKE 'Female' " + ...
    "AND UPPER(subjectid) <> UPPER('none')";
sal_alc_female_Data = fetch(conn, sal_alc_female_Q);

sal_alc_Data = vertcat(sal_alc_male_Data, sal_alc_female_Data);
sal_alc_id = sal_alc_Data.id;

% Ghrelin alcohol
ghr_alc_male_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender FROM live_table WHERE (referencetime LIKE " + ...
    "'%12/07/20222%' OR referencetime LIKE '%02/09/2023%' OR " + ...
    "referencetime LIKE '%02/16/2023%') AND gender ILIKE 'Male' " + ...
    "AND UPPER(subjectid) <> UPPER('none')";
ghr_alc_male_Data = fetch(conn, ghr_alc_male_Q);

ghr_alc_female_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender FROM live_table WHERE (referencetime LIKE " + ...
    "'%12/08/20222%' OR referencetime LIKE '%02/08/2023%' OR " + ...
    "referencetime LIKE '%02/15/2023%') AND gender ILIKE 'Female' " + ...
    "AND UPPER(subjectid) <> UPPER('none')";
ghr_alc_female_Data = fetch(conn, ghr_alc_female_Q);

ghr_alc_Data = vertcat(ghr_alc_male_Data, ghr_alc_female_Data);
ghr_alc_id = ghr_alc_Data.id;
end