% Author: Atanu Giri
% Date: 06/18/2024
%
% Extracts ids for alcohol for different task types.
%
function post_alcohol_L1L3_id = extract_post_alcohol_ids(varargin)

if numel(varargin) < 1
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
else
    conn =  varargin{1};
end

% Fetch alcohol animals
[~, boost_alcohol_L1L3_id, ~] = extract_combined_boost_alcohol_ids(conn, 'noPrint');
boost_alcohol_L1L3_data = dataSummary(boost_alcohol_L1L3_id);
boost_alcohol_L1L3_animals = unique(string(boost_alcohol_L1L3_data.subjectid));
boost_alcohol_L1L3_animals = strjoin(boost_alcohol_L1L3_animals, "','");


post_alcohol_L1L3_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE subjectid IN ('%s') AND " + ...
    "REPLACE(tasktypedone, ' ', '') = 'P2L1L3' ORDER BY id", boost_alcohol_L1L3_animals);
post_alcohol_L1L3_data = fetch(conn, post_alcohol_L1L3_Q);
post_alcohol_L1L3_data.referencetime = datetime(post_alcohol_L1L3_data.referencetime, ...
    'Format', 'MM/dd/yyyy');
post_alcohol_L1L3_data = sortrows(post_alcohol_L1L3_data, 'referencetime');

start_date = datetime('12/01/2022', 'InputFormat', 'MM/dd/yyyy');
start_date = start_date + days(1);
post_alcohol_L1L3_data = post_alcohol_L1L3_data(post_alcohol_L1L3_data. ...
    referencetime >= start_date, :);
post_alcohol_L1L3_data = post_alcohol_L1L3_data(ismember(post_alcohol_L1L3_data.health, ...
{'sal', 'sal(2x)'}), :);
post_alcohol_L1L3_id = post_alcohol_L1L3_data.id;

% Data summary
if numel(varargin) <= 1 % To supress output using 'noPrint'
    printTableSummary(post_alcohol_L1L3_data);
end


%% Description of dataSummary
    function data = dataSummary(idArray)
        id_list = strjoin(arrayfun(@num2str, idArray, 'UniformOutput', false), ',');

        query = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
            "subjectid, gender, notes FROM live_table WHERE id IN (%s) ORDER BY id", id_list);

        data = fetch(conn, query);
    end
end