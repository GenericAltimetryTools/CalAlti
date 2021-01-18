% Plot the altimeter data and have a quick look of the data

function quicklook_alti(min_cir,max_cir,min_lat,max_lat,pass_num,sat)
%% ###############################################
disp('making figures-----waiting')
% draw figures for statistic 
    if sat==5
        disp('------Sa3----')
        load ..\test\s3a_check\ponits_circle.txt
        load  ..\test\s3a_check\ponits_number.txt
        fid4=fopen('..\test\s3a_check\statistic.txt','w');
        temp='..\test\s3a_check\';
    elseif sat==1
        disp('------Jason-2----')
        load ..\test\ja2_check\ponits_circle.txt
        load  ..\test\ja2_check\ponits_number.txt
        fid4=fopen('..\test\ja2_check\statistic.txt','w');
        temp='..\test\ja2_check\';
    elseif sat==4
        disp('------Jason-3----')
        load ..\test\ja3_check\ponits_circle.txt
        load  ..\test\ja3_check\ponits_number.txt
        fid4=fopen('..\test\ja3_check\statistic.txt','w');
        temp='..\test\ja3_check\';
    elseif sat==3
        disp('------HY-2B----')
        load ..\test\hy2_check\ponits_circle.txt
        load  ..\test\hy2_check\ponits_number.txt
        fid4=fopen('..\test\hy2_check\statistic.txt','w');
        temp='..\test\hy2_check\';    
    end
%%  Plot valid points
    latitude=ponits_circle(:,1);
    points=ponits_circle(:,2);
    cir_number=ponits_number(:,2);
    circle=ponits_number(:,1);

    figure('NumberTitle', 'off', 'Name', 'The valid points along track');
    hold on

    plot(latitude,points,'o');
    xlabel('latitude/\circ');
    ylabel('Cycle number');
    ylim([min(points) max(points)]);
    xlim([min_lat/1E6 max_lat/1E6]);

    % Add the number of valid points aong track to figure.
    for i=1:5:length(circle)
        text(min_lat/1E6-0.2,circle(i),num2str(cir_number(i)),'FontSize',10)
    end

    grid on
    hold off
    
%% *************************************************************************

    % Plot mean SSH for each cycle. And SSH along track for each cycle on
    % one figure.

    a(1:(max_cir-min_cir+1))=0;% save SSH
    len1=max(cir_number);
    len2=min(cir_number);
    len_mean=(mean(cir_number)+len1)/2; % You can change this value according to your need.

    figure('NumberTitle', 'off', 'Name', 'The SSH along track for each cycle');
    hold on
    
    for i=min_cir:max_cir
        temp1=check_circle(i);% call function to determine the proper name of files
        temp2=num2str(temp1);

        if sat==3
            temp3=temp2(2:5);% 
            tmp=strcat('_0',num2str(pass_num));
        else
            temp3=temp2(3:5);% 
            tmp=strcat('_',num2str(pass_num));
        end

        temp4= strcat(temp,temp3,tmp,'.dat');
%         temp5= strcat('X',temp3,tmp);
        
        if exist(temp4,'file')
            temp6=load (temp4);
%             temp6=eval(temp5);% This a variable define trick. 
%             len=length(temp6);
            
            if length(temp6)>len_mean
                latitude=temp6(:,2);
                ssh_=temp6(:,5);
                a(i-min_cir+1)=mean(ssh_);% mean SSH for the selected data along tracks.
                fprintf(fid4,'%12d %12.6f \n',i,a(i-min_cir+1));% save mean SSH
                plot(latitude,ssh_,'-o');
                xlabel('Latitude/\circ');
                ylabel('SSH/m') ;
            end
            
        end
        
    end 

    fclose(fid4);

    xlim([min_lat/1E6 max_lat/1E6])
    hold off


    figure('NumberTitle', 'off', 'Name', 'The  time series of mean SSH along selected areas');
    temp5= strcat(temp,'statistic.txt');
    load (temp5)
    [ssh,t]=three_sigma_delete(statistic(:,2),statistic(:,1));
    plot(t,ssh,'-o');
    xlabel('cycle bumber')
    ylabel('MSSH/mm')
    legend('Mean')
%%
% co-line processing



return