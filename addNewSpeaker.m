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

    fv1 = encode(bag, im);
    minDist = 0;
    info.Label

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
            %if  dist < 0.3 && dist >0.2
            if dist < 0.3
                id = i;
                if dist >0.2
                    prompt = strcat("Are you speaker ",i, "?" );
                    x = input(prompt, "s");
                    if x == "no"
                        prompt = "Which number of speaker are you? If you are a new speaker, please enter the number ", int2str(i+1);
                        id = input(prompt);
                    end

                end
                name = strcat('speaker ', int2str(id));
                M(i,:) = fv1;
                minDist = -1;
                v = v+1;
                A(v,:) = fv1;
                classes(v,:) = {name};
            end
        end
        x = 0;
        if minDist >= 0.5 || minDist ~= -1
            prompt = ("Are you a new speaker?");
            x = input(prompt, "s");
            if (x == "yes")
                n = n+1;%n är antal speakers
                id = n;
            else
                prompt = "Which number of speaker are you?";
                id = input(prompt);
            end
            M(id,:) = fv1;
            v = v+1; % v är totala antalet vektorer hittills
            name = strcat('speaker ', int2str(n));
            A(v,:) = fv1;
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
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

tic
options = trainingOptions('adam');
net = trainNetwork(A, classes, layers, options);
toc
%%


