clc
clearvars
t= readtable('C:\Users\hebam\Desktop\Examensarbete\Code_MATLAB/ES2015a.A.xls');
[y,fs]= audioread('C:\Users\hebam\Desktop\Examensarbete\AMI-corpus/ES2015a.Mix-Lapel.wav');
fs
lastend=1;
onesec= zeros(floor(fs*(sum(t.xEnd(1:end))-sum(t.start(1:end)))),1);
totaltime = 0;
for i=1:height(t)
    
 start=floor(fs*t.start(i))

 endd=floor( fs*t.xEnd(i));
 x = y(start:endd-1);
 a = endd-start;

 totaltime = totaltime+a/fs
 length(x)
% length(onesec(lastend:lastend+a-1))
 onesec(lastend:lastend+a-1)=x;
 lastend=lastend+ a+1;

end

 audiowrite('ES2015a.wav',onesec,fs)
