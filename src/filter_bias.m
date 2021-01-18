% Filter data and save
function [bias]=filter_bias(sat,bias2,loc)

    tmpp=bias2(:,2); % unit m
    ttt=bias2(:,1);

    if strcmp(loc,'zhws') && sat==3
       Locate=find(tmpp>100); 
       tmpp(Locate)=[]; 
       ttt(Locate)=[];  
       Locate=find(tmpp<-1); 
       tmpp(Locate)=[]; 
       ttt(Locate)=[];  
    elseif strcmp(loc,'zhws') && sat==4
       Locate=find(tmpp>100); 
       tmpp(Locate)=[]; 
       ttt(Locate)=[];  
       Locate=find(tmpp*100<-50); 
       tmpp(Locate)=[]; 
       ttt(Locate)=[];  
    elseif strcmp(loc,'bqly') && sat==3
       Locate=find(tmpp*100>15); 
       tmpp(Locate)=[]; 
       ttt(Locate)=[];  
       Locate=find(tmpp*100<-50); 
       tmpp(Locate)=[]; 
       ttt(Locate)=[]; 
    elseif strcmp(loc,'bzmw2') && sat==3
       Locate=find(tmpp*100>50); 
       tmpp(Locate)=[]; 
       ttt(Locate)=[];  
       Locate=find(tmpp*100<-50); 
       tmpp(Locate)=[]; 
       ttt(Locate)=[];        
    end
    
    [tmpp,ttt]=three_sigma_delete(tmpp,ttt);
    [tmpp,ttt]=three_sigma_delete(tmpp,ttt);    
    [tmpp,ttt]=three_sigma_delete(tmpp,ttt);% Do this filter three times
    
    bias=[ttt tmpp];
    if sat==5
        save ..\test\s3a_check\s3a_bias.txt bias -ASCII % save file
    elseif sat==1
        save ..\test\ja2_check\ja2_bias.txt bias -ASCII % save file
    elseif sat==4
        save ..\test\ja3_check\ja3_bias.txt bias -ASCII % save file
    elseif sat==3
        save ..\test\hy2_check\hy2_bias.txt bias -ASCII % save file      
        
    end
return