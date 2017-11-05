function [ fraction ] = eclipse_fraction( rearth, h, beta )
%ECLIPSE_FRACTION Summary of this function goes here
%   Detailed explanation goes here
    fraction =  acos(sqrt(h*h+2*rearth*h)/((rearth+h)*cos(beta)))/pi;
end

