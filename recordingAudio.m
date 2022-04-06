clc
clearvars 
clc
clearvars


recObj = audiorecorder(16000, 8, 1)

disp('Start speaking.')
recordblocking(recObj, 60);
disp('End of Recording.');
play(recObj);
y = getaudiodata(recObj);['' ...
    ]

%sample rate är 8000Hz

%%
fs = 16000;
y = y(:,1);

l = length(y);
y = y(y > 0.0005 | y < - 0.0005);
% audiowrite(strcat(Path,FileName2write,'.wav'),signal,fs)
len = length(y);
TotalTime = len./fs;
dt=1/fs;
%time1 = 0:dt:(len*dt)-dt;
time = 0:dt:TotalTime-dt;
%sound(y, fs)

%%
SampleSec = 5; %every 2 second
StartSampleSec =1;  %start time
StepSize = 1000;
SampleNums = SampleSec*fs;
StartSampleNum = StartSampleSec*fs;
maxi = floor(len/StartSampleNum);
plot(y)
%%
audiowrite(strcat('C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\ourrecordings\recording1','.wav'),y,fs)

%%

i = 1;
close all;

StartPoint =16000;
PathTo = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\ourrecordings\';
FileName = '2022-04-05'
if len >= SampleNums
    for i=1:maxi-1
        StartPoint =(i-1)*StartSampleNum+1;
        mtlb = y(StartPoint:StartPoint+SampleNums);
        [cfs,frq] = cwt(mtlb,fs,'ExtendSignal',true);
        tms = (0:numel(mtlb)-1)/fs;
        surface(tms(:,1:StepSize:end),frq,abs(cfs(:,1:StepSize:end)));
        saveas(gcf,strcat(PathTo,FileName,'\cwt_',int2str(i),'.jpg'))

        set(gca, 'Visible', 'off')
        colorbar('off');

        InSet = get(gca, 'TightInset');
        set(gca, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)]);

        axis tight
        shading flat
        %xlabel('Time (s)')
        %ylabel('Frequency (Hz)')
        set(gca,'yscale','log')
        im = frame2im(getframe(gcf));
        im = imresize(im, 0.5);
        shading flat
        

        imwrite(im,strcat(PathTo,FileName, '\cwt_',int2str(i),'.jpg'));


        %saveas(gcf,strcat(PathTo,FileName,'\cwt_',int2str(i),'.jpg'))

        %Resize the image to make the process faster
        % I = imread(strcat(PathTo,FileName,'\cwt_',int2str(i),'.jpg'));
        %J = imresize(I, 0.5);
        %imwrite(J,strcat(PathTo,FileName, '\cwt_',int2str(i),'.jpg'));
        %
    end
else
    disp('no sound')
end



%%
