

% ---------------- Preprocessing -----------------------------
% ---------------- 1. fitering 
%------------------2. image generation 
%------------------3. resizing 

close all
clearvars

% sample data information
SampleSec = 5; %every 5 second
StartSampleSec = 5;  %start time
StepSize = 1000; 
%Path = 'C:\IoTaP-CoSIS-DISS\Projects\Database\ES2002\';  %dataset path
Path = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\testaudio\'
PathTo = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\testimages\'
FileName = 'IS1009a-N'
PathTo = strcat(PathTo, FileName);
[signal,fs] = audioread(strcat(Path,FileName,'.wav'));


whos signal
whos fs


%filtering
%%

% 
% l = length(signal);
%  signal = signal(signal > 0.0005 | signal < - 0.0005);
%  audiowrite(strcat(Path,FileName2write,'.wav'),signal,fs)

len = length(signal);
TotalTime = len./fs;
dt=1/fs;
%time1 = 0:dt:(len*dt)-dt;
time = 0:dt:TotalTime-dt;

%plot(psd(spectrum.periodogram,signal,'Fs',fs,'NFFT',length(signal)));
% 
%  plot(time, signal); xlabel('Seconds'); ylabel('Amplitude');
%%
SampleNums = SampleSec*fs;
StartSampleNum = StartSampleSec*fs;

maxi = floor(len/StartSampleNum);
%Magnitude Scalogram


maxi
imgIndex = 1;

% generate Continuous Wavelet Transform (CWT)
for i=1:maxi - 1
  StartPoint =(i-1)*StartSampleNum+1;

    mtlb = signal(StartPoint:StartPoint+SampleNums - 1);
    whos mtlb
    fs
    [cfs,frq] = cwt(mtlb,fs);
    tms = (0:numel(mtlb)-1)/fs;
    surface(tms(:,1:StepSize:end),frq,abs(cfs(:,1:StepSize:end)));
    

    set(gca, 'Visible', 'off')
    set(gca,'yscale','log')
    colorbar('off');

    InSet = get(gca, 'TightInset');
    set(gca, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)]);

    axis tight
    shading flat
    %xlabel('Time (s)')
    %ylabel('Frequency (Hz)')
    

    saveas(gcf,strcat(PathTo,'\cwt_',int2str(i),'.jpg'))

    %Resize the image to make the process faster
    I = imread(strcat(PathTo,'\cwt_',int2str(i),'.jpg'));
    J = imresize(I, 0.5);
    imwrite(J,strcat(PathTo,'\cwt_',int2str(i),'.jpg'));

    i
    maxi
%     length(cfs)
%     length(frq)

    clear InSet;
    clear mtlb;
    clear cfs;
    clear I;
    clear J;
    close all
end

%%

%%
    
% figure
% subplot(2,1,1)  
% plot(tms,mtlb)
% axis tight
% title('Signal and Scalogram')
% xlabel('Time (s)')
% ylabel('Amplitude')
% subplot(2,1,2)
% surface(tms,frq,abs(cfs))
% axis tight
% shading flat
% xlabel('Time (s)')
% ylabel('Frequency (Hz)')
% set(gca,'yscale','log')



