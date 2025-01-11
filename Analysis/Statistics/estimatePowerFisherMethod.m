function power_estimate = estimatePowerFisherMethod(data, num_simulations, alpha, effect_size)

if nargin < 4
    alpha = 0.05;
    effect_size = 0.5;
end
% Initialize counter for significant results
significant_count = 0;

% Run simulations
for sim = 1:num_simulations
    % Simulate data under alternative hypothesis
    sim_data = cellfun(@(x) x + randn(size(x)) * effect_size, data, 'UniformOutput', false);

    % Run FisherMethod on simulated data
    [~, combined_p] = FisherMethod(sim_data);

    % Check if combined p-value is significant
    if min(combined_p) < alpha
        significant_count = significant_count + 1;
    end
end

% Calculate power as proportion of significant results
power_estimate = significant_count / num_simulations;
end