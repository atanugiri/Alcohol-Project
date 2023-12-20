% Author: Atanu Giri
% Date: 12/20/2023

function [Sal_toyrat_id, Ghr_toyrat_id, Sal_toystick_id, Ghr_toystick_id, ...
    Sal_skewer_id, Ghr_skewer_id] = extract_health_ids

datasource = 'live_database';
conn = database(datasource,'postgres','1234');
dateQuery = "SELECT id, referencetime, health, subjectid FROM live_table ORDER BY id";

allData = fetch(conn, dateQuery);
allData.referencetime = datetime(allData.referencetime, 'Format', 'MM/dd/yyyy');
allData.health = string(allData.health);
allData.subjectid = string(allData.subjectid);

allData(allData.subjectid == "none", :) = [];

startDate = datetime('09/12/2023', 'InputFormat', 'MM/dd/yyyy');
endDate = datetime('12/11/2023', 'InputFormat', 'MM/dd/yyyy');

endDate = endDate + days(1);
dataInRange = allData(allData.referencetime >= startDate & allData.referencetime <= endDate, :);

% ToyRat data
Sal_toyrat_data = dataInRange(contains(strrep(dataInRange.health, ' ',''), ...
    strrep("Saline toyrat",' ',''), 'IgnoreCase',true) | strcmpi(dataInRange.health, 'Saline') ...
    | strcmpi(dataInRange.health, 'saline day') | strcmpi(dataInRange.health, 'SA'), :);
Sal_toyrat_id = Sal_toyrat_data.id;

Ghr_toyrat_data = dataInRange(contains(strrep(dataInRange.health, ' ',''), ...
    strrep("Ghrelin toyrat",' ',''), 'IgnoreCase',true) | strcmpi(dataInRange.health, 'GHR') ...
    | strcmpi(dataInRange.health, 'ghrelin day') | strcmpi(dataInRange.health, 'ghr toyrat'), :);

% Remove bad data
targetDate = datetime('09/12/2023', 'Format', 'MM/dd/yyyy');
Ghr_toyrat_data(Ghr_toyrat_data.subjectid == "bob" & Ghr_toyrat_data.referencetime == ...
    targetDate,:) = []; % For toyrat experiment
Ghr_toyrat_id = Ghr_toyrat_data.id;

% ToyStick data
Sal_toystick_data = dataInRange(contains(strrep(dataInRange.health, ' ',''), ...
    strrep("Saline toystick",' ',''), 'IgnoreCase',true), :);
Sal_toystick_id = Sal_toystick_data.id;

Ghr_toystick_data = dataInRange(contains(strrep(dataInRange.health, ' ',''), ...
    strrep("Ghrelin toystick",' ',''), 'IgnoreCase',true), :);
Ghr_toystick_id = Ghr_toystick_data.id;

% ToySkewer data
Sal_skewer_data = dataInRange(contains(strrep(dataInRange.health, ' ',''), ...
    strrep("Saline ToySkewer",' ',''), 'IgnoreCase',true), :);
Sal_skewer_id = Sal_skewer_data.id;

Ghr_skewer_data = dataInRange(contains(strrep(dataInRange.health, ' ',''), ...
    strrep("Ghrelin ToySkewer",' ',''), 'IgnoreCase',true), :);
Ghr_skewer_id = Ghr_skewer_data.id;

close(conn);
end