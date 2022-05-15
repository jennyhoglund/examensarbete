clearvars
clc
close all
load tempnet.mat




nbrOfSpeakers = 0;
imdsTest = imageDatastore("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\lapelmixes\1sec\mix", "LabelSource","foldernames", IncludeSubfolders=true);
path= 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\lapelmixes\1sec\classes'
maxscrs = zeros(100,1);
truelabels = {''}
predictions ={''};
i = 1;
classNames = unique(imdsTrain.Labels) % 83 85 87 90
classNames = string(classNames)  % 83 85 87 90
isFound = zeros(11,1); % 83 85 87 90 91 92 93 94 95 96 97 98 99
cwtNums = ones(11,1);  % 83 85 87 90 91 92 93 94 95 96 97 98 99
nbrOfNewIms = 0; %Man ska spara ett antal bilder från den nya talaren innan man tränar om nätverket.
j=91; %Index för nästa nya talare. Den första nya talarklassen börjar på 91 eftersom den sista kända klassen är 90.
firstSeen = false; %Om det är första gången som man ser en bild från den nya talaren sätter man den till true.
counter = 0;
counteris1 = 0;
%%
while imdsTest.hasdata
    counter = counter +1
    [im , info] = imdsTest.read();
    pred = predict(net, im)
    if max(pred) == 1
        counteris1 = counteris1+1

        idx = find(pred==1)
        class = classNames(idx)
        if isFound(idx) == 0
            nbrOfSpeakers = nbrOfSpeakers+1;
            isFound(idx) = 1;
           
        end
    elseif nbrOfNewIms < 30
        cwtNum = cwtNums(length(classNames) + 1 );
        cwtNums(length(classNames) + 1 ) = cwtNum + 1;
        nbrOfNewIms = nbrOfNewIms + 1;

        if firstSeen == false
            s = strcat(path, "\z", int2str(j))
            mkdir(s)
            firstSeen = true;
            j=j+1
            nbrOfSpeakers = nbrOfSpeakers +1;
        end
        imwrite(im, strcat(s, "\cwt_", int2str(cwtNum), ".jpg" ));

    else
        nbrOfNewIms = 0;
        imds = imageDatastore("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\lapelmixes\1sec\classes", "IncludeSubfolders",true,"LabelSource","foldernames")
        net = retrainCNN(net, layers, imds, length(classNames) + 1);
        classNames = unique(imds.Labels) % 83 85 87 90 91
        classNames = string(classNames)  % 83 85 87 90 91
        firstSeen = false;


    end

end
nbrOfSpeakers
%%
predictions = string(predictions)
truelabels = string(truelabels)
accuracy = sum(predictions == truelabels)/numel(predictions)
confusionchart(truelabels, predictions)
plot(maxscrs)

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