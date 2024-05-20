function [lon360]=Lon360(lon)

lon360=lon;
lon360(lon<0)=lon360(lon<0)+360;
