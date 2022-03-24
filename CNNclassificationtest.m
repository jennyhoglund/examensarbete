% using this file, we can have CNN classification on the preprocessed dataset path 

%https://se.mathworks.com/help/deeplearning/gs/create-simple-deep-learning-classification-network.html
clc
close all;
clear all;

%Load Data

% digitDatasetPath = 'C:\IoTaP-CoSIS-DISS\Projects\Database\ClassifiedDB\5sec_resized';
% checkpointPath = 'C:\IoTaP-CoSIS-DISS\Projects\Database\ClassifiedDB\5sec_resized';
digitDatasetPath = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\individual_headsets\classes';
checkpointPath = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\individual_headsets\classes';

imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

numTrainFiles = 0.8; 
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

%Define Network Architecture

%inputSize = [656 875 3];
inputSize = [328 438 3];
numClasses = 4;
 % layers = [                           
%     imageInputLayer(inputSize)
%     convolution2dLayer(5,20)
%     batchNormalizationLayer
%     reluLayer
%     fullyConnectedLayer(numClasses)
%     softmaxLayer
%     classificationLayer];

layers = [
    imageInputLayer(inputSize)
    convolution2dLayer(5,20)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

%Train Network

options = trainingOptions('sgdm', ...
    'MaxEpochs',10, ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress',...
    'MiniBatchSize',50, ...
    'CheckpointPath',checkpointPath)


net = trainNetwork(imdsTrain,layers,options);
%activations: 

%Test Network

YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;
accuracy = mean(YPred == YValidation)


