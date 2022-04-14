
close all
clearvars
pathSignal = "C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\";
filenameAudio = 'mix';
%pathImages =

audioIn = audioread(strcat(pathSignal, filenameAudio, '.wav'));
fs = 16000;
secondsPerImage = 0.25; %varje bild är 0.5 sekunder
startsample = 5*fs*secondsPerImage; %starta på fem sekunder
%stopsample = startsample+ (120*fs*secondsPerImage)
stopsample = length(audioIn)
audioIn = audioIn(startsample:stopsample);
amtofsamples = stopsample - startsample;



for i = 1:amtofsamples - 1
    startsample = (i-1)*fs*secondsPerImage + 1;
    y = audioIn(startsample: startsample+secondsPerImage*fs - 1);
    [cfs,frq] = cwt(y,fs);
    (i-1)*0.25

   
    tms = (0 :numel(y)-1)/fs;


    surface(tms,frq,abs(cfs))
    axis tight
    shading flat
%     xlabel('Time (s)')
%     ylabel('Frequency (Hz)')
    set(gca,'yscale','log')
    saveas(gcf,strcat(PathTo,'\cwt_',int2str(i),'.jpg'));
    I = imread(strcat(PathTo,'\cwt_',int2str(i),'.jpg'));
    J = imresize(I, 0.5);
    imwrite(J,strcat(PathTo,'\cwt_',int2str(i),'.jpg'));
    pause(2)
    close all;


end

%%
