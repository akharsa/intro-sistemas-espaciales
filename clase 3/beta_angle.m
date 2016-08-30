function [ beta ] = beta_angle( omega, inclination, sun_ra, sun_dec)
%BETA_ANGLE Summary of this function goes here
%   Detailed explanation goes here
    beta = asin(cos(sun_dec)*sin(inclination)*sin(omega-sun_ra) + sin(sun_dec)*cos(inclination));
end

