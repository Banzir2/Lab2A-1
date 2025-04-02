function c = estimate_drag_coefficient(time, y, m, k)
    % Given time series data for y, estimate the drag coefficient c.

    g = 9.80665;  % Gravity (m/s^2)
    y0 = mean(y);  % Approximate equilibrium position
    
    dt = diff(time);  % Time step differences
    v = diff(y) ./ dt;  % Numerical derivative for velocity
    a = diff(v) ./ dt(2:end);  % Numerical derivative for acceleration
    
    % Trim arrays to match dimensions
    y = y(2:end-1);  % Remove first and last points to match acceleration length
    v = v(2:end);  % Align velocity array with acceleration
    
    % Compute c values for each time step
    c_values = -(m * a + k * (y - y0) + m * g) ./ (v .* abs(v));
    
    % Filter out invalid values (e.g., division by zero)
    c_values = c_values(~isnan(c_values) & ~isinf(c_values));
    
    % Average the drag coefficient over all valid data points
    c = mean(c_values);
end