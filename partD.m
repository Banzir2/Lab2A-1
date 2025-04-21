clear;
close all;

% Load data
data = readmatrix('Capstone_Data.csv');
nRuns = size(data, 2) / 2;

% Preallocate to store coefficients [a, w, b]
coefficients = zeros(nRuns, 3);

% Loop through each run
for k = 1:nRuns
    tData = data(:, 2*k - 1);
    xData = data(:, 2*k);

    % Remove NaN values
    valid = ~isnan(tData) & ~isnan(xData);
    t = tData(valid);
    x = xData(valid);

    % Skip last 100 points, take 400 before that
    if length(t) >= 500
        t = t(end - 499:end - 100);
        x = x(end - 499:end - 100);
    else
        warning("Run %d has less than 500 valid points; skipping.", k);
        continue;
    end

    % Estimate frequency using FFT
    x_detrended = x - mean(x);
    Y = abs(fft(x_detrended));
    dt = mean(diff(t));
    f_axis = (0:length(Y)-1)/(dt * length(Y));
    [~, idx] = max(Y(2:floor(end/2))); % ignore DC
    f0 = f_axis(idx + 1);
    w0 = 2 * pi * f0;

    % Estimate starting values
    a0 = (max(x) - min(x)) / 2;
    b0 = mean(x);

    % Define model
    model = fittype('a*cos(w*x)+b', 'independent', 'x', 'coefficients', {'a', 'w', 'b'});

    % Fit the model
    [fitresult, ~] = fit(t, x, model, 'StartPoint', [a0, w0, b0]);

    % Store coefficients
    coefficients(k, :) = [fitresult.a, fitresult.w, fitresult.b];

    % Plot each result
    %figure;
    %plot(t, x, 'b.', 'DisplayName', sprintf('Data t%d, x%d', k, k));
    %hold on;
    %plot(t, fitresult(t), 'r-', 'LineWidth', 2, 'DisplayName', 'Fitted Curve');
    %legend;
    %title(sprintf('Run %d: x(t) = %.3f*cos(%.3f*t) + %.3f', k, fitresult.a, fitresult.w, fitresult.b));
    %xlabel('t [s]');
    %ylabel('x [m]');
    %grid on;
end

% Display all coefficients
disp('Coefficients [a, w, b] for each run:');
disp(coefficients);

% Extract a and w from coefficients matrix
a_values = abs(coefficients(:, 1));
w_values = coefficients(:, 2);

% Remove any rows where the fit failed (i.e., zeros)
valid = a_values ~= 0 & w_values ~= 0;
a_values = a_values(valid);
w_values = w_values(valid);

% Plot: only points, no connecting lines, smaller markers
figure;
plot(w_values, a_values, '.', 'MarkerSize', 30, 'LineWidth', 1);
xlabel('\omega [rad/s]', 'FontSize', 16);
ylabel('Amplitude [m]', 'FontSize', 16);
title('Amplitude vs Angular Frequency (a vs \omega)', 'FontSize', 16);
grid on;
hold on;

% Fit to theoretical A_2(ω) model
% Constants (you can change if needed)
k1 = 6.983;    % spring constant 1
k2 = 7.1037;    % spring constant 2
m1 = 19.99/ 1000;   % mass 1
m2 = 50.37/ 1000;   % mass 2
F0 = 1;     % driving force amplitude

% Define theoretical A_2(w) function
A2_model = @(w) ((F0 .* k2) ./ ((k1 + k2 - m1*w.^2) .* (k2 - m2*w.^2) - k2.^2));
A1_model = @(w) F0*((k2 - m2*w.^2)./((k1 + k2 - m1*w.^2).*(k2 - m2*w.^2) - k2^2));

% --- Evaluate and plot the curve ---
w_plot = linspace(0, 40, 500);
a_theory = abs(A2_model(w_plot) + A1_model(w_plot));


f = fit(w_values, a_values, 'abs((a * 7.1037) / ((6.983 + 7.1037 - (19.99/1000)*x^2) * (6.983 - (50.37/1000)*x^2) - 7.1037^2) + a*((7.1037 - (50.37/1000)*x^2)/((6.983 + 7.1037 - (19.99/1000)*x^2)*(7.1037 - (50.37/1000)*x^2) - 7.1037^2)))');

% Plot the curve on the same graph
hold on;
plot(w_plot, a_theory, 'r-', 'LineWidth', 2, 'DisplayName', 'Theoretical A_2(\omega)');
legend('Data', 'Theory', 'FontSize', 14);

