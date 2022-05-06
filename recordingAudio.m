% ---------------- Preprocessing -----------------------------
% ---------------- 1. fitering 
%------------------2. image generation 
%------------------3. resizing 

close all
clearvars
fs=16000;

PathTo= 'C:\Users\hebam\Desktop\Examensarbete\AMI-corpus\3s signal\Test';
VAD = voiceActivityDetector;
deviceReader = audioDeviceReader(44100,256);
setup(deviceReader)
fileWriter = dsp.AudioFileWriter('22.wav','FileFormat','WAV');
VAD = voiceActivityDetector;
imindex = 1;
samplesPerFrame=256;
oneSecond = zeros(samplesPerFrame,1);
StepSize = 100;
disp('Speak into microphone now.')
tic
i=1;
totoverrun=0;
while toc < 10
    [acquiredAudio, numoverrun] = deviceReader();
    
    probability = VAD(acquiredAudio);
    if probability >0.95
    fileWriter(acquiredAudio);
    oneSecond(i:i+samplesPerFrame - 1,:) = acquiredAudio;
    totoverrun=totoverrun+numoverrun;
    end
    i = i +samplesPerFrame - 1;
    
    if (i >= 44100)
       tic
     [cfs,frq] = cwt(oneSecond,fs);
        tms = (0:numel(oneSecond)-1)/fs;
        surface(tms(:,1:StepSize:end),frq,abs(cfs(:,1:StepSize:end)));

        set(gca, 'Visible', 'off')
        colorbar('off');
        InSet = get(gca, 'TightInset');
        set(gca, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)]);
        axis tight
        shading flat
        set(gca,'yscale','log')
       saveas(gcf,strcat(PathTo,'\cwt_',int2str(imindex),'.jpg'))

        %Resize the image to make the process faster
       I = imread(strcat(PathTo,'\cwt_',int2str(imindex),'.jpg'));
        J = imresize(I, 0.5);
       imwrite(J,strcat(PathTo,'\cwt_',int2str(imindex),'.jpg'));
        close all
        imindex= imindex+1;

        oneSecond = zeros(samplesPerFrame,1);
        i = 1;
        clear I 
        clear J
        totoverrun
        toc
  
    end
end
disp('Recording complete.')
release(deviceReader)
release(fileWriter)

