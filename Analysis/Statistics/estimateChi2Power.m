function power_estimate = estimateChi2Power(count1, total1, count2, total2, num_simulations, alpha, effect_size)

if nargin < 5
    num_simulations = 1000;
    alpha = 0.05;
    effect_size = 0.1;
end
% Initialize counter for significant results
significant_count = 0;

% Define proportions based on effect size
p1 = count1 / total1;
p2 = count2 / total2 + effect_size; % Adjust p2 based on effect size

% Run simulations
for sim = 1:num_simulations
    % Generate simulated counts based on binomial distribution
    sim_count1 = binornd(total1, p1);
    sim_count2 = binornd(total2, p2);

    % Perform chi-squared test on simulated data
    p = chi2test([sim_count1, total1 - sim_count1; sim_count2, total2 - sim_count2]);

    % Check if the test is significant
    if p < alpha
        significant_count = significant_count + 1;
    end
end

% Calculate power as the proportion of significant results
power_estimate = significant_count / num_simulations;
end