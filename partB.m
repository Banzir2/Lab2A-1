clear;
close all;

mass = [10.04 19.99 30.03 39.86, ...
    50.28 60.32 70.27 80.31 90.14].' / 1000;
mass_error = [0.02, 0.02, 0.03, 0.04, ...
    0.02, 0.03, 0.03, 0.04, 0.05].' / sqrt(12) / 1000;
platform = ones(9,1) * (15.23 / 1000);
mass = mass + platform;
wings = ones(9,1) * (6.38 + 6.09) / 1000;
mass_winged = mass + wings;

tau = [16.12903226 18.01801802 25.18891688 28.65329513, ...
    33.67003367 35.71428571 42.37288136 47.39336493 45.87155963].';
tau_err = [0.026014568158168574 0.032464897329762196, ...
    0.06344815334149699 0.08210113217461269 0.1133671167341201, ...
    0.12755102040816327 0.1795461074403907 0.2246131039284832 0.21041999831664004].';
omega = [16.1 13.759 12.197 11.082, ...
    10.193 9.508 8.956 8.485 8.087].';
omega0 = [16.5696954731466 14.0353249479338 12.3811182914075 11.2222712468034, ...
    10.2911367223901 9.58296525252519 9.00811849557994 8.52166641033568 8.11444195057850].';
omega_err = ones(9, 1) / 1000;
tau_winged = [3.384094755 4.201680672 4.535147392 4.716981132, ...
    5.221932115 6.042296073 6.535947712 6.557377049 7.054673721].';
tau_winged_err = [0.0011452097308470833 0.0017654120471718104, ...
    0.002056756186979705 0.0022249911000356 0.0027268575012441287, ...
    0.00365093418278402 0.0042718612499466025 0.004299919376511691 0.004976842131457064].';
omega_winged = [12.8 11.5 10.5, ...
    9.79 9.14 8.65 8.23 7.85 7.54].';

theo_winged_omega = sqrt(omega.^2 - 1./tau_winged.^2);

figure; hold on;
e = errorbar(mass, tau, tau_err, tau_err, mass_error, mass_error, 'o');
e.CapSize = 0;
xlabel('Mass [kg]', 'FontSize', 14);
ylabel('Tau [sec]', 'FontSize', 14);
title('Regression Rate by Mass', 'FontSize', 14);
figure; hold on;
e = errorbar(mass, omega, omega_err, omega_err, mass_error, mass_error, 'o');
e.CapSize = 0;
f = fit(mass, omega, 'a*(1/x^0.5)');
plot(f);
xlabel('Mass [kg]', 'FontSize', 14);
ylabel('Omega [sec^-^1]', 'FontSize', 14);
title('Angular Frequency by Mass', 'FontSize', 14);
legend('Data', 'Fit', 'FontSize', 14);
figure; hold on;
e = errorbar(mass, tau_winged, tau_winged_err, tau_winged_err, mass_error, mass_error, 'o');
e.CapSize = 0;
xlabel('Mass [kg]', 'FontSize', 14);
ylabel('Tau [sec]', 'FontSize', 14);
title('Winged Regression Rate by Mass', 'FontSize', 14);
figure; hold on;
e = errorbar(mass, omega_winged, omega_err, omega_err, mass_error, mass_error, 'o');
e.CapSize = 0;
xlabel('Mass [kg]', 'FontSize', 14);
ylabel('Omega [sec^-^1]', 'FontSize', 14);
title('Winged Angular Frequency by Mass', 'FontSize', 14);