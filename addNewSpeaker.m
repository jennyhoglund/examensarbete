% Hämta bild, encoda bild, jämför den vektorn med alla vektorer i array.
clc
M = zeros(1,500); %% Matris för unika speakers
classes = {''}
A = zeros(1,500); %%Matris med alla talarvektorer
clearvars
load bag.mat



%%

path = '';
i = 1;
n = 0; %% antal unika talare
v = 0; %% antal vektorer
imds = imageDatastore("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\ourrecordings", ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
[im, info] = read(imds);

imshow(im)




%%
while imds.hasdata

    [im, info] = read(imds);
    info.Label
    fv1 = encode(bag, im);
    minDist = 0;

    if n == 0
        n = 1;
        M(1,:) = fv1;
        v = v+1;
        classes(v,:) = {'speaker1'};
        A(v,:) = fv1;

    else
        minDist = 2;
        for i = 1:n
            fv2 = M(i,:);
            dist = pdist([fv1 ; fv2])
            if dist < minDist
                minDist = dist;
            end
            x = "";
            if  dist < 0.3 && dist >0.2

                name = strcat('speaker ', int2str(i))
                prompt = strcat("Are you ", name, '?');
                x = input(prompt, "s")
                minDist = -1;
            elseif (x == "yes") || (dist <=0.2)
                M(i,:) = fv1;
                minDist = -1;
                name = strcat('speaker ', int2str(i))

                v = v+1;
                A(v,:) = fv1;
                classes(v,:) = {name};
            end

        end
    end
    if minDist >= 0.45

        prompt = ("Are you a new speaker?");
        x =input(prompt, "s")
        if x == "yes"
            n = n + 1;
            M(n,:) = fv1;
            v = v+1;
            name = strcat('speaker ', int2str(n))
            A(n,:) = fv1;
            classes(v,:) = {name};
        end

    elseif minDist ~= -1
        %user feedback: vem är du?
        prompt = ("Write which number of speaker you are");
        x = input(prompt, "s");

    end
end



whos M
whos classes
%%
classes = categorical(classes);

numObservations = size(classes,1)
numObservationsTrain = floor(0.7*numObservations)
numObservationsValidation = floor(0.15*numObservations)
numObservationsTest = numObservations - numObservationsTrain - numObservationsValidation

idx = randperm(numObservations);
idxTrain = idx(1:numObservationsTrain);
idxValidation = idx(numObservationsTrain+1:numObservationsTrain+numObservationsValidation);
idxTest = idx(numObservationsTrain+numObservationsValidation+1:end);

tblTrain = A(idxTrain,:);
tblValidation = A(idxValidation,:);
tblTest = A(idxTest,:);

layers = [
    featureInputLayer(500)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

tic
options = trainingOptions('adam');
net = trainNetwork(A, classes, layers, options);
toc
%%


