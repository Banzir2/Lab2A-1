clear;
close all;

mass = [0 4.98 10.04 15.02 19.99 24.97 30.03 35.01 39.86 44.84, ...
    50.28 55.26 60.32 65.3 70.27 75.25 80.31 85.29 90.14].' / 1000;
platform = ones(19,1) * (15.23 / 1000);
mass = mass + platform
x = [559.2 552.7 545.1 537.7 531.6 524.3 517.3 509.5 503.7 496.6 488.9, ...
    481.6 474.1 467.2 460 452.5 446.3 439.4 431.6].' / 1000;
mass_error = [0.01, 0.02, 0.02, 0.03, 0.02, 0.03, 0.03, 0.04, 0.04, ...
    0.05, 0.02, 0.03, 0.03, 0.04, 0.03, 0.04, 0.04, 0.05, 0.05].' / sqrt(12) / 1000;
x_error = ones(19, 1) * (0.3 / 1000);

hold on;

zero_height = ones(19, 1) * 559.2 / 1000;
x = zero_height - x;
g = 9.80665;
errorbar(x, mass * g, x_error, x_error, mass_error * g, mass_error * g, '.');
f = fit(x, mass * g, 'poly1');

k = 6.938;
theo_force = f(x);
rsquare = (mass * g - theo_force).^2;
xhisquare = sum(rsquare ./ ((k*x_error).^2 + (mass_error * g).^2)) / 17;

omega0 = sqrt((ones(19, 1)*k) ./ mass);
figure; scatter(mass, omega0);