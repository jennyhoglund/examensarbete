clearvars
clc
close all
load classifier.mat

audioIn = audioread("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\testaudio\mix.wav");
fileReader = dsp.AudioFileReader("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\testaudio\mix.wav");
%fileWriter = dsp.AudioFileWriter('recorded_audio\IS1009a-3filter_realtime.wav','FileFormat','WAV', 'SampleRate', 16000)
fs = fileReader.SampleRate
%fileReader.SamplesPerFrame = ceil(10e-3*fs);
samplesPerFrame = fs/10
fileReader.SamplesPerFrame = samplesPerFrame ;
i = 1;
imindex = 1;
oneSecond = zeros(samplesPerFrame,1);
StepSize = 1000;
PathTo = "C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\testimages\"
predictions ={''};

%%

while ~isDone(fileReader)
    
    audioIn = fileReader();
    oneSecond(i:i+samplesPerFrame - 1,:) = audioIn; %Ändra så att den sparar hela audioIn, ökar index, osv. upp till en sekund, sen sound. en sekund är 16000Hz
    i = i +samplesPerFrame - 1;
    if (i >= 5*fs)tic
% 
%         sound(oneSecond, fs)
%         pause(5)
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

        [labelIdx, score] = predict(classifier,J)
%         if max(score) < -0.1
%             predictions(imindex,:) = cellstr("newspeakr")
% 
%         else
%             predictions(imindex,:) = classifier.Labels(labelIdx)
%         end

        imindex = imindex +1 ;
        
        oneSecond = zeros(samplesPerFrame,1);
        i = 1;
        

toc
    end

end

release(fileReader)
%release(fileWriter)


%%
% predictions;
% eval = sum(predictions == classes)/numel(classes)
% wrong = predictions(predictions ~= classes)
