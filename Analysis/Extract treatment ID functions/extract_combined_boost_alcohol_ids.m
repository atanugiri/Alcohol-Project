% Author: Atanu Giri
% Date: 04/23/2024

function [boost_alcohol_L1_id, boost_alcohol_L1L3_id, boost_alcohol_P2A_id] = ...
    extract_combined_boost_alcohol_ids(varargin)

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
    conn =  varargin{1};
end

%% Combined Boost Alcohol L1
[boost_L1_id, ~, ~] = extract_boost_ids(conn);
[~, alcohol_L1_id, ~, ~] = extract_alcohol_ids(conn);
boost_alcohol_L1_id = vertcat(boost_L1_id, alcohol_L1_id);

% Data summary
boost_alcohol_L1_data = dataSummary(boost_alcohol_L1_id);
printTableSummary(boost_alcohol_L1_data);

%% Combined Boost Alcohol L1L3
[~, boost_L1L3_id, ~] = extract_boost_ids(conn);
[~, ~, alcohol_L1L3_id, ~] = extract_alcohol_ids(conn);
boost_alcohol_L1L3_id = vertcat(boost_L1L3_id, alcohol_L1L3_id);

% Data summary
boost_alcohol_L1L3_data = dataSummary(boost_alcohol_L1L3_id);
printTableSummary(boost_alcohol_L1L3_data);

%% Combined Boost Alcohol P2A
[~, ~, boost_P2A_id] = extract_boost_ids(conn);
[~, ~, ~, alcohol_P2A_id] = extract_alcohol_ids(conn);
boost_alcohol_P2A_id = vertcat(boost_P2A_id, alcohol_P2A_id);

% Data summary
boost_alcohol_P2A_data = dataSummary(boost_alcohol_P2A_id);
printTableSummary(boost_alcohol_P2A_data);



%% Description of dataSummary
    function data = dataSummary(idArray)
        id_list = strjoin(arrayfun(@num2str, idArray, 'UniformOutput', false), ',');

        query = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
            "subjectid, gender, notes FROM live_table WHERE id IN (%s) ORDER BY id", id_list);

        data = fetch(conn, query);
    end
end