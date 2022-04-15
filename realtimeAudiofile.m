clearvars
clc
close all
load classifierTvåklasser.mat

audioIn = audioread("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\0.5sec\testaudio\mix.wav");
fileReader = dsp.AudioFileReader("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\0.5sec\testaudio\mix.wav");
%fileWriter = dsp.AudioFileWriter('recorded_audio\IS1009a-3filter_realtime.wav','FileFormat','WAV', 'SampleRate', 16000)
fs = fileReader.SampleRate
%fileReader.SamplesPerFrame = ceil(10e-3*fs);
samplesPerFrame = fs/10
fileReader.SamplesPerFrame = samplesPerFrame ;
i = 1;
imindex = 1;
oneSecond = zeros(samplesPerFrame,1);
StepSize = 100;
PathTo = "C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\0.5sec\testimages\"
predictions ={''};
x = length(audioIn)/fs;
x = 2*x;

maxscrs = zeros(292,1);



%%

while ~isDone(fileReader)

    audioIn = fileReader();
    oneSecond(i:i+samplesPerFrame - 1,:) = audioIn; %Ändra så att den sparar hela audioIn, ökar index, osv. upp till en sekund, sen sound. en sekund är 16000Hz
    i = i +samplesPerFrame - 1;
    if (i >= fs*0.5)
        sound(oneSecond, fs)
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

        [labelIdx, score] = predict(classifier,J)
        if max(score) < -0.1
            predictions(imindex,:) = cellstr("newspeakr")

        else
            predictions(imindex,:) = classifier.Labels(labelIdx);
        end
        maxscrs(imindex) = max(score);


        imindex = imindex +1
        classifier.Labels(labelIdx)

        oneSecond = zeros(samplesPerFrame,1);
        i = 1;
    end


end

release(fileReader)
%release(fileWriter)


%%

% Skapandet av korrekta labels: jag lyssnade på ljudklippen som spelades
% upp och antecknade vilket index det var när det blev en annan talare. De
% första 93 tillhörde en klass. 
% 
% audioIn = audioread("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\0.5sec\testaudio\mix.wav");
% dt = 1/16000;
% len = length(audioIn)
% totaltime = len./16000;
% time = 0 : dt: totaltime - dt;
% plot(time, audioIn)
% 
% 
% truelabels = {''};
% for i = 1 : 93
%     truelabels(i,:) = cellstr("EN2009c-1");
% end
% for i = 94:196
%     truelabels(i,:) = cellstr('ES2002c-3');
% end
% for i = 197:292
%     truelabels(i,:) = cellstr("newspeakr");
% end
