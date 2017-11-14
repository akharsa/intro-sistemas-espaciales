clear all;
close all;
clc;

% Load astronomical constants
addpath('../vallado');
run('constastro.m');

%% Initial orbit
r_apogee = re + 36000;
r_perigee = re + 300;
a = (r_apogee +  r_perigee)/2;
V_gto_apogee = sqrt(2*mu/r_apogee-mu/a);

%% Final orbit
r = re + 36000;
V_geo = sqrt(mu/r);
%% Calculation
deltaV = V_geo - V_gto_apogee;

fprintf('Velocity at GTO apogee: %f km/s\n',V_gto_apogee);
fprintf('Velocity at GEO: %f km/s\n',V_geo);
fprintf('Delta V requiered: %f km/s\n', deltaV);

%% 
Isp = 321;
dry_mass = 1500;
propellant_mass = (1-exp(-deltaV*1000/(Isp*9.8)))*dry_mass;
fprintf('Required propellant mass: %f kg\n',propellant_mass);