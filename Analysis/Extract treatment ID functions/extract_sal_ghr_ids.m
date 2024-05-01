% Author: Atanu Giri
% Date: 01/02/2024
%
% This function extracts P2L1 Saline, P2L1 Ghrelin, P2L1L3 Saline, P2L1L3
% Ghrelin ids
%

function [Sal_P2L1_id, Ghr_P2L1_id, Sal_P2L1L3_id, Ghr_P2L1L3_id] = extract_sal_ghr_ids(varargin)

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
   conn =  varargin{1};
end


%% Sal P2L1 ids (male data matched exactly. For female, 07/05/22 is included, 
%% not sure why it was excluded in the first place)
sal_P2L1_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE UPPER(subjectid) <> UPPER('none') " + ...
"AND REPLACE(tasktypedone, ' ','') = 'P2L1' AND genotype = 'CRL: Long Evans' AND " + ...
"(health = '2 hour Saline' OR health = '2 Hour Saline') ORDER BY id";

Sal_P2L1_Data = fetch(conn, sal_P2L1_Q);
Sal_P2L1_id = Sal_P2L1_Data.id;

% Data summary
printTableSummary(Sal_P2L1_Data);


%% Ghr P2L1 ids (06/27/2022 for male had 1 Hour ghrelin, removed for fair 
%% comparison with saline. female data is exactly same)
ghr_P2L1_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes FROM live_table WHERE (health = '2 Hour Ghrelin' OR " + ...
"health = '2 Hours Ghrelin') AND genotype = 'CRL: Long Evans' AND " + ...
"REPLACE(tasktypedone, ' ','') = 'P2L1' AND UPPER(subjectid) <> UPPER('none')";

Ghr_P2L1_Data = fetch(conn, ghr_P2L1_Q);
Ghr_P2L1_id = Ghr_P2L1_Data.id;

% Data summary
printTableSummary(Ghr_P2L1_Data);

%% Sal P2L1L3 ids (Female had 1, 2, 3 Hours of ghrelin; male have only 2 Hours)
sal_L1L3_male_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes, lightlevel FROM live_table WHERE referencetime " + ...
    "LIKE '%07/19/2022%' AND LOWER(gender) = 'male' AND UPPER(subjectid) <> UPPER('none')";
sal_L1L3_male_Data = fetch(conn, sal_L1L3_male_Q);

sal_L1L3_female_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes, lightlevel FROM live_table WHERE (referencetime " + ...
"LIKE '%07/26/2022%' OR referencetime LIKE '%07/29/2022%') AND LOWER(gender) = " + ...
"'female' AND UPPER(subjectid) <> UPPER('none') AND health = '2 Hour Saline'";
sal_L1L3_female_Data = fetch(conn, sal_L1L3_female_Q);

Sal_P2L1L3_Data = vertcat(sal_L1L3_male_Data, sal_L1L3_female_Data);
Sal_P2L1L3_id = Sal_P2L1L3_Data.id;

% Data summary
printTableSummary(Sal_P2L1L3_Data);


%% Ghr P2L1L3 ids (ghr_L1L3_male_Q, ghr_L1L3_female_Q matches exactly.
%% male has only 2 Hour, but female has 2 and 3 Hour ghrelin)
ghr_L1L3_Q = "SELECT id, health, genotype, tasktypedone, referencetime, " + ...
"subjectid, gender, notes, lightlevel FROM live_table WHERE " + ...
"UPPER(subjectid) <> UPPER('none') AND (health = '2 Hour Ghrelin' " + ...
"OR health = '3 Hour Ghrelin') AND genotype = 'CRL: Long Evans' AND " + ...
"REPLACE(tasktypedone, ' ','') = 'P2L1L3'";

Ghr_P2L1L3_Data = fetch(conn, ghr_L1L3_Q);
Ghr_P2L1L3_id = Ghr_P2L1L3_Data.id;

% Data summary
printTableSummary(Ghr_P2L1L3_Data);

end