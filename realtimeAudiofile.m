clearvars
clc
close all
load classifier.mat


audioIn = audioread("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\IS1009a-3filter.wav");
VAD = voiceActivityDetector;
fileReader = dsp.AudioFileReader("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\IS1009a-3filter.wav");
fileWriter = dsp.AudioFileWriter('recorded_audio\IS1009a-3filter_realtime.wav','FileFormat','WAV', 'SampleRate', 16000)
fs = fileReader.SampleRate
fileReader.SamplesPerFrame = ceil(10e-3*fs);
i = 1;
imindex = 1;
oneSecond = zeros(160,1);
StepSize = 500;
PathTo = "C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\1sec\ISO1009a-3\"
correctLabels = {''};
classes = classes(1:55)
for i = 1: numel(classes)
    correctLabels(:,i) = {'speaker1'};
end
correctLabels = correctLabels';
correctLabels = categorical(correctLabels)
predictions = correctLabels;

%%

while ~isDone(fileReader) 
    audioIn = fileReader();
    oneSecond(i:i+159,:) = audioIn; %Ändra så att den sparar hela audioIn, ökar index, osv. upp till en sekund, sen sound. en sekund är 16000Hz
    i = i +160;
    if (i >= 16000)

%         sound(oneSecond, fs)
%         pause(1)
        [cfs,frq] = cwt(oneSecond,fs,'ExtendSignal',true);
        tms = (0:numel(oneSecond)-1)/fs;
        surface(tms(:,1:StepSize:end),frq,abs(cfs(:,1:StepSize:end)));
        saveas(gcf,strcat(PathTo,'\cwt_',int2str(i),'.jpg'))

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

         prediction = predict(classifier, J)

%         if prediction == 1
%             predictions(imindex,:) = {'speaker1'};
%         else 
%             predictions(imindex,:) = {'speaker2'};
%         end

        
        oneSecond = zeros(160,1);
        i = 1;
        imindex = imindex +1


    end


    %     probability = VAD(audioIn);
    %     if probability >0.95
    %         %disp('it is over 95%')
    %         fileWriter(audioIn);
    %     end


end
sound(oneSecond, fs)
release(fileReader)
release(fileWriter)


%%
preds = classes(1:49);
index = 1;

imdsTest = imageDatastore("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\IS1009features\IS1009a-3filter");
while imdsTest.hasdata

    prediction = predict(classifier, J)


end
