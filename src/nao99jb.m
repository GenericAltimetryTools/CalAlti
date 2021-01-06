% call NAO99jb Fortran

%% 
function [tide_nao]=nao99jb(lat_t,lon_t,sec)

disp('===========================NAO99jb computing===========================')
cd ../tide

%% 读取文件并修改
fileID = fopen('naotestj.f','r+');                    %以可读写的方式打开待修改的文件
i=0;

formatOut = 'yyyy/mm/dd HH:MM:SS';
t=datestr(sec/86400+datenum('2000-1-1 00:00:00'),formatOut);
disp(t);
year=t(1:4);
m=t(6:7);
d=t(9:10);
h=t(12:13);
m=t(15:16);

x=strcat('      x       = ',num2str(lon_t),'     ! East longitude in degree');
y=strcat('      y       = ',num2str(lat_t),'     ! North latitude in degree');
iyear1=strcat('      iyear1  = ',year,' ! year');
imon1=strcat('      imon1  = ',m,' ! month');
iday1=strcat('      iday1  = ',d,' ! iday1');
ihour1=strcat('      ihour1  = ',h,' ! ihour1');
imin1=strcat('      imin1  = ',m,' ! imin1');

iyear2=strcat('      iyear2  = ',year,' ! year');
imon2=strcat('      imon2  = ',m,' ! month');
iday2=strcat('      iday2  = ',d,' ! iday1');
ihour2=strcat('      ihour2  = ',h,' ! ihour1');
imin2=strcat('      imin2  = ',m,' ! imin1');


while ~feof(fileID)
        tline=fgetl(fileID);                              %逐行读取原始文件
        i=i+1;
        newline{i} = tline;                               %创建新对象接受原始文件每行数据
        if i==27                                        %判断是否到达待修改的行
            newline{i} = strrep(tline,tline,x);%替换函数，将待修改的行全部替换为新内容
        end
        if i==28                                        %判断是否到达待修改的行
            newline{i} = strrep(tline,tline,y);%替换函数，将待修改的行全部替换为新内容
        end

        if i==31                                        %判断是否到达待修改的行
            newline{i} = strrep(tline,tline,iyear1);%替换函数，将待修改的行全部替换为新内容
        end
        if i==32                                        %判断是否到达待修改的行
            newline{i} = strrep(tline,tline,imon1);%替换函数，将待修改的行全部替换为新内容
        end
        if i==33                                        %判断是否到达待修改的行
            newline{i} = strrep(tline,tline,iday1);%替换函数，将待修改的行全部替换为新内容
        end
        if i==34                                        %判断是否到达待修改的行
            newline{i} = strrep(tline,tline,ihour1);%替换函数，将待修改的行全部替换为新内容
        end
        if i==35                                        %判断是否到达待修改的行
            newline{i} = strrep(tline,tline,imin1);%替换函数，将待修改的行全部替换为新内容
        end        

        if i==38                                        %判断是否到达待修改的行
            newline{i} = strrep(tline,tline,iyear2);%替换函数，将待修改的行全部替换为新内容
        end
        if i==39                                        %判断是否到达待修改的行
            newline{i} = strrep(tline,tline,imon2);%替换函数，将待修改的行全部替换为新内容
        end
        if i==40                                        %判断是否到达待修改的行
            newline{i} = strrep(tline,tline,iday2);%替换函数，将待修改的行全部替换为新内容
        end
        if i==41                                        %判断是否到达待修改的行
            newline{i} = strrep(tline,tline,ihour2);%替换函数，将待修改的行全部替换为新内容
        end
        if i==42                                        %判断是否到达待修改的行
            newline{i} = strrep(tline,tline,imin2);%替换函数，将待修改的行全部替换为新内容
        end         
end
fclose(fileID);                                       %关闭文件
    
%% 输出文本
    fileID = fopen('nao.f','w+');                    %以可读写的方式打开输出文件，文件若存在则清空文件内容从文件头部开始写，若不存在则根据文件名创建新文件并只写打开
    for k=1:i
        fprintf(fileID,'%s\t\n',newline{k});              %将newline内的内容逐行写出
    end
    fclose(fileID);                                       %关闭文件
    
%% run fortran
cmd1 = 'gfortran nao.f -o nao';
cmd2 = '.\nao.exe';
[status1, cmdout1] = system(cmd1);
[status2, cmdout2] = system(cmd2);
%%
fileID = fopen('naotestj.out','r');                    %以可读写的方式打开待修改的文件

while ~feof(fileID)
        tline=fgetl(fileID);                              %逐行读取原始文件
end

fclose(fileID);                                       %关闭文件
tide_nao=str2double(tline(15:23));
cd ../src
return
