% Author: Atanu Giri
% Date: 03/21/2024

function [ghr_alc_L1_id, ghr_alc_L1L3_id, ghr_alc_P2A_id] = extract_ghr_alcohol_ids(varargin)

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
   conn =  varargin{1};
end


% % Ghrelin alcohol
% ghr_alc_male_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
%     "subjectid, gender FROM live_table WHERE (referencetime LIKE " + ...
%     "'%12/07/20222%' OR referencetime LIKE '%02/09/2023%' OR " + ...
%     "referencetime LIKE '%02/16/2023%') AND gender ILIKE 'Male' " + ...
%     "AND UPPER(subjectid) <> UPPER('none')";
% ghr_alc_male_Data = fetch(conn, ghr_alc_male_Q);
% 
% ghr_alc_female_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
%     "subjectid, gender FROM live_table WHERE (referencetime LIKE " + ...
%     "'%12/08/20222%' OR referencetime LIKE '%02/08/2023%' OR " + ...
%     "referencetime LIKE '%02/15/2023%') AND gender ILIKE 'Female' " + ...
%     "AND UPPER(subjectid) <> UPPER('none')";
% ghr_alc_female_Data = fetch(conn, ghr_alc_female_Q);
% 
% ghr_alc_Data = vertcat(ghr_alc_male_Data, ghr_alc_female_Data);
% ghr_alc_id = ghr_alc_Data.id;

%% Ghrelin alcohol L1
ghr_alc_L1_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND REPLACE(tasktypedone, ' ','') = 'P2L1' AND genotype = 'lg_etoh' AND " + ...
"(health = 'ghr' OR health = 'ghr(2x)') ORDER BY id";

ghr_alc_L1_Data = fetch(conn, ghr_alc_L1_Q);
ghr_alc_L1_id = ghr_alc_L1_Data.id;

% Data summary
printTableSummary(ghr_alc_L1_Data);


%% Ghrelin alcohol L1L3
ghr_alc_L1L3_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND REPLACE(tasktypedone, ' ','') = 'P2L1L3' AND genotype = 'lg_etoh' AND " + ...
"(health = 'ghr' OR health = 'ghr(2x)') ORDER BY id";

ghr_alc_L1L3_Data = fetch(conn, ghr_alc_L1L3_Q);
ghr_alc_L1L3_id = ghr_alc_L1L3_Data.id;

% Data summary
printTableSummary(ghr_alc_L1L3_Data);

%% Ghrelin alcohol P2A
ghr_alc_P2A_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND REPLACE(tasktypedone, ' ','') = 'P2A' AND genotype = 'lg_etoh' AND " + ...
"(health = 'ghr' OR health = 'ghr(2x)') ORDER BY id";

ghr_alc_P2A_Data = fetch(conn, ghr_alc_P2A_Q);
ghr_alc_P2A_id = ghr_alc_P2A_Data.id;

% Data summary
printTableSummary(ghr_alc_P2A_Data);

end