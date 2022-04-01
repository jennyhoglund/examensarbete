% Hämta bild, encoda bild, jämför den vektorn med alla vektorer i array.
clc
M = zeros(1,500);

path = '';
i = 1;
nbrOfSpeakers = 0;
imds = imageDatastore("C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\featureclasses", ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
[im, info] = read(imds);

imshow(im)
[imdsTrain, imdsTest] = splitEachLabel(imds, 0.5);



%%
while imdsTrain.hasdata
%for j = 1 : 3
    [im, info] = read(imdsTrain);
    info.Label

    
    fv1 = encode(bag, im);
    if nbrOfSpeakers == 0
        nbrOfSpeakers = 1;
        M(1,:) = fv1;

    else
        minDist = 2;
        for i = 1:nbrOfSpeakers
            fv2 = M(i,:);
            dist = pdist([fv1 ; fv2])
            if dist < minDist
                minDist = dist;
            end
            if dist < 0.3
                M(i,:) = fv1;
                minDist = -1;
                disp(strcat('speaker ', int2str(i)))
            end
        end
        if minDist >= 0.5

            disp('new speaker');
            nbrOfSpeakers = nbrOfSpeakers + 1;
            M(nbrOfSpeakers,:) = fv1;

        end
    end


end
whos M
whos Names

%%
 classifier = trainImageCategoryClassifier(imdsTrain, bag)
 evaluate(classifier, imdsTest)



%% Skapa först en matris som kan rymma 10 talarvektorer som är 500 element.
%%testa med olika bilder: att jämför dens vektor med alla vektorer. Om avståndet är mindre än 0.3,


