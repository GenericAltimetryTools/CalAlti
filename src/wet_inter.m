% 计算固定纬度的辐射计大气湿延迟差值、时间差值
% interpolation of  the wet delay to the fixed point.
function wet_inter(min_cir,max_cir,pass_num,loc)
if   strcmp(loc,'cst')
    lat3=37.7;% 此处的纬度大概距离陆地20km，辐射计收到的陆地干扰较小，且距离站点近。
elseif  strcmp(loc,'sdyt')
    lat3=37.833333; % 25km far from the mainland
elseif  strcmp(loc,'fjpt')
    lat3=25.1; % 25km far from the mainland
elseif  strcmp(loc,'hisy')
    lat3=18; % 25km far from the mainland
end 

% date_yj=[2010 1 1 0 0 0];% 
% t3=((datenum(date_yj)-datenum('2000-01-1 00:00:00')))*86400;
fid4=fopen('..\test\ja2_check\pca_wet.txt','w');
fid5=fopen('..\test\ja2_check\pca_wet_model.txt','w');
    temp11=check_circle(pass_num);% 调用函数，判断circle的位数。
    temp21=num2str(temp11);
    temp31=temp21(3:5);% 组成三位数的字符串。
    for i=min_cir:max_cir
%         i;
            temp='..\test\ja2_check\';
            temp1=check_circle(i);% 调用函数，判断circle的位数。
            temp2=num2str(temp1);
            temp3=temp2(3:5);% 组成三位数的字符串。
            

            
            tmp=strcat('_',temp31);
            temp4= strcat(temp,temp3,tmp,'.txt')
            temp5= strcat('X',temp3,tmp);
            
        if exist(temp4,'file')
            
            load (temp4) %读入SSH文件
            temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
            aa=size(temp6);
            
            if aa(1)>20 % 表示有效点数大于20个，占总数的一半。这个值可以更具总数多少修改。
                pca_wet=interp1(temp6(:,2),temp6(:,3),lat3,'pchip');
                pca_wet_model=interp1(temp6(:,2),temp6(:,4),lat3,'pchip');
                lon3=interp1(temp6(:,2),temp6(:,1),lat3,'pchip');
                tim_pca=interp1(temp6(:,2),temp6(:,5),lat3,'pchip');
%                 tmp=datestr(tim_pca/86400+datenum('2000-01-1 00:00:00'))%
%                 trasform the seconds to normal data format
                fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_wet,i);% 保存
                fprintf(fid5,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_wet_model,i);% 保存
            end
            
        end
        
    end 
disp('Finish!')
fclose('all');
return