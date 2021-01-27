%%  The main program to calibrate the wet PD
% Usage:
% -1. Add GMT path
% -2. Choose satellite ID:  1=Jason2; 4=Jason3; 3=HY-2B
% -3. Choose GNSS Site
% -4. Choose Dry PD source: 1=GDR;2=GNSS;3=ERA5;
% -5. Call sub function to calculate wet PD bias.

% Author:leiyang@fio.org.cn
% Crete in 2020-6
% Edit Date: 2021-1-27

%%
clear; 
clc; 
format long

oldpath = path; % Add GMT path. The GMT is available from https://github.com/GenericMappingTools/gmt
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

% choose the satellite ID and GNSS sites
sat=1; % sat could be 1,Jason2; 4,Jason3;   3,HY-2B
% Please first run the `yong`, because it will be set as a reference to
% calculate the `sig_s` (spatial influence).
loc = 'hisy';
% choose from sdyt,fjpt,hisy,yong,gdzh,lnhl,zjwz,gdst,jsly,zmw,qly£¬twtf for Jason.
% And sdyt,sdrc,sdrc2,sdqd,fjpt,hisy,hisy2,yong,yong2,bzmw,bzmw2,bqly,lndd,kmnm,lnjz,lnjz2,twtf,twtf2, hkws for HY-2B

% select the dry PD source. The difference may be very small
dry=1; % 1=GDR;2=GNSS;3=ERA5;

% call sub program
if sat==1 % Jason-2
    dir_0='C:\Users\yangleir\Documents\aviso\Jason2\';% data directory 
    ja2_wet(sat,loc,dir_0,dry)
elseif sat==4 % Jason-3
    dir_0='C:\Users\yangleir\Documents\aviso\Jason3\';% data directory 
    ja3_wet(sat,loc,dir_0,dry)
elseif sat==3 % HY-2B
    dir_0='D:\hy2b\GDR_2P\';% data directory D:\hy2b\IDR_2M
    hy2b_wet(sat,loc,dir_0,dry)
end
