close all
clearvars
fs=16000;

PathTo= 'C:\Users\jenny\OneDrive\Pictures\temp';
samplesPerFrame=256;
deviceReader = audioDeviceReader(44100,samplesPerFrame);
setup(deviceReader)
fileWriter = dsp.AudioFileWriter('2022-05-06.wav','FileFormat','WAV');
VAD = voiceActivityDetector;
imindex = 1;

oneSecond = zeros(44100,1);
StepSize = 1000;
disp('Speak into microphone now.')
tic
i=1;
totaloverrun=0;
while toc < 60
    [acquiredAudio, numoverrun] = deviceReader();
    totaloverrun = totaloverrun + numoverrun;

    probability = VAD(acquiredAudio);
%     if probability >0.5
        fileWriter(acquiredAudio);
        %
        oneSecond(i:i+samplesPerFrame - 1,:) = acquiredAudio;
        i = i +samplesPerFrame;
%     end
    %
    %
    if (i >= 5*44100)
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
              I = imread(strcat(PathTo,'\cwt_',int2str(imindex),'.jpg'));
               J = imresize(I, 0.5);
              imwrite(J,strcat(PathTo,'\cwt_',int2str(imindex),'.jpg'));
                close all
                imindex= imindex+1;
        %
        oneSecond = zeros(44100,1);
        i = 1;
                clear I
                clear J
                totaloverrun


    end

end
disp('Recording complete.')
release(deviceReader)
release(fileWriter)
