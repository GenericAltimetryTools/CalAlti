% The data quality is judged by the number of the valid points. The PCA
% loction is calculated. The SSH at the PCA points are calcalated. The PCA
% SSH are wrote out.
function s3a_pca_ssh(min_cir,max_cir,pass_num,lat_gps,lon_gps,loc)

% lat_gps=36.2667;% Location of QLY
% lon_gps=121.3850;
fid4=fopen('..\test\s3a_check\pca_ssh.txt','w');
    temp='..\test\s3a_check\';
    for i=min_cir:max_cir

            temp1=check_circle(i);% 调用函数，判断circle的位数。
            temp2=num2str(temp1);
            temp3=temp2(3:5);% 组成三位数的字符串。
            tmp=strcat('_',num2str(pass_num));
            temp4= strcat(temp,temp3,tmp,'.dat');
            temp5= strcat('X',temp3,tmp);
            
        if exist(temp4,'file')
            
            load (temp4) %读入SSH文件
            temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
            aa=size(temp6);
            % 下面aa(1)表示有效的观测点个数，如果少于6个则表示数据质量较差。注意要修改对应的saral1.txt文件，点的个数要保持一致，都则维数对不上。
            if aa(1)>5 % 表示有效点数大于5个，占总数的一半。这个值可以更具总数多少修改。40HZ设置为10
                if strcmp(loc,'zmw') 
                    lat3=39.903; % 这个数值和Jason-2的数据质量有关系，可以适当的调整。
                    pca_ssh=interp1(temp6(:,2),temp6(:,4),lat3,'PCHIP');
                    tim_pca=interp1(temp6(:,2),temp6(:,3),lat3,'liner');
                    lon3=interp1(temp6(:,2),temp6(:,1),lat3,'liner');
                    fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ssh,i);% 保存
                else
                    [lat3,lon3,tim_pca]=pca(temp4,lat_gps,lon_gps); % 调用函数，计算PCA
                    pca_ssh=interp1(temp6(:,2),temp6(:,4),lat3,'PCHIP');
                    fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ssh,i);% 保存
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