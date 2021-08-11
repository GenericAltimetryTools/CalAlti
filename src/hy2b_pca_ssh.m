% 分析数据质量；计算PCA位置；数据拟合出PCA点SSH；保存数据
% 输入文件名称
function hy2b_pca_ssh(min_cir,max_cir,pass_num,lat_gps,lon_gps,loc)

    fid4=fopen('..\test\hy2_check\pca_ssh.txt','w');
    temp='..\test\hy2_check\';
    load  ..\test\hy2_check\ponits_number.txt
    cir_number=ponits_number(:,2);
    len1=max(cir_number);
%     len2=min(cir_number);
    len_mean=mean(cir_number)/2; % You can change this value according to your need.
        
    for i=min_cir:max_cir
%         if i~=40 % cycle 40 is abnormal
           
            temp1=check_circle(i);% 
            temp2=num2str(temp1);
            temp3=temp2(2:5);% 
            tmp=strcat('_0',num2str(pass_num));
            temp4= strcat(temp,temp3,tmp,'.dat');
            temp5= strcat('X',temp3,tmp);
            
            if exist(temp4,'file')
                
                temp6=load (temp4);            
                aa=size(temp6);                

                if aa(1)>len_mean % 
                    if strcmp(loc,'zmw') ||  strcmp(loc,'bzmw') % Do not use the PCA because of the land contamination.
    %                     [lat3,lon3,tim_pca]=pca(temp4,lat_gps,lon_gps); % 调用函数，计算PCA
                        lat3=39.8666; %39.8666(15km)39.8333(20km) This value is related to data quaity and can be adjusted。
                        pca_ssh=interp1(temp6(:,2),temp6(:,4),lat3,'PCHIP');
                        tim_pca=interp1(temp6(:,2),temp6(:,3),lat3,'liner');
                        lon3=interp1(temp6(:,2),temp6(:,1),lat3,'liner');
                        if isnan(tim_pca)==0
                            fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ssh,i);% 保存
                        end
                    elseif  strcmp(loc,'zhws') % Do not use the PCA because of the land contamination.
                        lat3=21.8333; % 这个数值和Jason-2的数据质量有关系，可以适当的调整。
                        pca_ssh=interp1(temp6(:,2),temp6(:,4),lat3,'PCHIP');
                        tim_pca=interp1(temp6(:,2),temp6(:,3),lat3,'PCHIP');
                        lon3=interp1(temp6(:,2),temp6(:,1),lat3,'PCHIP');
                        if isnan(tim_pca)==0
                            fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ssh,i);% 保存
                        end                    
                    else  % bqly
                        [lat3,lon3,tim_pca]=pca(temp4,lat_gps,lon_gps); % 调用函数，计算PCA
                        pca_ssh=interp1(temp6(:,2),temp6(:,4),lat3,'PCHIP');
                        fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ssh,i);% 保存

                    end
                end

            end
%         end
    end 
%     workdir;
%     cd .\qianliyan_tg_cal
%     !grad
%     workdir;
disp('Finish!')
fclose('all');
return