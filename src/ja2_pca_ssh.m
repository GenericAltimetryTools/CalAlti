% calculate the PCA point, SSH at PCA and save to file.

function ja2_pca_ssh(min_cir,max_cir,pass_num,lat_gps,lon_gps,loc)

    fid4=fopen('..\test\ja2_check\pca_ssh.txt','w');
    temp='..\test\ja2_check\';
    load  ..\test\ja2_check\ponits_number.txt
    cir_number=ponits_number(:,2);
    len1=max(cir_number);
%     len2=min(cir_number);
    len_mean=mean(cir_number)/2; % You can change this value according to your need.
    
    for i=min_cir:max_cir
        tmp=['cycle: ',num2str(i)];
        disp(tmp)
%         i
            temp1=check_circle(i);% 
            temp2=num2str(temp1);
            temp3=temp2(3:5);% 
            tmp=strcat('_',num2str(pass_num));
            temp4= strcat(temp,temp3,tmp,'.dat');
%             temp5= strcat('X',temp3,tmp);
            
        if exist(temp4,'file')
%             
%             load (temp4) % load SSH
%             temp6=eval(temp5);% 
            temp6=load (temp4);            
            aa=size(temp6);
            
            if aa(1)>len_mean % This is valid points number for one track.
                if strcmp(loc,'zmw')
%                     [lat3,lon3,tim_pca]=pca(temp4,lat_gps,lon_gps); % PCA
                    lat3=39.8333; % %39.8666(15km)39.8333(21km)39.9166(10km) This value is related to data quaity and can be adjusted.
                    pca_ssh=interp1(temp6(:,2),temp6(:,4),lat3,'PCHIP');
                    tim_pca=interp1(temp6(:,2),temp6(:,3),lat3,'liner');
                    lon3=interp1(temp6(:,2),temp6(:,1),lat3,'liner');
                    if isnan(tim_pca)==0
                        fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ssh,i);
                    end
                else 
                    [lat3,lon3,tim_pca]=pca(temp4,lat_gps,lon_gps); % cal pca
                    pca_ssh=interp1(temp6(:,2),temp6(:,4),lat3,'PCHIP');
                    fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ssh,i);

                end
                
            end
            
        end
        
    end 
%     workdir;
%     cd .\qianliyan_tg_cal
%     !grad
%     workdir;
disp('Finish!')
fclose('all');
    
return