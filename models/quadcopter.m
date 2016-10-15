% Simulation times, in seconds.
start_time = 0;
end_time = 10;
dt = 0.05;
times = start_time:dt:end_time;
plot_data = [];

% Number of points in the simulation.
N = numel(times);

%Initial simulation state.
x = [0; 0; 0];
x_last = x;
xdot = zeros(3, 1);
theta = zeros(3, 1);

% Simulate some disturbance in the angular velocity
% The magnitude of the deviation is in radians / second.
deviation = 100;
thetadot = deg2rad(2 * deviation * rand(3, 1) - deviation);
thetadot = zeros(3,1);

% Physical constant
m = 1;
g = 9.8;
k = 1;
kd = 0;
I = 0.008;
L = 0.25;
b = 0.007;
figure(1)
plot3(0,0,0,'XDataSource','plot_data(:,1)','YDataSource','plot_data(:,2)','ZDataSource','plot_data(:,3)');
grid on;
i = [2.45 2.45 2.45 2.45];
%Step through the simulation, updating the state.
for t = times
 
    
    omega = thetadot2omega(thetadot, theta);
    
    a = acceleration(i, theta, xdot, m, g, k, kd);
    omegadot = angular_acceleration(i, omega, I, L, b, k);
    
    omega = omega + dt * omegadot;
    thetadot = omega2thetadot(omega, theta);
    theta = theta + dt * thetadot;
    xdot = xdot + dt * a;
    x = x + dt * xdot;
    i = rotor_input(t, x, xdot, theta, thetadot, x_last);
    x_last = x;

    %if mod(t * 200,20) == 0
    quadplot(x,theta,i);
    %end
    pause(0.01)
 
end