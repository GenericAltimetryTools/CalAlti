%���ת����WGS-84ת��T/P
%WGS-84: 
lat= 41.933333;%���꺣���γ��
a=6378137;
f=1/298.257223563;
b=6378137-6378137/298.257223563;
e=sqrt(a^2-b^2)/a;
w=sqrt(1-e^2*sin(lat));
%TP����
a2=6378136.3;
f2=1/298.257;
b2=a2-a2*f2;
e2=sqrt(a2^2-b2^2)/a2;
w2=sqrt(1-e2^2*sin(lat));
%����ת���̲߳���
d=(-w)*(a-a2)+a/w*(1-f)*(sin(lat))^2*(f-f2);