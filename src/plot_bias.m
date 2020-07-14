% Plot the bias and do statistic
function plot_bias(bias2,sat)
    figure (5)
    plot(bias2(:,1),bias2(:,2)*100,'-+')
	if sat==1
		xlabel('Jason-2 cycles')
		elseif sat==2
		xlabel('Saral cycles')
        elseif sat==3
		xlabel('HY-2 cycles')
		elseif sat==5
		xlabel('S3A cycles')
        elseif sat==4
		xlabel('Jason-3 cycles')
	end
    
	
    ylabel('bias/cm')
    bias_mean=mean (bias2(:,2)*100)
    bias_std=std(bias2(:,2)*100)
return