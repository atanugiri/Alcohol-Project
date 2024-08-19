% Author: Atanu Giri
% Date: 01/25/2024

function error_ellipse_fun(data, alpha, plotColor)
try

% Calculate the eigenvectors and eigenvalues
covariance = cov(data);
[eigenvec, eigenval] = eig(covariance);

% Find the index of the maximum eigenvalue
[~, max_index] = max(diag(eigenval));

% Extract the largest eigenvector and eigenvalue
largest_eigenvec = eigenvec(:, max_index);
largest_eigenval = eigenval(max_index, max_index);


% Get the smallest eigenvector and eigenvalue
[~, min_index] = min(diag(eigenval));
smallest_eigenvec = eigenvec(:, min_index);
smallest_eigenval = eigenval(min_index, min_index);

% Calculate the angle between the x-axis and the largest eigenvector
angle = atan2(largest_eigenvec(2), largest_eigenvec(1));

% This angle is between -pi and pi.
% Let's shift it such that the angle is between 0 and 2pi
if(angle < 0)
    angle = angle + 2*pi;
end

% Get the coordinates of the data mean
avg = mean(data);

% Get the 95% confidence interval error ellipse
chiSqVal = chi2inv(alpha, 2);

theta_grid = linspace(0,2*pi);
phi = angle;
X0 = avg(1);
Y0 = avg(2);
a = sqrt(chiSqVal*largest_eigenval);
b = sqrt(chiSqVal*smallest_eigenval);

% the ellipse in x and y coordinates
ellipse_x_r = a*cos(theta_grid);
ellipse_y_r = b*sin(theta_grid);

%Define a rotation matrix
R = [cos(phi) sin(phi); -sin(phi) cos(phi)];

%let's rotate the ellipse to some angle phi
r_ellipse = [ellipse_x_r; ellipse_y_r]' * R;

% Draw the error ellipse
plot(X0, Y0, '.', 'Color', 'k', 'MarkerSize', 20, 'DisplayName', '');
hold on;
plot(data(:,1),data(:,2),'.', 'MarkerSize',10, 'Color',plotColor);
plot(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,'-','Color',plotColor,'LineWidth',2,'DisplayName','');

% Plot the original data
% plot(data(:,1), data(:,2), '.','Color', plotColor, 'DisplayName','');

% Plot the eigenvectors
% quiver(X0, Y0, largest_eigenvec(1)*sqrt(largest_eigenval), largest_eigenvec(2)*sqrt(largest_eigenval), ...
%     '-r', 'LineWidth',2, 'DisplayName','');
% quiver(X0, Y0, smallest_eigenvec(1)*sqrt(smallest_eigenval), smallest_eigenvec(2)*sqrt(smallest_eigenval), ...
%     '-b', 'LineWidth',2, 'DisplayName','');

catch
    disp("Some problem");
end
end