% The main program to calibrate the wet PD
clear; %
clc; % 
format long

dir_0='C:\Users\yangleir\Documents\aviso\Jason2\';% data directory 
oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

% choose the satellite ID and GNSS sites
sat=3; % sat could be 1,Jason2; 4,Jason3;   3,HY-2B
loc = 'gdst';% choose from sdyt,fjpt,hist,yong for Jason. 
% And sdyt,sdrc,sdrc2,sdqd,fjpt,hisy,hisy2,yong, for HY-2B
% Please first run the `yong`, because it will be set as a reference to
% calculate the `sig_s` (spatial influence).

% call sub program
if sat==1
    dir_0='C:\Users\yangleir\Documents\aviso\Jason2\';% data directory 
    ja2_wet(sat,loc,dir_0)
elseif sat==4
    dir_0='C:\Users\yangleir\Documents\aviso\Jason3\';% data directory 
    ja3_wet(sat,loc,dir_0)
elseif sat==3
    dir_0='C:\Users\yangleir\Downloads\hy2b\IDR_2M\';% data directory 
    hy2b_wet(sat,loc,dir_0)
end