% Author: Atanu Giri
% Date: 03/21/2024

function [sal_alc_L1_id, sal_alc_L1L3_id, sal_alc_P2A_id] = extract_sal_alcohol_ids(varargin)

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
   conn =  varargin{1};
end

% % Saline alcohol
% sal_alc_male_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
%     "subjectid, gender FROM live_table WHERE (referencetime " + ...
%     "LIKE '%12/17/2022%' OR referencetime LIKE '%01/05/2023%') AND gender " + ...
%     "ILIKE 'Male' AND UPPER(subjectid) <> UPPER('none')";
% sal_alc_male_Data = fetch(conn, sal_alc_male_Q);
% 
% sal_alc_female_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
%     "subjectid, gender FROM live_table WHERE (referencetime " + ...
%     "LIKE '%12/19/2022%' OR referencetime LIKE '%01/04/2023%' OR " + ...
%     "referencetime LIKE '%01/25/2023%') AND gender ILIKE 'Female' " + ...
%     "AND UPPER(subjectid) <> UPPER('none')";
% sal_alc_female_Data = fetch(conn, sal_alc_female_Q);
% 
% sal_alc_Data = vertcat(sal_alc_male_Data, sal_alc_female_Data);
% sal_alc_id = sal_alc_Data.id;

%% Saline alcohol L1
sal_alc_L1_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND REPLACE(tasktypedone, ' ','') = 'P2L1' AND genotype = 'lg_etoh' AND " + ...
"(health = 'sal' OR health = 'sal(2x)') ORDER BY id";

sal_alc_L1_Data = fetch(conn, sal_alc_L1_Q);
sal_alc_L1_id = sal_alc_L1_Data.id;

% Data summary
printTableSummary(sal_alc_L1_Data);


%% Saline alcohol L1L3
sal_alc_L1L3_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND REPLACE(tasktypedone, ' ','') = 'P2L1L3' AND genotype = 'lg_etoh' AND " + ...
"(health = 'sal' OR health = 'sal(2x)') ORDER BY id";

sal_alc_L1L3_Data = fetch(conn, sal_alc_L1L3_Q);
sal_alc_L1L3_id = sal_alc_L1L3_Data.id;

% Data summary
printTableSummary(sal_alc_L1L3_Data);

%% Saline alcohol P2A
sal_alc_P2A_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND REPLACE(tasktypedone, ' ','') = 'P2A' AND genotype = 'lg_etoh' AND " + ...
"(health = 'sal' OR health = 'sal(2x)') ORDER BY id";

sal_alc_P2A_Data = fetch(conn, sal_alc_P2A_Q);
sal_alc_P2A_id = sal_alc_P2A_Data.id;

% Data summary
printTableSummary(sal_alc_P2A_Data);

end