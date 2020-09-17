% 计算固定纬度的辐射计大气湿延迟差值、时间差值
% interpolation of  the wet delay to the fixed point.
function [bias_std,bias2,sig_g,dis]=wet_inter(min_cir,max_cir,pass_num,sat,loc,lat_compare,lon_gps,lat_gps,dry,h_gnss,myfit,gnss_wet,z_delta)

% ------------------------------------------------------------------------
% `dis` is distance from GNSS site to the comparison point. It is
% calculated by GMT.
% `sig_g` is the uncertainty of GNSS wet output from GAMIT. I do not use it.
% Instead I use 5mm as the uncertainty for the GNSS wet. Here  `sig_g` is a
% value for precision of inner coincidence.
% ------------------------------------------------------------------------
%     lat3=lat_compare;

    temp11=check_circle(pass_num);% 调用函数，判断circle的位数。
    temp21=num2str(temp11);
    
    if sat==3
        temp31=temp21(2:5);% 组成三位数的字符串。
    else
        temp31=temp21(3:5);% 组成三位数的字符串。
    end
    
% loop the `lat3`, save the STD of bias to matrix.
% Here the loop is set to 1. Means no loop.
% loop is not a good method to get the best validation location. I use the slope method instead. 
    tmp=length(lat_compare); % here `tmp=1`.
    sig_bias_r_g=[];
    mea_bias_r_g=[];
    dis_bias_r_g=[];
    
% loop the comparison location lat_compare. This is to check the land
% comtamination where apprears.
    for ii=1:tmp
        lat3=lat_compare(ii);
        
        if sat==1
            fid4=fopen('..\test\ja2_check\pca_wet.txt','w');
            fid5=fopen('..\test\ja2_check\pca_wet_model.txt','w');
            fid6=fopen('..\test\ja2_check\pca_ztd.txt','w');
            temp='..\test\ja2_check\';
        elseif sat==4
            fid4=fopen('..\test\ja3_check\pca_wet.txt','w');
            fid5=fopen('..\test\ja3_check\pca_wet_model.txt','w');
            fid6=fopen('..\test\ja3_check\pca_ztd.txt','w');
            temp='..\test\ja3_check\';
        elseif sat==3
            fid4=fopen('..\test\hy2_check\pca_wet.txt','w');
            fid5=fopen('..\test\hy2_check\pca_wet_model.txt','w');
            fid6=fopen('..\test\hy2_check\pca_ztd.txt','w');
            temp='..\test\hy2_check\';
        end  
        
        % get the wet PD of radiometer at the comparison point by `pchip` interpolation
        for i=min_cir:max_cir
    %         i;
                temp1=check_circle(i);% 调用函数，判断circle的位数。
                temp2=num2str(temp1);
                if sat==3
                    temp3=temp2(2:5);% 组成三位数的字符串。
                else
                    temp3=temp2(3:5);% 组成三位数的字符串。
                end
                tmp=strcat('_',temp31);
                temp4= strcat(temp,temp3,tmp,'.txt');
                temp5= strcat('X',temp3,tmp);

            if exist(temp4,'file')

                load (temp4) %读入SSH文件
                temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
                aa=size(temp6);

                if aa(1)>10 % 表示有效点数大于20个，占总数的一半。这个值可以更具总数多少修改。
                    pca_wet=interp1(temp6(:,2),temp6(:,3),lat3,'nearest');
                    % Add geoid height coorection
                    pca_wet_height=pca_wet*exp(-h_gnss/2000);% Here the h_gnss is the diff between GNSS and geoid.
                    pca_wet=pca_wet_height;
                    pca_wet_model=interp1(temp6(:,2),temp6(:,4),lat3,'pchip');
                    pca_dry=interp1(temp6(:,2),temp6(:,6),lat_gps,'pchip');
                    pressure_gdr=pca_dry*(1-0.00266*cosd(2*lat_gps))/2.277; %m_dry=-2.277*pre/(1-0.0026*cosd(2*36)-(0.28*1e-6)*h); % Here negelact the Height effect. unit mm
                    [pressure_gdr]=dry_height(pressure_gdr,h_gnss);% pressure correction due to height
                    pca_dry_corrected=pressure_gdr*2.277/(1-0.00266*cosd(2*lat_gps)-0.28*(1e-6)*h_gnss);
                    pca_ztd=pca_wet+pca_dry_corrected;% This the ZTD. Toal PD.
                    lon3=interp1(temp6(:,2),temp6(:,1),lat3,'pchip');
                    tim_pca=interp1(temp6(:,2),temp6(:,5),lat3,'pchip');
    %                 tmp=datestr(tim_pca/86400+datenum('2000-01-1 00:00:00'))%
    %                 trasform the seconds to normal data format
                    fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_wet,i);% save wet_R pd at PCA
                    fprintf(fid5,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_wet_model,i);%  save wet_model pd at PCA
                    fprintf(fid6,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ztd,i);%  save wet_model pd at PCA

                end

            end

        end 
        
        % Compare and get the orignal bais between GNSS and radiometer. May contain abnormal values
        [bias2,sig_g]=wet_cal_G_S(sat,dry,gnss_wet,z_delta,loc);
        % three sigma0 editting to remove the abnormal values. Save data to
        % file. Also give the trend estimation for both radiometer and
        % model.
        
        input=[lon_gps lat_gps];
        order=strcat('mapproject -G',num2str(lon3),'/',num2str(lat3),'+i+uk -fg');
        dis = gmt (order,input);
        % 
        Q=['finish interp at latitude:', num2str(lat3),'; distance to GNSS site:',num2str(dis.data(3))];
        disp(Q);
        fclose('all');
        dis_bias_r_g(ii)=dis.data(3);

        [bias_std,bias_mean]=wet_filter_save(bias2,sat,min_cir,max_cir,dis_bias_r_g(ii),loc);
        sig_bias_r_g(ii)=bias_std;
        mea_bias_r_g(ii)=bias_mean;    
        
        %  Analysis the spatial inluence
        dis_0=dis.data(3);% This is the distance from the first CAL point to GNSS location. One point.
        
        spa=myfit.a - myfit.b*exp(-dis_0/myfit.c);
        disp(['The spatial rms is estimated to be:',num2str(spa)])
        
        [sig_r]=sigma_r(bias_std,sig_g,spa);   
    end
    
    % test 
    figure (234)
    plot(dis_bias_r_g,sig_bias_r_g);hold on
    plot(dis_bias_r_g,mea_bias_r_g);hold off
    output_dis=[dis_bias_r_g' mea_bias_r_g' sig_bias_r_g'];
    
    % output the mean and STD as a function of the distance
    if sat==1
        save ..\test\ja2_check\jason_2_bias_wet_dis_function.txt output_dis -ASCII % 保存结果数据
    elseif sat==4
        save ..\test\ja3_check\jason_3_bias_wet_dis_function.txt output_dis -ASCII % 保存结果数据
    elseif sat==3
        save ..\test\hy2_check\hy2_bias_dis_function.txt output_dis -ASCII % 保存结果数据
    end
    
return