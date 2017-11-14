clear all;
close all;
clc;

% Load astronomical constants
addpath('../vallado');
run('constastro.m');

%% Initial orbit
rinitial = re + 300;

%% Final orbit
rapo = re + 36000;
rperi = rinitial;

afinal = (rapo +  rperi)/2;

%% Calculation
Vinicial = sqrt(mu/rinitial);
Vfinal = sqrt(2*mu/rperi-mu/afinal);
deltaV = Vfinal - Vinicial;

fprintf('Initial orbit velocity: %f km/s\n',Vinicial);
fprintf('Final orbit velocity at perigee: %f km/s\n',Vfinal);
fprintf('Delta V requiered: %f km/s\n', deltaV);