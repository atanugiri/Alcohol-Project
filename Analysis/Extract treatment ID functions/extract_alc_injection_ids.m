% Author: Atanu Giri
% Date: 06/28/2024
%
% Extracts ids for alcohol days (Not after alcohol, i.e, P2L1 or P2L1L3 
% days) for same animals in those groups.
%

function [P2L1_alc_inj_id, P2L1L3_alc_inj_id] = extract_alc_injection_ids(varargin)

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
    conn =  varargin{1};
end

%% P2L1 combined boost and alcohol baseline
[boost_alcohol_L1_id, ~, ~] = extract_combined_boost_alcohol_ids(conn, 'noPrint');
boost_alcohol_L1_data = dataSummary(boost_alcohol_L1_id);
boost_alcohol_L1_animals = unique(string(boost_alcohol_L1_data.subjectid));
boost_alcohol_L1_animals = strjoin(boost_alcohol_L1_animals, "','");

P2L1_alc_inj_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE subjectid IN ('%s') AND " + ...
    "health = 'alc' AND REPLACE(tasktypedone, ' ', '') " + ...
    "= 'P2L1' ORDER BY id", boost_alcohol_L1_animals);
P2L1_alc_inj_Data = fetch(conn, P2L1_alc_inj_Q);
P2L1_alc_inj_id = P2L1_alc_inj_Data.id;

% Data summary
if numel(varargin) <= 1 % To supress output using 'noPrint'
    printTableSummary(P2L1_alc_inj_Data);
end

%% P2L1L3 combined boost and alcohol baseline
[~, boost_alcohol_L1L3_id, ~] = extract_combined_boost_alcohol_ids(conn, 'noPrint');
boost_alcohol_L1L3_data = dataSummary(boost_alcohol_L1L3_id);
boost_alcohol_L1L3_animals = unique(string(boost_alcohol_L1L3_data.subjectid));
boost_alcohol_L1L3_animals = strjoin(boost_alcohol_L1L3_animals, "','");

P2L1L3_alc_inj_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE subjectid IN ('%s') AND " + ...
    "health = 'alc' AND REPLACE(tasktypedone, ' ', '') " + ...
    "= 'P2L1L3' ORDER BY id", boost_alcohol_L1L3_animals);
P2L1L3_alc_inj_Data = fetch(conn, P2L1L3_alc_inj_Q);
P2L1L3_alc_inj_id = P2L1L3_alc_inj_Data.id;

% Data summary
if numel(varargin) <= 1 % To supress output using 'noPrint'
    printTableSummary(P2L1L3_alc_inj_Data);
end


%% Description of dataSummary
    function data = dataSummary(idArray)
        id_list = strjoin(arrayfun(@num2str, idArray, 'UniformOutput', false), ',');

        query = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
            "subjectid, gender, notes FROM live_table WHERE id IN (%s) ORDER BY id", id_list);

        data = fetch(conn, query);
    end
end