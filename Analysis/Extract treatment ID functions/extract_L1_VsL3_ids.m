% Author: Atanu Giri
% Date: 01/23/2025
%
% Extract L1 and L3 ids separately from L1L3 data

function [P2L1L3_Baseline_L1_id, P2L1L3_Baseline_L3_id, ...
    P2L1L3_BL_for_comb_boost_and_alc_L1_id, ...
    P2L1L3_BL_for_comb_boost_and_alc_L3_id, ...
    P2L1L3_Boost_and_alcohol_L1_id, P2L1L3_Boost_and_alcohol_L3_id, ...
    P2L1L3_Post_alcohol_L1_id, P2L1L3_Post_alcohol_L3_id] = ...
    extract_L1_VsL3_ids(conn)

if nargin < 1
    % Connect to database
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');
end

feature = 'approachavoid';

%% P2L1L3 Baseline ids
[P2L1L3_Baseline_L1_id, P2L1L3_Baseline_L3_id] = extractIDs('P2L1L3 Baseline');

%% P2L1L3_BL_for_comb_boost_and_alc ids
[P2L1L3_BL_for_comb_boost_and_alc_L1_id, P2L1L3_BL_for_comb_boost_and_alc_L3_id] ...
    = extractIDs('P2L1L3 BL for comb boost and alc');

%% P2L1L3_Boost_and_alcohol ids
[P2L1L3_Boost_and_alcohol_L1_id, P2L1L3_Boost_and_alcohol_L3_id] ...
    = extractIDs('P2L1L3 Boost and alcohol');

%% P2L1L3 Post alcohol
[P2L1L3_Post_alcohol_L1_id, P2L1L3_Post_alcohol_L3_id] = extractIDs('P2L1L3 Post alcohol');

%% Description of extractIDs
    function [grp1ID, grp2ID] = extractIDs(treatmentGroup)
        % treatmentGroup = 'P2L1L3 Baseline';
        treatmentIDs = treatmentIDfun(treatmentGroup, conn);
        treatmentIDs_str = strjoin(arrayfun(@num2str, treatmentIDs, 'UniformOutput', false), ',');
        treatment_data = fetchHealthDataTable(feature, treatmentIDs_str, conn);

        % Additional query
        addQuery = sprintf("SELECT id, lightlevel, intensityofcost1, " + ...
            "intensityofcost2, intensityofcost3 " + ...
            "FROM live_table WHERE id IN (%s) ORDER BY id", treatmentIDs_str);
        addData = fetch(conn, addQuery);
        treatment_data = innerjoin(treatment_data,addData,'Keys','id');
        treatment_data.lightlevel = str2double(string(treatment_data.lightlevel));

        % Use regexprep to remove any non-numeric characters from the intensityofcost1 column
        treatment_data.intensityofcost1 = str2double(regexprep( ...
            string(treatment_data.intensityofcost1), '[^\d.]', ''));
        treatment_data.intensityofcost2 = str2double(regexprep( ...
            string(treatment_data.intensityofcost2), '[^\d.]', ''));
        treatment_data.intensityofcost3 = str2double(regexprep( ...
            string(treatment_data.intensityofcost3), '[^\d.]', ''));

        filter = ismember(treatment_data.intensityofcost3, [320, 290, 218]) ...
            & treatment_data.lightlevel == 2;
        treatment_data.lightlevel(filter) = 3;

        % Separate data based on light level
        grp1Data = treatment_data(treatment_data.lightlevel == 1, :);
        grp2Data = treatment_data(treatment_data.lightlevel == 3 & ...
            treatment_data.intensityofcost3 >= 320, :);

        grp1ID = grp1Data.id;
        grp2ID = grp2Data.id;

    end
end