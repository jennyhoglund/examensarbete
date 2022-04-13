

% ---------------- Preprocessing -----------------------------
% ---------------- 1. fitering 
%------------------2. image generation 
%------------------3. resizing 

close all
clearvars

[audioIn] = audioread("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\TS3011a\audio\TS3011a-2_filtered.wav");
fileReader = dsp.AudioFileReader("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\TS3011a\audio\TS3011a-2_filtered.wav");
fs = fileReader.SampleRate
fileReader.SamplesPerFrame = ceil(10e-3*fs);
VAD = voiceActivityDetector;
% scope = timescope( ...
%     'NumInputPorts',2, ...
%     'SampleRate',fs, ...
%     'TimeSpanSource','Property','TimeSpan',3, ...
%     'BufferLength',3*fs, ...
%     'YLimits',[-1.5 1.5], ...
%     'TimeSpanOverrunAction','Scroll', ...
%     'ShowLegend',true, ...
%     'ChannelNames',{'Audio','Probability of speech presence'});
%deviceWriter = audioDeviceWriter('SampleRate',fs);
fileWriter = dsp.AudioFileWriter("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\TS3011a\audio\TS3011a-2_VAD.wav",'FileFormat','WAV', 'SampleRate', 16000)


%%
i = 1;
while ~isDone(fileReader) || i <100
    audioIn = fileReader();
    probability = VAD(audioIn);
    if probability >0.95
        
        fileWriter(audioIn);
    end
 %   scope(audioIn,probability*ones(fileReader.SamplesPerFrame,1))
  %  deviceWriter(audioIn);
  i = i+1;
end
release(fileReader)
release(fileWriter)
whos audioIn

%%

deviceReader = audioDeviceReader();
setup(deviceReader)
fileWriter = dsp.AudioFileWriter('2022-04-12.wav','FileFormat','WAV');
VAD = voiceActivityDetector;
disp('Speak into microphone now.')
tic

while toc < 10
    acquiredAudio = deviceReader();
    probability = VAD(acquiredAudio);
    if probability >0.95
    fileWriter(acquiredAudio);
    end
    
end
disp('Recording complete.')
release(deviceReader)
release(fileWriter)
whos acquiredAudio


