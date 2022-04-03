% Hämta bild, encoda bild, jämför den vektorn med alla vektorer i array.
clc
M = zeros(1,500); %% Matris för unika speakers
classes = {''}
classes(1,:) = {'speaker 1'}
A = zeros(1,500); %%Matris med alla talarvektorer




%%

path = '';
i = 1;
n = 0; %% antal unika talare
v = 0; %% antal vektorer
imds = imageDatastore("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\featureclasses", ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
[im, info] = read(imds);

imshow(im)
[imdsTrain, imdsTest] = splitEachLabel(imds, 0.8);



%%
while imdsTrain.hasdata

    [im, info] = read(imdsTrain);
    info.Label


    fv1 = encode(bag, im);
    
    
    if n == 0
        n = 1;
        M(1,:) = fv1;
        v = v+1;

        classes(v,:) = {'speaker 1'};
        A(v,:) = fv1;


    else
        minDist = 2;
        for i = 1:n
            fv2 = M(i,:);
            dist = pdist([fv1 ; fv2])
            if dist < minDist
                minDist = dist;
            end
            if dist < 0.3
                M(i,:) = fv1;
                minDist = -1;
                name = strcat('speaker ', int2str(i))
                v = v+1;
                A(v,:) = fv1;
                classes(v,:) = {name};



            end
        end
        if minDist >= 0.5

            disp('new speaker');
            n = n + 1;
            M(n,:) = fv1;
            v = v+1;
            name = strcat('speaker ', int2str(i))
            A(n,:) = fv1;
            classes(v,:) = {name};


        end
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
    fullyConnectedLayer(5)
    softmaxLayer
    classificationLayer];


options = trainingOptions('adam');
net = trainNetwork(A, classes, layers, options);
