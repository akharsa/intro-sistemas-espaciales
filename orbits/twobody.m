clear all;
close all;
clc;

% Load astronomical constants
addpath('../vallado');
run('constastro.m');

%%

% Initial condition
r0 = [0, re+1000, 0];
v0 = [2,0,9];

% Simulation config
tstep_s = 100;
sim_length_s = 97*60*10;

%% Variables initialization
[x,y,z] = sphere(100);
t = 0:tstep_s:sim_length_s;
r = zeros(3,length(t));
v = zeros(3,length(t));
r(:,1) = r0;
v(:,1) = v0;

%% Propagation
for i=2:length(t)  
    % Propagate
    [r(:,i), v(:,i)] = kepler(r(:,i-1), v(:,i-1), tstep_s);           
    
    % Check for earth intersection
    if norm(r(:,i)) < re 
        r = r(:,1:i);
        v = v(:,1:i);
        break
     end
end


%% Plot
figure
hold on;
surf(x*re, y*re, z*re, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');
plot3(r(1,:), r(2,:), r(3,:));
grid on;
axis equal;
view([-20,25]);

hnd = [];
while true
    for i=1:length(r(1,:))
        delete(hnd);
        hnd = plot3(r(1,i), r(2,i), r(3,i),'.r','MarkerSize', 20);
        drawnow
        pause(0.0001);
        title(sprintf('%f seconds',t(i)));        
    end
end
