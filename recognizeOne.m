clearvars
clc
close all
load net3sec4classes.mat

f(imdsTrain, net)

function f(imdsTrain, net)
imdsTest = imageDatastore("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\3sec\mix", "LabelSource","foldernames", IncludeSubfolders=true);
maxscrs = zeros(100,1);
truelabels = {''}
predictions ={''};
i = 1;
classNames = unique(imdsTrain.Labels)
classNames = string(classNames)
cwtNums = ones(11,1);
nbrOfNewIms = 0;
name = "";

while imdsTest.hasdata
    pause(1)

    [im , info] = imdsTest.read();
    info.Label
    pred = predict(net, im)
    truelabels(i,:) = cellstr(info.Label);
    maxscrs(i,:) = max(pred);
    if max(pred) ==1
        idx = find(pred==1);
        class = classNames(idx);
        predictions(i,:) = cellstr(class);
        
    else
        predictions(i,:) = cellstr(name);
    end
    if nbrOfNewIms < 20
        disp("pred < 1")
        cwtNum = cwtNums(length(classNames) + 1 );
        cwtNums(length(classNames) + 1 ) = cwtNum + 1;
        nbrOfNewIms = nbrOfNewIms + 1;
        imwrite(im, strcat("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\3sec\classes\train\new speaker", "\cwt_", int2str(cwtNum), ".jpg" ));
    else
        disp("retrain")
        nbrOfNewIms = 0;
        imds = imageDatastore("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\3sec\classes\train", "IncludeSubfolders",true,"LabelSource","foldernames")
        net = retrainCNN(net, layers, imds, 5);
        classNames = unique(imds.Labels); %
        classNames = string(classNames);  %

    end
i = i+1;
end

predictions = string(predictions)
truelabels = string(truelabels)
accuracy = sum(predictions == truelabels)/numel(predictions)
confusionchart(truelabels, predictions)
end

%%


%%

function [net] = retrainCNN(net, layers, imds, numofclasses)
countEachLabel(imds)
rng(0)
[imdstrain,imdsValidation] = splitEachLabel(imds,20, "randomized")
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


