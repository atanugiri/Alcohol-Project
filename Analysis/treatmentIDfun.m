% Author: Atanu Giri
% Date: 02/11/2024

function id = treatmentIDfun(treatment)

if strcmpi(treatment, "P2L1 Baseline")
    [id, ~, ~, ~] = extract_treatment_ids;
elseif strcmpi(treatment, "P2L1 Food deprivation")
    [~, id, ~, ~] = extract_treatment_ids;
elseif strcmpi(treatment, "Initial task")
    [~, ~, id, ~] = extract_treatment_ids;
elseif strcmpi(treatment, "Late task")
    [~, ~, ~, id] = extract_treatment_ids;


elseif strcmpi(treatment, "P2L1 Saline")
    [id, ~, ~, ~] = extract_sal_ghr_ids;
elseif strcmpi(treatment, "P2L1 Ghrelin")
    [~, id, ~, ~] = extract_sal_ghr_ids;
elseif strcmpi(treatment, "P2L1L3 Saline")
    [~, ~, id, ~] = extract_sal_ghr_ids;
elseif strcmpi(treatment, "P2L1L3 Ghrelin")
    [~, ~, ~, id] = extract_sal_ghr_ids;


elseif strcmpi(treatment, "Sal toyrat")
    [id, ~, ~, ~, ~, ~] = extract_toy_expt_ids;
elseif strcmpi(treatment, "Ghr toyrat")
    [~, id, ~, ~, ~, ~] = extract_toy_expt_ids;
elseif strcmpi(treatment, "Sal toystick")
    [~, ~, id, ~, ~, ~] = extract_toy_expt_ids;
elseif strcmpi(treatment, "Ghr toystick")
    [~, ~, ~, id, ~, ~] = extract_toy_expt_ids;
elseif strcmpi(treatment, "Sal skewer")
    [~, ~, ~, ~, id, ~] = extract_toy_expt_ids;
elseif strcmpi(treatment, "Ghr skewer")
    [~, ~, ~, ~, ~, id] = extract_toy_expt_ids;


elseif strcmpi(treatment,"Combined Sal toy")
    [sal_toyrat_id, ~, ~, ~, ~, ~] = extract_toy_expt_ids;
    [~, ~, sal_toystick_id, ~, ~, ~] = extract_toy_expt_ids;
    id = vertcat(sal_toyrat_id, sal_toystick_id);
elseif strcmpi(treatment,"Combined Ghr toy")
    [~, ghr_toyrat_id, ~, ~, ~, ~] = extract_toy_expt_ids;
    [~, ~, ~, ghr_toystick_id, ~, ~] = extract_toy_expt_ids;
    id = vertcat(ghr_toyrat_id, ghr_toystick_id);


elseif strcmpi(treatment, "Alcohol bl")
    [id, ~, ~, ~, ~] = extract_alcohol_ids;
elseif strcmpi(treatment, "Boost")
    [~, id, ~, ~, ~] = extract_alcohol_ids;
elseif strcmpi(treatment, "Alcohol")
    [~, ~, id, ~, ~] = extract_alcohol_ids;
elseif strcmpi(treatment, "Sal alcohol")
    [~, ~, ~, id, ~] = extract_alcohol_ids;
elseif strcmpi(treatment, "Ghr alcohol")
    [~, ~, ~, ~, id] = extract_alcohol_ids;
end
end