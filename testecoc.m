clearvars
clc
close all
load Amatrix3sec.mat

i = 1;
StepSize = 100;
predictions ={''};
A = single(A);
mdl = fitcecoc(A, classes);
CVmdl = crossval(mdl)
genError = kfoldLoss(CVmdl)
incmdl = incrementalLearner(mdl);
nbrOfSpeakers = 0;
imdsTest = imageDatastore("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\filtered\3sec\unknown", "LabelSource","foldernames", IncludeSubfolders=true);
imdsTest = shuffle(imdsTest)
maxscrs = zeros(1,1);
truelabels = {''}

while imdsTest.hasdata

    [J, info] = imdsTest.read;
    truelabels(i,:)= cellstr(info.Label);

    fv1 = encode(bag, J);
    info.Label
    [ecocpredictedlabel,NegLoss] = predict(incmdl, fv1)% Gör prediction med ecoc modell.
    if (max(NegLoss) > -0.4)
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
