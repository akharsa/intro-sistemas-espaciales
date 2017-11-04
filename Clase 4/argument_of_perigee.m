clear all;
close all;
clc;

% Load astronomical constants
addpath('../vallado');
run('constastro.m');

%% Initial orbit
apogee_0 = 300 + re;
perigee_0 = 36000 + re;
w_0 = 0.0;

%% Final orbit
w_final = 10;

%% Calculation
alpha = w_final - w_0;
a = (apogee_0 + perigee_0)/2;
e = (apogee_0 - perigee_0)/(apogee_0 + perigee_0);
delta_V = 2*sqrt(mu/(a*(1-e^2)))*e*sin(deg2rad(alpha)/2);