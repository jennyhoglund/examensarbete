

% ---------------- Preprocessing -----------------------------
% ---------------- 1. fitering 
%------------------2. image generation 
%------------------3. resizing 

close all
clearvars

% sample data information
SampleSec = 0.5; %every 5 second
StartSampleSec = 0.4;  %start time
StepSize = 1000; 
%Path = 'C:\IoTaP-CoSIS-DISS\Projects\Database\ES2002\';  %dataset path
Path = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\recorded_audio\'
PathTo = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\mixed\'
%FileName = 'EN2001b.Headset-0'; 
FileName = ['recording1']
FileName2write = 'recording1';
[signal,fs] = audioread(strcat(Path,FileName,'.wav'));
%sound(singal,fs)

whos signal
whos fs

%filtering
%%


% l = length(signal);
% signal = signal(signal > 0.0005 | signal < - 0.0005);
% audiowrite(strcat(Path,FileName2write,'.wav'),signal,fs)
len = length(signal);
TotalTime = len./fs;
dt=1/fs;
%time1 = 0:dt:(len*dt)-dt;
time = 0:dt:TotalTime-dt;

%plot(psd(spectrum.periodogram,signal,'Fs',fs,'NFFT',length(signal)));

% plot(time, signal); xlabel('Seconds'); ylabel('Amplitude');

SampleNums = SampleSec*fs;
StartSampleNum = StartSampleSec*fs;

maxi = floor(len/StartSampleNum)/10;
%Magnitude Scalogram

maxi
imgIndex = 1;

% generate Continuous Wavelet Transform (CWT)
for i=1:maxi-1
    StartPoint =(i-1)*StartSampleNum+1;
    mtlb = signal(StartPoint:StartPoint+SampleNums);
    [cfs,frq] = cwt(mtlb, fs);

     tms = (0:numel(mtlb)-1)/fs;
     surface(tms,frq,abs(cfs))
     axis tight
    shading flat
%     xlabel('Time (s)')
%     ylabel('Frequency (Hz)')
    set(gca,'yscale','log')
    set(gca, 'Visible', 'off')
    colorbar('off');    
    InSet = get(gca, 'TightInset');
     set(gca, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)]);


   
  saveas(gcf,strcat("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\ourrecordings\2022-04-08",'\cwt_',int2str(imgIndex),'.jpg'))


    I = imread(strcat("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\ourrecordings\2022-04-08",'\cwt_',int2str(imgIndex),'.jpg'));
    J = imresize(I, 0.5);
    imwrite(J,strcat(strcat("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\ourrecordings\2022-04-08",'\cwt_',int2str(imgIndex),'.jpg')));
    imgIndex = imgIndex+1;

    i
    maxi
    
%     clear InSet;
    clear mtlb;
    clear cfs;
%     clear I;
%     clear J;
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



