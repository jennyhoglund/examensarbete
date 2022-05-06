clearvars
clc
close all
load Amat3sec11.mat

i = 1;
predictions ={''};
A = single(A);
mdl = fitcecoc(A, classes);
CVmdl = crossval(mdl)
genError = kfoldLoss(CVmdl)
incmdl = incrementalLearner(mdl);
nbrOfSpeakers = 0;
imdsTest = imageDatastore("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\3sec\test", "LabelSource","foldernames", IncludeSubfolders=true);
imdsTest = shuffle(imdsTest)
maxscrs = zeros(1,1);
truelabels = {''}


%%


while imdsTest.hasdata

    [J, info] = imdsTest.read;
    truelabels(i,:)= cellstr(info.Label);

    fv1 = encode(bag, J);
    info.Label
    incmdl.ClassNames'
    [ecocpredictedlabel,NegLoss] = predict(incmdl, fv1)% Gör prediction med ecoc modell.
    if (max(NegLoss) > -0.1)
        predictions(i,:) = ecocpredictedlabel;

    else
        nbrOfSpeakers = nbrOfSpeakers + 1
        predictions(i,:) = cellstr(info.Label);
        disp("new speaker")


    end
    maxscrs(i,:) = max(NegLoss);

    i = 1+i;

end



predictions = string(predictions)
truelabels = string(truelabels)
accuracy = sum(predictions == truelabels)/numel(predictions)
confusionchart(truelabels, predictions)
plot(maxscrs)

%%
imds = imageDatastore("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\1sec\classes", "IncludeSubfolders",true,"LabelSource","foldernames")
net = retrainCNN(net, layers, imds, 4);

function [table] = createTable(A, classes)


end




function [net] = retrainCNN(net, layers, imds, numofclasses)

rng(0)
[imdstrain,imdsValidation] = splitEachLabel(imds,40, "randomized")
imdsValidation = splitEachLabel(imdsValidation, 10, "randomized")

layers(5) = fullyConnectedLayer(numofclasses)
options = trainingOptions('sgdm', ...
    'MaxEpochs',8, ...
    'Verbose',false, ...
    'MiniBatchSize',4, ...
    'InitialLearnRate',0.0001 , ...
    'ValidationPatience',10)
tic
net = trainNetwork(imdstrain,layers,options)


ypred = net.classify(imdsValidation);
confusionchart(imdsValidation.Labels, ypred)

accuracy = mean(ypred == imdsValidation.Labels)
toc
end

