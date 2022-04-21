clc
close all

audioIn = audioread("C:\Users\hebam\Desktop\Examensarbete\Code_MATLAB\amicorpus\ES2016b\train\TS3012A0.wav");
filteredsignal= audioread("C:\Users\hebam\Desktop\Examensarbete\Code_MATLAB\amicorpus\ES2016b\train\TS3012A0.wav");
VAD = voiceActivityDetector
fileReader = dsp.AudioFileReader("C:\Users\hebam\Desktop\Examensarbete\Code_MATLAB\amicorpus\ES2016b\train\TS3012A0.wav");
fileWriter = dsp.AudioFileWriter('TS3012a-0filter_realtime.wav','FileFormat','WAV', 'SampleRate', 16000)
fs = fileReader.SampleRate
samplesPerFrame = 800
fileReader.SamplesPerFrame = samplesPerFrame ;
i = 1;
imindex = 1;
oneSecond = zeros(samplesPerFrame,1);
StepSize = 100;

PathTo = "C:\Users\hebam\Desktop\Examensarbete\Code_MATLAB\amicorpus\ES2016b\train\TS3012A0"
%predictions ={''};
% x = length(audioIn)/fs;
% x = 2*x;

%maxscrs = zeros(292,1);
% figure
% plot(audioIn)

%medelvärde
s=sum(abs(audioIn))/numel(audioIn);
m=mean(abs(audioIn));
%%
 figure
 t = (0:numel(audioIn) - 1)/fs;
 spikeSignal = zeros(size(audioIn));
 spks = 10:100:1990;
 spikeSignal(spks+round(2*randn(size(spks)))) = sign(randn(size(spks)));
 
 noisyLoopVoltage = audioIn + spikeSignal;
 figure 
 plot(t,audioIn) 
%%
 for i=1:numel(filteredsignal)-2
     if abs(filteredsignal(i)) > 0.5
         filteredsignal(i)=0 ;
     end
     if abs(filteredsignal(i))+0.02< abs(filteredsignal(i+1))
         filteredsignal(i+1)=(filteredsignal(i)+filteredsignal(i+1))/2 ;
     end
 
       if abs(filteredsignal(i+1))> (abs(filteredsignal(i+2))+0.02)
         filteredsignal(i+1)=(filteredsignal(i+1)+filteredsignal(i+2))/2 ;
       end
 end
 figure
 plot(audioIn,'b')
 hold on 
 plot(filteredsignal,'g')
 legend('Original','Filtered')
 xlabel('Time (s)')
 ylabel('Voltage (V)')
 title('Open-Loop Voltage with Added Spikes')
%%
while ~isDone(fileReader)

    audioIn = fileReader();
    oneSecond(i:i+samplesPerFrame - 1,:) = audioIn; %Ändra så att den sparar hela audioIn, ökar index, osv. upp till en sekund, sen sound. en sekund är 16000Hz
    i = i +samplesPerFrame - 1;
    if (i >= fs*0.5)
        %sound(oneSecond, fs)
        %     pause(0.5)
        [cfs,frq] = cwt(oneSecond,fs);
        tms = (0:numel(oneSecond)-1)/fs;
        surface(tms(:,1:StepSize:end),frq,abs(cfs(:,1:StepSize:end)));

        set(gca, 'Visible', 'off')
        colorbar('off');
        InSet = get(gca, 'TightInset');
        set(gca, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)]);
        axis tight
        shading flat
        xlabel('Time (s)')
        ylabel('Frequency (Hz)')
        set(gca,'yscale','log')
        saveas(gcf,strcat(PathTo,'\cwt_',int2str(imindex),'.jpg'))

        %Resize the image to make the process faster
        I = imread(strcat(PathTo,'\cwt_',int2str(imindex),'.jpg'));
        J = imresize(I, 0.5);
        imwrite(J,strcat(PathTo,'\cwt_',int2str(imindex),'.jpg'));
        close all
%         [labelIdx, score] = predict(classifier,J)
%         if max(score) < -0.1
%             predictions(imindex,:) = cellstr("newspeakr")
% 
%         else
%             predictions(imindex,:) = classifier.Labels(labelIdx);
%         end
%         maxscrs(imindex) = max(score);
         imindex = imindex +1
%         classifier.Labels(labelIdx)
% 
         oneSecond = zeros(samplesPerFrame,1);
         i = 1;
    end
end
release(fileReader)
%release(fileWriter)


