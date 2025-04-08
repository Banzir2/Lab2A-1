

w_70 = [1.87 6.283 6.9113 7.5396 7.66526 7.79 7.92 8.04224, ...
    8.1679 8.29356 8.41922 8.55 8.68 8.7962 9.43 10.0528 14.4];
A_70 = [0.000538 0.00125 0.00196 0.00305 0.00378 0.00478 0.00644, ...
    0.01 0.0155 0.0154 0.0104 0.00692 0.00493 0.00381 0.00172 0.0014 0.000252];

w_40 = [3.52 7.92 8.55 9.17 9.3 9.42 9.55 9.67, ...
    9.84 9.93 10 10.2 10.3 10.4 11.1 11.7 16.1];
A_40 = [0.00063 0.0015 0.00219 0.00417 0.00514 0.00668 0.00906 0.0127, ...
    0.0138 0.0119 0.00918 0.00674 0.00517 0.00416 0.00198 0.00126 0.000338];

w_20 = [5.21 9.61299 10.24129 10.86959 10.99525 11.12091 11.24657 11.37223, ...
    11.49789 11.62355 11.74921 11.87487 12.00053 12.12619 12.75449 13.38279 17.8];
A_20 = [0.000687 0.00183 0.00251 0.00478 0.00595 0.00769 0.0095 0.011, ...
    0.0113 0.0106 0.00877 0.00704 0.00582 0.00455 0.00242 0.00157 0.000571];

w_90 = [1.27 5.67 6.29 6.91 7.08 7.16 7.28 7.42,...
    7.54 7.67 7.79 7.94 8.03 8.17 8.8 9.42 13.8];
A_90 = [0.000542 0.00125 0.00165 0.00315 0.00402 0.005 0.00697 0.0125,...
   0.0188 0.0131 0.00792 0.00513 0.00402 0.00316 0.00148 0.00095 0.000217];

omega_err = ones(17, 1) / 1000;
A_err = ones(17, 1) / 10000;

% Ensure data is column vectors
w_90 = w_90(:);     % force column
A_90 = A_90(:);
omega_err = omega_err(:);
A_err = A_err(:);

% Plot
figure; hold on;
e = errorbar(w_90, A_90, A_err, A_err, 'o');
e.CapSize = 0;

% Fit
f = fit(w_90, A_90, 'a/(sqrt(b^2 * x^2 + 0.09797^2 * (c^2 - x^2)^2))');

% Plot fit
plot(f);
xlabel('w_d [rad/sec]', 'FontSize', 14);
ylabel('Amplitude [m]', 'FontSize', 14);
title('Amplitude by force frequency (90gr)', 'FontSize', 14);
legend('Data', 'Fit', 'FontSize', 14);
% Extract coefficients
a = f.a;
b = f.b;
c = f.c;

% Get 95% confidence intervals
ci = confint(f);   % 2x3 matrix: [lower; upper]

% Calculate standard errors (assuming normal distribution)
a_err = (ci(2,1) - ci(1,1)) / 2;
b_err = (ci(2,2) - ci(1,2)) / 2;
c_err = (ci(2,3) - ci(1,3)) / 2;

% Calculate residuals and chi-squared
theo_amp = f(w_90);             % this is now column vector
r0 = A_90 - theo_amp;           % column
sigma2 = A_err.^2 + (1.413^2) * omega_err.^2 + (4e-4)^2;  % column
xhisquare_force = sum((r0.^2) ./ sigma2) / 14;

disp(['Chi-squared: ', num2str(xhisquare_force)]);

figure; 
scatter(w_90, r0);
title("Residuals Graph", 'FontSize', 14);
xlabel("w_d [rad/sec]", 'FontSize', 14);
ylabel("Length [m]", 'FontSize', 14);

m=[0.04769, 0.0676, 0.09797, 0.1178];
m_error=[0.01,0.03,0.04,0.05];
w_r_error=[0.013855857, 0.010604751, 0.0064, 0.004282679];
w_r=[11.48990287, 9.791696586, 8.2384, 7.555307712];
% Plot
figure; hold on;
e = errorbar(m, w_r, m_error, w_r_error, 'o');
e.CapSize = 0;
% Fit
fitmodel = fittype('sqrt(a + b / x)', 'independent', 'x', 'coefficients', {'a', 'b'});
f = fit(m.', w_r.', fitmodel);

% Plot fit
plot(f);
xlabel('mass [kg]', 'FontSize', 14);
ylabel('w_r [rad/sec]', 'FontSize', 14);
title('resonance by mass', 'FontSize', 14);
legend('Data', 'Fit', 'FontSize', 14);

m = m(:);
w_r = w_r(:);
m_error = m_error(:);
w_r_error = w_r_error(:);
% Calculate residuals and chi-squared
theo_amp = f(m);             % this is now column vector
r0 = w_r - theo_amp;           % column
sigma2 = m_error.^2 + (1.413^2) * w_r_error.^2 + (4e-4)^2;  % column
xhisquare_force1 = sum((r0.^2) ./ sigma2) / 2;
