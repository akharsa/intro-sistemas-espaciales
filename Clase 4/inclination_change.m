clear all;
close all;
clc;

% Load astronomical constants
addpath('../vallado');
run('constastro.m');

%% Initial orbit
r_0 = re + 300;
i_0 = 3.0;

%% Final orbit
i_final = 0.0;

%% Calculation
vinitial = sqrt(mu/r_0);
vfinal = vinitial;
theta = i_final-i_0;

deltaV = 2*vinitial*sin(deg2rad(theta)/2)
deltaV_X = vfinal*cos(deg2rad(theta))-vinitial
deltaV_Y = vfinal*sin(deg2rad(theta))

