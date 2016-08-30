clear all;
close all;
clc;

% Load astronomical constants
addpath('../vallado');
run('constastro.m');

%% Orbit definition
h = 500.0;
inc = 45.0;
e = 0.000;
omega = 0.0;
t0 = datenum('28 Aug 2016 15:00:00.000 UTCG');


%% Other parameters
j2 = 1082.62E-6;

%%
a = re + h; % Semimajor axis
p = 2*pi*sqrt(a^3/mu); % period

%%
omega = deg2rad(omega);
delta_omega = -3/2*j2*(re/(a*(1-e^2)))^2*sqrt(mu/(a^3))*cos(deg2rad(inc)); % rad_sec


beta = zeros(1,365);
eclipse = zeros(1,365);

for t = 0:1:365-1;    
    
    tvec = datevec(t0+t);
    
    [~, sun_ra, sun_dec] = sun(jday(tvec(1), tvec(2), tvec(3), tvec(4), tvec(5), tvec(6)));
    
    beta(t+1) = beta_angle(omega, deg2rad(inc), sun_ra, sun_dec);
    eclipse(t+1) = eclipse_fraction(re, h, beta(t+1));
    
    omega = omega + delta_omega*60*60*24;    
    
end

%%
figure
plot(rad2deg(beta))

height = 0.4;
width = 0.5;
figure('units','normalized','position',[width/2 height/2  width height]);
plot(eclipse*p/60);
title(sprintf('Eclipse duration through the year for h = %.1f Km , e = %.3f, i = %.3f ', h, e, inc));
ylabel('Minutes');
xlabel('Days');
grid on;