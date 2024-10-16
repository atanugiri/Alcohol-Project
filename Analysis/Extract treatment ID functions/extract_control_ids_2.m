% Author: Atanu Giri
% Date: 09/02/2024
%
% Extracts ids for alcohol for different task types.
%
% function [P2L1_control_p1_data, P2L1_control_p2_data, ...
% P2L1L3_control_p1_data, P2L1L3_control_p2_data] = ...
%     extract_control_ids(varargin)

% if numel(varargin) < 1
datasource = 'live_database';
conn = database(datasource,'postgres','1234');
% else
%     conn =  varargin{1};
% end

males = {'aladdin', 'carl', 'jafar', 'jimi', 'jr', 'kobe', 'mike', 'scar', ...
    'simba', 'sully'};
females = {'alexis', 'fiona', 'harley', 'juana', 'kryssia', 'neftali', ...
    'raven', 'renata', 'sarah', 'shakira'};

all_subjects = [males, females];

% Create a comma-separated string of the subject names, each enclosed in quotes
subject_list = strjoin(cellfun(@(x) ['''' x ''''], all_subjects, 'UniformOutput', false), ',');

q = sprintf('SELECT id, referencetime FROM live_table WHERE subjectid NOT IN (%s)', subject_list);
d = fetch(conn, q);

idList = d.id;
idList = strjoin(arrayfun(@num2str, idList, 'UniformOutput', false), ',');

%% P2L1 control animal data
P2L1_control_animal_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE id IN (%s) AND " + ...
    "genotype = 'CRL: Long Evans' AND (health = 'N/A' OR health = 'NA') AND " + ...
    "REPLACE(tasktypedone, ' ', '') = 'P2L1' AND UPPER(subjectid) <> UPPER('none')", idList);

P2L1_control_animal_data = fetch(conn, P2L1_control_animal_Q);
P2L1_control_animal_data.referencetime = datetime(P2L1_control_animal_data.referencetime, 'Format', 'MM/dd/yyyy');
P2L1_control_animal_data.referencetime = dateshift(P2L1_control_animal_data.referencetime, 'start', 'day');
P2L1_control_animal_data = sortrows(P2L1_control_animal_data, "referencetime");

% Control animal phase1 data
start_date = datetime('06/01/2022', 'InputFormat', 'MM/dd/yyyy');
end_date = datetime('06/24/2022', 'InputFormat', 'MM/dd/yyyy');
end_date = end_date + days(1);
dateFilter = P2L1_control_animal_data.referencetime >= start_date & ...
    P2L1_control_animal_data.referencetime <= end_date;

P2L1_control_p1_data = P2L1_control_animal_data(dateFilter, :);
P2L1_control_p1_id = P2L1_control_p1_data.id;

% Control animal phase2 data
start_date = datetime('10/26/2022', 'InputFormat', 'MM/dd/yyyy');
dateFilter = P2L1_control_animal_data.referencetime >= start_date;
P2L1_control_p2_data = P2L1_control_animal_data(dateFilter, :);
P2L1_control_p2_id = P2L1_control_p2_data.id;

%% P2L1L3 control animal data
P2L1L3_control_animal_Q = sprintf("SELECT id, health, genotype, tasktypedone, referencetime, " + ...
    "subjectid, gender, notes FROM live_table WHERE id IN (%s) AND " + ...
    "genotype = 'CRL: Long Evans' AND (health = 'N/A' OR health = 'NA') AND " + ...
    "REPLACE(tasktypedone, ' ', '') = 'P2L1L3' AND UPPER(subjectid) <> UPPER('none')", idList);
P2L1L3_control_data = fetch(conn, P2L1L3_control_animal_Q);
P2L1L3_control_data.referencetime = datetime(P2L1L3_control_data.referencetime, 'Format', 'MM/dd/yyyy');
P2L1L3_control_data.referencetime = dateshift(P2L1L3_control_data.referencetime, 'start', 'day');
P2L1L3_control_data = sortrows(P2L1L3_control_data, "referencetime");

% Control animal phase1 data
start_date = datetime('03/15/2022', 'InputFormat', 'MM/dd/yyyy');
end_date = datetime('06/20/2022', 'InputFormat', 'MM/dd/yyyy');
end_date = end_date + days(1);
dateFilter = P2L1L3_control_data.referencetime >= start_date & ...
    P2L1L3_control_data.referencetime <= end_date;
P2L1L3_control_p1_data = P2L1L3_control_data(dateFilter, :);
P2L1L3_control_p1_id = P2L1L3_control_p1_data.id;

