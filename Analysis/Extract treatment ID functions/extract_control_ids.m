% Author: Atanu Giri
% Date: 09/02/2024
%
% Extracts ids for control
%

function [P2L1_control_id_p1, P2L1_control_id_p2, P2L1_control_id_p3, ...
    P2L1L3_control_id_p1, P2L1L3_control_id_p2, P2L1L3_control_id_p3] ...
    = extract_control_ids(varargin)

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

P2L1_BLforCombAlcAndBoost_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE subjectid IN ('%s') AND " + ...
    "genotype = 'CRL: Long Evans' AND health = 'N/A' AND REPLACE(tasktypedone, ' ', '') " + ...
    "= 'P2L1' ORDER BY id", boost_alcohol_L1_animals);
P2L1_BLforCombAlcAndBoost_Data = fetch(conn, P2L1_BLforCombAlcAndBoost_Q);

% Remove learning period
P2L1_BLforCombAlcAndBoost_Data.referencetime = datetime(P2L1_BLforCombAlcAndBoost_Data.referencetime, ...
    'Format', 'MM/dd/yyyy');
P2L1_BLforCombAlcAndBoost_Data.referencetime = dateshift(P2L1_BLforCombAlcAndBoost_Data.referencetime, ...
    'start', 'day');
P2L1_BLforCombAlcAndBoost_Data = sortrows(P2L1_BLforCombAlcAndBoost_Data, "referencetime");
start_date = datetime('11/24/2021', 'InputFormat', 'MM/dd/yyyy');
end_date = datetime('12/13/2021', 'InputFormat', 'MM/dd/yyyy');
end_date = end_date + days(1);
dateFilter = P2L1_BLforCombAlcAndBoost_Data.referencetime >= start_date & ...
    P2L1_BLforCombAlcAndBoost_Data.referencetime <= end_date;
P2L1_BLforCombAlcAndBoost_Data(dateFilter, :) = [];

% Define phases
start_dates = {'04/01/2022', '05/01/2022', '06/01/2022'};
end_dates = {'04/30/2022', '05/31/2022', '06/23/2022'};

% Each phase ids
P2L1_control_id = cell(1, numel(start_dates));
for i = 1:numel(start_dates)
    start_date_l1 = datetime(start_dates{i}, 'InputFormat', 'MM/dd/yyyy');
    end_date_l1 = datetime(end_dates{i}, 'InputFormat', 'MM/dd/yyyy');
    end_date_l1 = end_date_l1 + days(1);
    dateFilter = P2L1_BLforCombAlcAndBoost_Data.referencetime >= start_date_l1 & ...
        P2L1_BLforCombAlcAndBoost_Data.referencetime <= end_date_l1;
    P2L1_control_data = P2L1_BLforCombAlcAndBoost_Data(dateFilter, :);
    P2L1_control_id{i} = P2L1_control_data.id;

end

P2L1_control_id_p1 = P2L1_control_id{1}; %1
P2L1_control_id_p2 = P2L1_control_id{2}; %2
P2L1_control_id_p3 = P2L1_control_id{3}; %3


%% P2L1L3 combined boost and alcohol baseline
[~, boost_alcohol_L1L3_id, ~] = extract_combined_boost_alcohol_ids(conn, 'noPrint');
boost_alcohol_L1L3_data = dataSummary(boost_alcohol_L1L3_id);
boost_alcohol_L1L3_animals = unique(string(boost_alcohol_L1L3_data.subjectid));
boost_alcohol_L1L3_animals = strjoin(boost_alcohol_L1L3_animals, "','");

P2L1L3_BLforCombAlcAndBoost_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE subjectid IN ('%s') AND " + ...
    "genotype = 'CRL: Long Evans' AND health = 'N/A' AND REPLACE(tasktypedone, ' ', '') " + ...
    "= 'P2L1L3' ORDER BY id", boost_alcohol_L1L3_animals);
P2L1L3_BLforCombAlcAndBoost_Data = fetch(conn, P2L1L3_BLforCombAlcAndBoost_Q);

P2L1L3_BLforCombAlcAndBoost_Data.referencetime = datetime(P2L1L3_BLforCombAlcAndBoost_Data.referencetime, ...
    'Format', 'MM/dd/yyyy');
P2L1L3_BLforCombAlcAndBoost_Data.referencetime = dateshift(P2L1L3_BLforCombAlcAndBoost_Data.referencetime, ...
    'start', 'day');
P2L1L3_BLforCombAlcAndBoost_Data = sortrows(P2L1L3_BLforCombAlcAndBoost_Data, "referencetime");

% Define phases
start_dates = {'04/01/2022', '05/01/2022', '06/01/2022'};
end_dates = {'04/30/2022', '05/31/2022', '06/23/2022'};


% Each phase ids
P2L1L3_control_id = cell(1, numel(start_dates));
for i = 1:numel(start_dates)
    start_date_l3 = datetime(start_dates{i}, 'InputFormat', 'MM/dd/yyyy');
    end_date_l3 = datetime(end_dates{i}, 'InputFormat', 'MM/dd/yyyy');
    end_date_l3 = end_date_l3 + days(1);
    dateFilter = P2L1L3_BLforCombAlcAndBoost_Data.referencetime >= start_date_l3 & ...
        P2L1L3_BLforCombAlcAndBoost_Data.referencetime <= end_date_l3;
    P2L1L3_control_data = P2L1L3_BLforCombAlcAndBoost_Data(dateFilter, :);
    P2L1L3_control_id{i} = P2L1L3_control_data.id;
end

P2L1L3_control_id_p1 = P2L1L3_control_id{1}; %1
P2L1L3_control_id_p2 = P2L1L3_control_id{2}; %2
P2L1L3_control_id_p3 = P2L1L3_control_id{3}; %3


%% Description of dataSummary
    function data = dataSummary(idArray)
        id_list = strjoin(arrayfun(@num2str, idArray, 'UniformOutput', false), ',');

        query = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
            "subjectid, gender, notes FROM live_table WHERE id IN (%s) ORDER BY id", id_list);

        data = fetch(conn, query);
    end
end