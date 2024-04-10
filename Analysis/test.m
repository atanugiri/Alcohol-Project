% Define the function g(R)
g = @(R, c) c * (R.^2 / 2) + R;
q = @(R, c) c * (R.^2 / 2);

% Define the parameter c
c = -1;

% Generate a range of R values
R = linspace(-10, 10, 100);

% Calculate g(R) values
g_values = g(R, c);
q_values = g(R, c);

figure(1);
% Plot g(R) against R
plot(R, g_values, 'LineWidth', 2, 'DisplayName','g(R)');
hold on;
plot(R, q_values, 'LineWidth', 2,'LineStyle','--', 'Color', 'r', 'DisplayName', 'q(R)');

xlabel('R');
ylabel('g(R)');
legend('show');
grid on;

