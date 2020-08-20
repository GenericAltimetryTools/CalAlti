% crossover

% First step: read data from nc files. Here take the HY-2B l2p from aviso
% for example.
% define input parameters
dir_0='D:\aviso_hy2_c2_l2p\version_02_00';
min_cir=68; % 
max_cir=68; % 
min_lat=-80*1E6; % Unit
max_lat=80*1E6;

read_hy2a_l2p(min_cir,max_cir,min_lat,max_lat,dir_0); % You may need the read_nc__contents.m first.

% Second step: call GMT to plot the ssh data and have a qucik look.
oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path
