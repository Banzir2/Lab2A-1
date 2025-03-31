clear;
close all;

data = readmatrix("Capstone Data.csv");
time = data(:, 133);
time = time(~isnan(time));
h = data(:, 134);
h = h(~isnan(h));
m = 0.11784;
g = 9.80665;
k = 6.983;

c = estimate_drag_coefficient(time, h, m, k);

dt = 0.01;
y = 0;
v = 0.5;
t = 0:dt:10;
y_arr = zeros(size(t));
for i = t
    a = (-k*y-c*v*abs(v)+m*g) / m;
    y = y - v*dt;
    v = v - a*dt;
    
    y_arr(int32(i / dt) + 1) = y;
end
scatter(t, y_arr);