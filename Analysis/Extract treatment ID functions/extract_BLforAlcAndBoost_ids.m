% Author: Atanu Giri
% Date: 05/03/2024
%
% Extracts ids for control/baseline to compare with alcohol and boost
% group for same animals in those groups.
%

function [P2L1_BLforAlc_id, P2L1L3_BLforAlc_id, P2L1_BLforBoost_id, ...
    P2L1L3_BLforBoost_id] = extract_BLforAlcAndBoost_ids(varargin)

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
    conn =  varargin{1};
end

%% P2L1 Alcohol baseline
[~, alcohol_L1_id, ~, ~] = extract_alcohol_ids(conn, 'noPrint');
alcohol_L1_data = dataSummary(alcohol_L1_id);
alcohol_L1_animals = unique(string(alcohol_L1_data.subjectid));
alcohol_L1_animals = strjoin(alcohol_L1_animals, "','");

P2L1_BLforAlc_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE subjectid IN ('%s') AND " + ...
    "genotype = 'CRL: Long Evans' AND health = 'N/A' AND REPLACE(tasktypedone, ' ', '') " + ...
    "= 'P2L1' ORDER BY id", alcohol_L1_animals);
P2L1_BLforAlc_Data = fetch(conn, P2L1_BLforAlc_Q);

P2L1_BLforAlc_Data.referencetime = datetime(P2L1_BLforAlc_Data.referencetime, ...
    'Format', 'MM/dd/yyyy');
start_date = datetime('06/16/2022', 'InputFormat', 'MM/dd/yyyy');
end_date = datetime('06/23/2022', 'InputFormat', 'MM/dd/yyyy');
end_date = end_date + days(1);
P2L1_BLforAlc_Data = P2L1_BLforAlc_Data(P2L1_BLforAlc_Data.referencetime >= start_date & ...
    P2L1_BLforAlc_Data.referencetime <= end_date, :);
P2L1_BLforAlc_id = P2L1_BLforAlc_Data.id;

% Data summary
if numel(varargin) <= 1 % To supress output using 'noPrint'
    printTableSummary(P2L1_BLforAlc_Data);
end


%% P2L1L3 Alcohol baseline
[~, ~, alcohol_L1L3_id, ~] = extract_alcohol_ids(conn, 'noPrint');
alcohol_L1L3_data = dataSummary(alcohol_L1L3_id);
alcohol_L1L3_animals = unique(string(alcohol_L1L3_data.subjectid));
alcohol_L1L3_animals = strjoin(alcohol_L1L3_animals, "','");

P2L1L3_BLforAlc_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE subjectid IN ('%s') AND " + ...
    "genotype = 'CRL: Long Evans' AND health = 'N/A' AND REPLACE(tasktypedone, ' ', '') " + ...
    "= 'P2L1L3' ORDER BY id", alcohol_L1L3_animals);
P2L1L3_BLforAlc_Data = fetch(conn, P2L1L3_BLforAlc_Q);

P2L1L3_BLforAlc_id = P2L1L3_BLforAlc_Data.id;

% Data summary
if numel(varargin) <= 1 % To supress output using 'noPrint'
    printTableSummary(P2L1L3_BLforAlc_Data);
end


%% P2L1 Boost baseline
[boost_L1_id, ~, ~] = extract_boost_ids(conn, 'noPrint');
boost_L1_Data = dataSummary(boost_L1_id);
boost_L1_animals = unique(string(boost_L1_Data.subjectid));
boost_L1_animals = strjoin(boost_L1_animals, "','");

P2L1_BLforBoost_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE subjectid IN ('%s') AND " + ...
    "genotype = 'CRL: Long Evans' AND health = 'N/A' AND REPLACE(tasktypedone, ' ', '') " + ...
    "= 'P2L1' ORDER BY id", boost_L1_animals);
P2L1_BLforBoost_Data = fetch(conn, P2L1_BLforBoost_Q);

P2L1_BLforBoost_Data.referencetime = datetime(P2L1_BLforBoost_Data.referencetime, ...
    'Format', 'MM/dd/yyyy');
P2L1_BLforBoost_Data = P2L1_BLforBoost_Data(P2L1_BLforBoost_Data.referencetime >= start_date & ...
    P2L1_BLforBoost_Data.referencetime <= end_date, :);
P2L1_BLforBoost_id = P2L1_BLforBoost_Data.id;

% Data summary
if numel(varargin) <= 1 % To supress output using 'noPrint'
    printTableSummary(P2L1_BLforBoost_Data);
end


%% P2L1L3 Boost baseline
[~, Boost_L1L3_id, ~] = extract_boost_ids(conn, 'noPrint');
boost_L1L3_Data = dataSummary(Boost_L1L3_id);
boost_L1L3_animals = unique(string(boost_L1L3_Data.subjectid));
boost_L1L3_animals = strjoin(boost_L1L3_animals, "','");

P2L1L3_BLforBoost_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE subjectid IN ('%s') AND " + ...
    "genotype = 'CRL: Long Evans' AND health = 'N/A' AND REPLACE(tasktypedone, ' ', '') " + ...
    "= 'P2L1L3' ORDER BY id", boost_L1L3_animals);
P2L1L3_BLforBoost_Data = fetch(conn, P2L1L3_BLforBoost_Q);
P2L1L3_BLforBoost_id = P2L1L3_BLforBoost_Data.id;

% Data summary
if numel(varargin) <= 1 % To supress output using 'noPrint'
    printTableSummary(P2L1L3_BLforBoost_Data);
end




%% Description of dataSummary
    function data = dataSummary(idArray)
        id_list = strjoin(arrayfun(@num2str, idArray, 'UniformOutput', false), ',');

        query = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
            "subjectid, gender, notes FROM live_table WHERE id IN (%s) ORDER BY id", id_list);

        data = fetch(conn, query);
    end
end