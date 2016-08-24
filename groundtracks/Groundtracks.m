clear all;
close all;
clc;

%% Simulation configuration
% orbital parameters

apogee_km = 540;
perigee_km = 540;
inclination_deg = 97.62;

omega = 0;
argp = 200;
nu = 0;
arglat = 0;
truelon = 0;
lonper = 0;

tstep_s = 120;
sim_length_s = 97*60*5;

%% Internal configs and auxiliary data
% Load earth coast to use as basemap
load coast
[x,y,z] = sphere(100);

% Load astronomical constants
addpath('SGP4');
constastro

% Orbital calculations
semimajor_axis_km = ((re+apogee_km) + (re+perigee_km))/2;
a = semimajor_axis_km;
e = ((re+apogee_km) - (re+perigee_km)) / ((re+apogee_km) + (re+perigee_km));
p = a*(1-e^2);

%% Propagation

t = 0:tstep_s:sim_length_s;

r = zeros(3,length(t));
v = zeros(3,length(t));
acc = zeros(3,length(t));

[r(:,1), v(:,1)] = coe2rv(p, e, deg2rad(inclination_deg), deg2rad(omega), deg2rad(argp),  deg2rad(nu), deg2rad(arglat), deg2rad(truelon), deg2rad(lonper));

for i=2:length(t)
  
    [r(:,i), v(:,i)] = kepler(r(:,i-1), v(:,i-1), tstep_s);   
    acc(:,i) = v(:,i) - v(:,i-1);
    %[p, a, ecc, incl, omega, argp, nu, m, arglat, truelon, lonper ] = rv2coe (r(:,i), v(:,i));
        
end

jd = juliandate(today + t/(24*60*60));
[r_ecef, v_ecef, a_ecef] = ECItoECEF(jd, r, v, a);


%% Solid earth plot
v = VideoWriter('solid_earth.avi');
open(v);
frame = struct('cdata',[],'colormap',[]);

close all
figure
hold on;
surf(x*re, y*re, z*re, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');
plot3(r(1,:), r(2,:), r(3,:));
grid on;
axis equal;
view([-20,25]);

hnd = [];
for i=1:length(r(1,:))
    delete(hnd);
    hnd = plot3(r(1,i), r(2,i), r(3,i),'.r','MarkerSize', 20);
    drawnow
    frame(i) = getframe(gcf);    
end
writeVideo(v, frame);
close(v);

%% Real earth plot in ECI coordinates

v = VideoWriter('eci_earth.avi');
open(v);
frame = struct('cdata',[],'colormap',[]);

close all
figure
hold on;
surf(x*re, y*re, z*re, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');

% Orbit
plot3(r(1,:), r(2,:), r(3,:));


axis('equal');
grid on
view([-20,25]);

hnd = [];
hnd_earth = [];
t = 0;
for i=1:length(r(1,:))
    
    t = t  + tstep_s;
    p = lla2ecef([lat, long + 360/(24*60*60)*t,zeros(1,length(lat))'])/1000;

    delete(hnd);    
    delete(hnd_earth);
    
    hnd = plot3(r(1,i), r(2,i), r(3,i),'.r','MarkerSize', 20);
    hnd_earth = plot3(p(:,1), p(:,2), p(:,3),'-k');
    
    drawnow
    frame(i) = getframe(gcf);    
    
end

writeVideo(v, frame);
close(v);

%% Real earth plot in ECEF coordinates
v = VideoWriter('ecef_earth.avi');
open(v);
frame = struct('cdata',[],'colormap',[]);

close all

figure
hold on;
surf(x*re, y*re, z*re, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');

p = lla2ecef([lat, long,zeros(1,length(lat))'])/1000;
hnd_earth = plot3(p(:,1), p(:,2), p(:,3),'-k');

% Orbit
plot3(r_ecef(1,:), r_ecef(2,:), r_ecef(3,:));

axis('equal');
grid on
view([-20,25]);

hnd = [];


for i=1:length(r(1,:))        
    delete(hnd);        
    hnd = plot3(r_ecef(1,i), r_ecef(2,i), r_ecef(3,i),'.r','MarkerSize', 20);    
    drawnow
    frame(i) = getframe(gcf);    
end

writeVideo(v, frame);
close(v);

%% 2D Groundtrack multile orbit plot
map_width = 0.6;
map_height = 0.6;

h1 = figure('units','normalized','position',[0 map_height/2  map_width map_height]);

axesm('MapProjection','eqdcylin','Grid','On','LabelUnits', 'degrees','AngleUnits', 'degrees', 'Frame','on');
plotm(lat,long,'k');    %plot land from coast file
axis tight

lla = ecef2lla(r_ecef'*1000);
%lla = eci2lla(r'*1000,datevec(today + t/(24*60*60)));

plotm((lla(:,1)),(lla(:,2)),'r');    %plot land from coast file
saveas(gcf,'multiple_groundtrack.png');
%% 2D Groundtracks single orbit plot
map_width = 0.6;
map_height = 0.6;

h1 = figure('units','normalized','position',[0 map_height/2  map_width map_height]);

axesm('MapProjection','eqdcylin','Grid','On','LabelUnits', 'degrees','AngleUnits', 'degrees', 'Frame','on');
plotm(lat,long,'k');    %plot land from coast file
axis tight

%lla = eci2lla(r'*1000,datevec(today + t/(24*60*60)));

lla = ecef2lla(r_ecef'*1000);
lla = lla(1:97*(60/tstep_s),:);

plotm((lla(:,1)),(lla(:,2)),'r');    %plot land from coast file
saveas(gcf,'single_groundtrack.png');
