clear all;
close all;
clc;

% Load astronomical constants
addpath('../vallado');
run('constastro.m');

%%
% Initial condition (uncomment one or create a new one)

% Only vertical speed launch
%r0 = [0, re+1000, 0];
%v0 = [0,8,0];

% Newton's cannon (increase the initial velocity to see the diference)
%r0 = [0, re+4000, 0];
%v0 = [3,0,0];

% Perfect Circular orbit
r0 = [0, re+500, 0];
v0 = [sqrt(mu/(re+500)),0,0];

% Inclined elliptical orbit
%r0 = [0, re+1000, 0];
%v0 = [4,0,8];

%%
% Simulation config
tstep_s = 100;
sim_length_s = 97*60*10;

%% Auxiliary variables initialization
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
        % The orbit intersected the earth, so terminate propagation
        break        
     end
end


%% Plot

close all
width = 0.5; height = 0.6;
f = figure('units','normalized','position',[0.5 - width/2, 0.5 - height/2, width, height]);

sat_hnd = [];

hold on;
surf(x*re, y*re, z*re, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');
plot3(r(1,:), r(2,:), r(3,:));
grid on;
axis equal;
view([-20,25]);

btn = uicontrol('Style', 'pushbutton','units','normalized',...
        'Position', [0.01 0.01 0.1 0.1],...
        'String', 'Restart',...
        'Callback', 'stop=1; i=1;delete(sat_hnd); sat_hnd = plot3(r(1,i), r(2,i), r(3,i),''.r'',''MarkerSize'', 20);'...
        ); 

btn = uicontrol('Style', 'pushbutton','units','normalized',...
        'Position', [0.12 0.01 0.1 0.1],...
        'String', 'Play',...
        'Callback', 'stop=0; for i=1:length(r(1,:)); if stop == 1; break; end; delete(sat_hnd); sat_hnd = plot3(r(1,i), r(2,i), r(3,i),''.r'',''MarkerSize'', 20); drawnow; pause(0.0001); title(sprintf(''%f seconds'',t(i))); end'...        
        ); 
