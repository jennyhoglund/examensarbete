clearvars
clc
close all
load classifierTvåklasser.mat
load Amatrix0.5sec.mat
audioIn = audioread("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\0.5sec\testaudio\mix.wav");
fileReader = dsp.AudioFileReader("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\0.5sec\testaudio\mix.wav");
fs = fileReader.SampleRate
samplesPerFrame = 800;
fileReader.SamplesPerFrame = samplesPerFrame ;
oneSecond = zeros(samplesPerFrame,1);

i = 1;
imindex = 1;
StepSize = 100;
PathTo = "C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\0.5sec\testimages\";
predictions ={''};
x = length(audioIn)/fs;
x = floor(2*x);

maxscrs = zeros(x,1);
mdl = fitcecoc(A, classes); %testa först med offline learning med ecoc.
CVmdl = crossval(mdl)
genError = kfoldLoss(CVmdl)
mdlinc = incrementalLearner(mdl)
% MdlEarly = incrementalClassificationECOC(MaxNumClasses=5); %Gå sen över
% till onlline learning med ecoc.


%%

while ~isDone(fileReader)

    audioIn = fileReader();
    oneSecond(i:i+samplesPerFrame - 1,:) = audioIn;
    i = i +samplesPerFrame - 1;
    if (i >= fs*0.5)
        sound(oneSecond, fs)
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
        I = imread(strcat(PathTo,'\cwt_',int2str(imindex),'.jpg'));
        J = imresize(I, 0.5);

        fv1 = encode(bag, J); % Utvinn vektor
        [predictedlabel,NegLoss,PBScore] = predict(mdl, fv1) % Gör prediction med ecoc modell.
        predictions(imindex,:) = predictedlabel;


        imwrite(J,strcat(PathTo,'\cwt_',int2str(imindex),'.jpg'));
        close all
        imindex = imindex +1

        oneSecond = zeros(samplesPerFrame,1);
        i = 1;
    end


end

release(fileReader)


