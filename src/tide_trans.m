% Transform the tide format of standard to the useful format in this
% program.

clear all;
clc
format long

% First loop directories
dir_nm=strcat('C:\Users\yangleir\Documents\jianguoyun\Documents\projects\NSFC\青年基金\TG\tg_data\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
namelist = ls(fullfile(dir_nm,'*.QLY.d'));% QLY
% temp=size(namelist);

delete C:\Users\yangleir\Documents\jianguoyun\Documents\projects\NSFC\青年基金\TG\QLY.d2
file2 = fopen('C:\Users\yangleir\Documents\jianguoyun\Documents\projects\NSFC\青年基金\TG\QLY.d2','a');

for i=1:length(namelist)
    
    year=2000+str2double(namelist(i,5:6));% year
    month=str2double(namelist(i,7:8));% month
    
    filepath=strcat(dir_nm,namelist(i,:))
    
    fid=fopen(filepath);    
    n=fgetl(fid);
    row=str2double(string(n));
    
    clear ssh t_save
    ssh(1:row,1:12) = NaN;
    t_save(1:row,1:12) = NaN;
    
    j = 1;
    while ~feof(fid)
        tline = fgetl(fid);
        
        % It is a bit complex to transform the format for QLY, because of
        % the existance of `-`.
        DDHH=str2num(tline(3:6));
        for mi=1:12
            t_save(j,mi)=year*1e8+month*1e6+DDHH*1e2+(mi-1)*5;       
            ssh(j,mi)=str2double(tline(8+(mi-1)*5:10+(mi-1)*5));
            sym=tline(7+(mi-1)*5);
            if  contains(sym,'-') % The tide is negative
                disp(tline);
                ssh(j,mi)=-ssh(j,mi);
            end
            
        end

        j = j+1;
    end
    
    fclose(fid); 
    
    t_save2=reshape(t_save',row*12,1);
    ssh2=reshape(ssh',row*12,1);
  
    % save to my format
    for k=1:row*12
        if ssh2(k)<800
            fprintf(file2,'%12d %5d\n',t_save2(k),ssh2(k)); 
        end
    end
    
end

fclose(file2);
load C:\Users\yangleir\Documents\jianguoyun\Documents\projects\NSFC\青年基金\TG\QLY.d2
plot(ZMW(:,2))