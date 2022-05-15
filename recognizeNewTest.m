clearvars
clc
close all
load net3sec4classes.mat
nbrOfSpeakers = 0;
imdsTest = imageDatastore("C:\Users\hebam\Desktop\Examensarbete\AMI-corpus\10_klasser\mix", "LabelSource","foldernames", IncludeSubfolders=true);
maxscrs = zeros(100,1);
truelabels = {''}
predictions ={''};
i = 1;
classNames = unique(imdsTrain.Labels) 
classNames = string(classNames)  
isFound = zeros(11,1); 
cwtNums = ones(11,1);  
nbrOfNewIms = 0; %Man ska spara ett antal bilder från den nya talaren innan man tränar om nätverket.
j=91; %Index för nästa nya talare. Den första nya talarklassen börjar på 91 eftersom den sista kända klassen är 90.
firstSeen = false; %Om det är första gången som man ser en bild från den nya talaren sätter man den till true.

%%
while imdsTest.hasdata
    [im , info] = imdsTest.read();
    pred = predict(net, im)
    truelabels(i,:) = cellstr(info.Label)
    maxscrs(i,:) = max(pred);
%     if max(pred) == 1
%         idx = find(pred==1)
%         class = classNames(idx)
%         predictions(i,:) = cellstr(class);
%         
%     else
%         predictions(i,:) = cellstr(info.Label)
% 
%     end
  idx = find(max(pred))
        class = classNames(idx)
        predictions(i,:) = cellstr(class);
        personid = 0;
k=0;
 speaker= string(class);

    personid=speaker;

    choice = menu('Are you speaker'+ speaker,'YES','NO');
    if choice==2
        idxfornames=length(classNames);


        options=[classNames;'newspeaker'];

        choice = menu('Who is speaking?',options);
        if choice==(idxfornames+1)
            dlgtitle='Input'
            answer = inputdlg('Enter the name', dlgtitle);
            classNames(end+1,1)= answer;
            personid=answer;
        else
            personid=string(classNames(choice));
            pause(0.2)
        end
    end
    k=k+1;
    truelabels(k,:) = cellstr(personid)


i = i+1;
end


%%
predictions = string(predictions)
truelabels = string(truelabels)
accuracy = sum(predictions == truelabels)/numel(predictions)
confusionchart(truelabels, predictions)


%%

function [net] = retrainCNN(net, layers, imds, numofclasses)
countEachLabel(imds)
rng(0)
[imdstrain,imdsValidation] = splitEachLabel(imds,30, "randomized")
%imdsValidation = splitEachLabel(imdsValidation, 10, "randomized")

layers(5) = fullyConnectedLayer(numofclasses)
options = trainingOptions('sgdm', ...
    'MaxEpochs',8, ...
    'Verbose',false, ...
    'MiniBatchSize',4, ...
    'InitialLearnRate',0.0001 , ...
    'ValidationPatience',10)
tic
net = trainNetwork(imdstrain,layers,options)
% 
% 
% ypred = net.classify(imdsValidation);
% confusionchart(imdsValidation.Labels, ypred)
% 
% accuracy = mean(ypred == imdsValidation.Labels)
toc
end
