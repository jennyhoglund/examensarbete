clc
close all
digitDatasetPath ='C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\classes\'
%digitDatasetPath = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\ES2003a\audio\ES2003a.Mix-Headset_filtered\resized'
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames')

numTrainFiles = 0.7; 
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

bag = bagOfFeatures(imdsTrain)
%%
featurevector = encode(bag, read(imds))
%%

%%
