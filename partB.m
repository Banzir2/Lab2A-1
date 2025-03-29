clear;
close all;

mass = [10.04 19.99 30.03 39.86, ...
    50.28 60.32 70.27 80.31 90.14].' / 1000;
platform = ones(9,1) * (15.23 / 1000);
mass = mass + platform;
wings = ones(9,1) * (6.38 + 6.09) / 1000;
mass_winged = mass + wings;

tau = [16.12903226 18.01801802 25.18891688 28.65329513, ...
    33.67003367 35.71428571 42.37288136 47.39336493 45.87155963];
omega = [16.1 13.759 12.197 11.082, ...
    10.193 9.508 8.956 8.485 8.087];
tau_winged = [3.384094755 4.201680672 4.535147392 4.716981132, ...
    5.221932115 6.042296073 6.535947712 6.557377049 7.054673721];
omega_winged = [12.8 11.5 10.5, ...
    9.79 9.14 8.65 8.23 7.85 7.54];

theo_winged_omega = sqrt(omega.^2 - 1./tau_winged.^2);

figure; scatter(mass, tau);
xlabel('Mass [kg]', 'FontSize', 14);
ylabel('Tau [sec]', 'FontSize', 14);
title('Regression Rate by Mass', 'FontSize', 14);
figure; scatter(mass, omega);
xlabel('Mass [kg]', 'FontSize', 14);
ylabel('Omega [sec^-^1]', 'FontSize', 14);
title('Angular Frequency by Mass', 'FontSize', 14);
figure; scatter(mass, tau_winged);
xlabel('Mass [kg]', 'FontSize', 14);
ylabel('Tau [sec]', 'FontSize', 14);
title('Winged Regression Rate by Mass', 'FontSize', 14);
figure; scatter(mass, omega_winged);
xlabel('Mass [kg]', 'FontSize', 14);
ylabel('Omega [sec^-^1]', 'FontSize', 14);
title('Winged Angular Frequency by Mass', 'FontSize', 14);