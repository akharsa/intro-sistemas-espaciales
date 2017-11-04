clear all;
close all;
clc;

% Load astronomical constants
addpath('../vallado');
run('constastro.m');

%% Initial orbit
rinitial = re + 300;

%% Final orbit
rfinal = re + 36000;

%% Transfer orbit
atrans = (rinitial + rfinal)/2;

%% Calculation
Vinitial = sqrt(mu/rinitial);
Vfinal = sqrt(mu/rfinal);
Vtrans_a = sqrt(2*mu/rinitial - mu/atrans);
Vtrans_b = sqrt(2*mu/rfinal - mu/atrans);

deltaV_a = Vtrans_a - Vinitial;
deltaV_b = Vfinal - Vtrans_b;

fprintf('---------------------------------------------\n');
fprintf('Initial orbit velocity: %f km/s\n',Vinitial);
fprintf('Transfer orbit velocity at a: %f km/s\n',Vtrans_a);
fprintf('Delta V requiered: %f km/s\n', deltaV_a);
fprintf('---------------------------------------------\n');
fprintf('Orbit velocity at apogee of transfer orbit: %f km/s\n',Vtrans_b);
fprintf('Final orbit velocity: %f km/s\n',Vfinal);
fprintf('Delta V requiered: %f km/s\n', deltaV_b);
fprintf('---------------------------------------------\n');
fprintf('Total Delta V requiered: %f km/s\n', abs(deltaV_a) + abs(deltaV_b));
fprintf('Total time of the transfer orbit: %f hours\n', (2*pi*sqrt(atrans^3/mu)/2)/60/60);
