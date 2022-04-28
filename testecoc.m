clearvars
clc
close all
load Amatrix3sec.mat
%load net3sec.mat


% audioIn = audioread("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\0.5sec\0.5secnormaliserade\testaudio\mix.wav");
fileReader = dsp.AudioFileReader("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\0.5sec\0.5secnormaliserade\testaudio\mix.wav");
%imdsvalidation = imageDatastore("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\3sec\unknown\ES2016c-0", "IncludeSubfolders",true, "LabelSource","foldernames")
fs = fileReader.SampleRate
samplesPerFrame = 800;
fileReader.SamplesPerFrame = samplesPerFrame ;
oneSecond = zeros(samplesPerFrame,1);
im1 =imread("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\3sec\classes\EN2009c-0\cwt_29.jpg");
im2 = imread("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\3sec\classes\TS3012b-2\cwt_29.jpg");
vector1 = encode(bag,im1);
vector2 = encode(bag, im2);




i = 1;
imindex = 1;
StepSize = 100;
PathTo = "C:\Users\jenny\OneDrive\Pictures\temp\";
predictions ={''};
% x = length(audioIn)/fs;
% x = floor(2*x);
classes1 = {'speaker 1'; 'speaker 2'  }
%classes = [classes ; classes1];
A1 = [vector1; vector2];
%A = [A ; A1];
mdl = fitcecoc(A, classes); %testa först med offline learning med ecoc.
CVmdl = crossval(mdl)
genError = kfoldLoss(CVmdl)
MdlEarly = incrementalLearner(mdl);
classes = string(classes);
nbrOfSpeakers = 0;

imdsTest = imageDatastore("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\3sec\unknown", "LabelSource","foldernames", IncludeSubfolders=true);

%%

%while ~isDone(fileReader)
while imdsTest.hasdata
    %     audioIn = fileReader();
    %     oneSecond(i:i+samplesPerFrame - 1,:) = audioIn;
    %     i = i +samplesPerFrame - 1;
    %     if (i >= fs*0.5)
    % %         sound(oneSecond, fs)
    %         [cfs,frq] = cwt(oneSecond,fs);
    %         tms = (0:numel(oneSecond)-1)/fs;
    %         surface(tms(:,1:StepSize:end),frq,abs(cfs(:,1:StepSize:end)));
    %
    %         set(gca, 'Visible', 'off')
    %         colorbar('off');
    %         InSet = get(gca, 'TightInset');
    %         set(gca, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)]);
    %         axis tight
    %         shading flat
    %         xlabel('Time (s)')
    %         ylabel('Frequency (Hz)')
    %         set(gca,'yscale','log')
    %         saveas(gcf,strcat(PathTo,'\cwt_',int2str(imindex),'.jpg'))
    %         I = imread(strcat(PathTo,'\cwt_',int2str(imindex),'.jpg'));
    %         J = imresize(I, 0.5);

    %         fv1 = encode(bag, J); % Utvinn vektor
    %         [predictedlabel,NegLoss,PBScore] = predict(MdlEarly, fv1) % Gör prediction med ecoc modell.
    %
    % updateMetricsAndFit(MdlEarly, double(fv1), predictedlabel);

    %         imwrite(J,strcat(PathTo,'\cwt_',int2str(imindex),'.jpg'));
    %         close all
    %         imindex = imindex +1
    %
    %         oneSecond = zeros(samplesPerFrame,1);
    [J, info] = imdsTest.read;
    info.Label
    fv1 = encode(bag, J);
    [ecocpredictedlabel,NegLoss] = predict(MdlEarly, fv1)% Gör prediction med ecoc modell.

    if (max(NegLoss) > -0.2)
        predictions(i,:) = ecocpredictedlabel;

            prompt = "Which number of speaker are you?";
             id = input(prompt)
    %    MdlEarly = updateMetricsAndFit(MdlEarly, (fv1), ecocpredictedlabel )
        MdlEarly = updateMetricsAndFit(MdlEarly, double(fv1), cellstr(strcat("speaker ", int2str(id))) )
    else
        nbrOfSpeakers = nbrOfSpeakers + 1

        MdlEarly = updateMetricsAndFit(MdlEarly, double(fv1), cellstr(strcat("speaker ", int2str(nbrOfSpeakers))) )
        predictions(i,:) = cellstr(strcat("speaker ", int2str(nbrOfSpeakers)));
        disp("new speaker")

    end

    i = 1+i;
    %i = 1;

    %   end


end

release(fileReader)
