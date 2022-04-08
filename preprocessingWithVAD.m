

% ---------------- Preprocessing -----------------------------
% ---------------- 1. fitering 
%------------------2. image generation 
%------------------3. resizing 

close all
clearvars

[audioIn] = audioread("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\recorded_audio\2022-04-08.wav");
fileReader = dsp.AudioFileReader("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\recorded_audio\2022-04-08.wav");
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
fileWriter = dsp.AudioFileWriter('mySpeech.wav','FileFormat','WAV', 'SampleRate', 16000);
while ~isDone(fileReader)
    audioIn = fileReader();
    probability = VAD(audioIn);
    if probability >0.95
        %disp('it is over 95%')
        fileWriter(audioIn);
    end
 %   scope(audioIn,probability*ones(fileReader.SamplesPerFrame,1))
  %  deviceWriter(audioIn);
end
release(fileReader)
release(fileWriter)

%%

deviceReader = audioDeviceReader();
setup(deviceReader)
fileWriter = dsp.AudioFileWriter('mySpeech.wav','FileFormat','WAV');
VAD = voiceActivityDetector;
disp('Speak into microphone now.')
tic

while toc < 20
    acquiredAudio = deviceReader();
    probability = VAD(acquiredAudio);
    if probability >0.95
    fileWriter(acquiredAudio);
    end
    
end
disp('Recording complete.')
release(deviceReader)
release(fileWriter)




%%

