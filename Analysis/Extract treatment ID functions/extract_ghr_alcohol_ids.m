% Author: Atanu Giri
% Date: 03/21/2024

function [ghr_alc_L1_id, ghr_alc_L1L3_id, ghr_alc_P2A_id, ...
    comb_ghr_alc_boost_L1_id, comb_ghr_alc_boost_L1L3_id, comb_ghr_alc_boost_P2A_id] ...
    = extract_ghr_alcohol_ids(varargin)

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
   conn =  varargin{1};
end


%% Ghrelin alcohol L1
ghr_alc_L1_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND REPLACE(tasktypedone, ' ','') = 'P2L1' AND genotype = 'lg_etoh' AND " + ...
"(health = 'ghr' OR health = 'ghr(2x)') ORDER BY id";

ghr_alc_L1_Data = fetch(conn, ghr_alc_L1_Q);
ghr_alc_L1_id = ghr_alc_L1_Data.id;

% Data summary
printTableSummary(ghr_alc_L1_Data);


%% Ghrelin alcohol + ghrelin boost L1
comb_ghr_alc_boost_L1_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND REPLACE(tasktypedone, ' ','') = 'P2L1' AND (genotype = 'lg_etoh' OR genotype = 'lg_boost') " + ...
"AND (health = 'ghr' OR health = 'ghr(2x)') ORDER BY id";

comb_ghr_alc_boost_L1_Data = fetch(conn, comb_ghr_alc_boost_L1_Q);
comb_ghr_alc_boost_L1_id = comb_ghr_alc_boost_L1_Data.id;

% Data summary
printTableSummary(comb_ghr_alc_boost_L1_Data);


%% Ghrelin alcohol L1L3
ghr_alc_L1L3_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND REPLACE(tasktypedone, ' ','') = 'P2L1L3' AND genotype = 'lg_etoh' AND " + ...
"(health = 'ghr' OR health = 'ghr(2x)') ORDER BY id";

ghr_alc_L1L3_Data = fetch(conn, ghr_alc_L1L3_Q);
ghr_alc_L1L3_id = ghr_alc_L1L3_Data.id;

% Data summary
printTableSummary(ghr_alc_L1L3_Data);


%% Ghrelin alcohol + ghrelin boost L1L3
comb_ghr_alc_boost_L1L3_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND REPLACE(tasktypedone, ' ','') = 'P2L1L3' AND (genotype = 'lg_etoh' OR genotype = 'lg_boost') " + ...
"AND (health = 'ghr' OR health = 'ghr(2x)') ORDER BY id";

comb_ghr_alc_boost_L1L3_Data = fetch(conn, comb_ghr_alc_boost_L1L3_Q);
comb_ghr_alc_boost_L1L3_id = comb_ghr_alc_boost_L1L3_Data.id;

% Data summary
printTableSummary(comb_ghr_alc_boost_L1L3_Data);



%% Ghrelin alcohol P2A
ghr_alc_P2A_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND REPLACE(tasktypedone, ' ','') = 'P2A' AND genotype = 'lg_etoh' AND " + ...
"(health = 'ghr' OR health = 'ghr(2x)') ORDER BY id";

ghr_alc_P2A_Data = fetch(conn, ghr_alc_P2A_Q);
ghr_alc_P2A_id = ghr_alc_P2A_Data.id;

% Data summary
printTableSummary(ghr_alc_P2A_Data);


%% Ghrelin alcohol + ghrelin boost P2A
comb_ghr_alc_boost_P2A_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND REPLACE(tasktypedone, ' ','') = 'P2A' AND (genotype = 'lg_etoh' OR genotype = 'lg_boost') " + ...
"AND (health = 'ghr' OR health = 'ghr(2x)') ORDER BY id";

comb_ghr_alc_boost_P2A_Data = fetch(conn, comb_ghr_alc_boost_P2A_Q);
comb_ghr_alc_boost_P2A_id = comb_ghr_alc_boost_P2A_Data.id;

% Data summary
printTableSummary(comb_ghr_alc_boost_P2A_Data);

end