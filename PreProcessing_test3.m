

% ---------------- Preprocessing -----------------------------
% ---------------- 1. fitering 
%------------------2. image generation 
%------------------3. resizing 

close all
clear all

% sample data information
SampleSec = 5; %every 5 second
StartSampleSec = 3;  %start time
StepSize = 1000; 
%Path = 'C:\IoTaP-CoSIS-DISS\Projects\Database\ES2002\';  %dataset path
Path = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\EN2001a_ind\audio\'
%FileName = 'EN2001b.Headset-0'; 
FileName = 'EN2001a.Headset-3'
FileName2write = strcat(FileName,'_filtered');
[signal,fs] = audioread(strcat(Path,FileName,'.wav'));
%sound(singal,fs)
whos signal
whos fs

%filtering
signal = signal(:,1);
l = length(signal);
signal = signal(signal > 0.0005 | signal < - 0.0005);
audiowrite(strcat(Path,FileName2write,'.wav'),signal,fs)
len = length(signal);
TotalTime = len./fs;
dt=1/fs;
%time1 = 0:dt:(len*dt)-dt;
time = 0:dt:TotalTime-dt;

%plot(psd(spectrum.periodogram,signal,'Fs',fs,'NFFT',length(signal)));

%figure;
%plot(time, signal); xlabel('Seconds'); ylabel('Amplitude');

SampleNums = SampleSec*fs;
StartSampleNum = StartSampleSec*fs;

maxi = floor(len/StartSampleNum);
%Magnitude Scalogram
figure;

% generate Continuous Wavelet Transform (CWT)
for i=1:maxi-1
    StartPoint =(i-1)*StartSampleNum+1;
    mtlb = signal(StartPoint:StartPoint+SampleNums);
    [cfs,frq] = cwt(mtlb,fs,'ExtendSignal',true);
    tms = (0:numel(mtlb)-1)/fs;
    surface(tms(:,1:StepSize:end),frq,abs(cfs(:,1:StepSize:end)));
        saveas(gcf,strcat(Path,FileName2write,'\cwt_',int2str(i),'.jpg'))

    set(gca, 'Visible', 'off')
    colorbar('off');
    
    InSet = get(gca, 'TightInset');
    set(gca, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)]);
    
    axis tight
    shading flat
    %xlabel('Time (s)')
    %ylabel('Frequency (Hz)')
    set(gca,'yscale','log')
    
    saveas(gcf,strcat(Path,FileName2write,'\cwt_',int2str(i),'.jpg'))
    
    %Resize the image to make the process faster
    I = imread(strcat(Path,FileName2write,'\cwt_',int2str(i),'.jpg'));
    J = imresize(I, 0.5);
    imwrite(J,strcat(Path,FileName2write,'\acwt_',int2str(i),'.jpg'));

    i
    maxi
%     length(cfs)
%     length(frq)
    
    clear InSet;
    clear mtlb;
    clear cfs;
    clear functions;
    clear I;
    clear J;
end

    
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



