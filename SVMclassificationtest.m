% using this file, we can have SVM classification on the preprocessed dataset path 

%digitDatasetPath = 'C:\IoTaP-CoSIS-DISS\Projects\Database\ClassifiedDB\1-class';
%digitDatasetPath = 'C:\IoTaP-CoSIS-DISS\Projects\Database\ClassifiedDB\5sec_resized';
clc
close all
digitDatasetPath ='C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\individual_headsets\classes'
%digitDatasetPath = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\ES2003a\audio\ES2003a.Mix-Headset_filtered\resized'
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

numTrainFiles = 0.7; 
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');
imds
imdsTrain
bag = bagOfFeatures(imdsTrain)
%%
featurevector = encode(bag, read(imds));
figure
bar(featurevector)
title('Visual word occurrences')
xlabel('Visual word index')
ylabel('Frequency of occurrence')

%%


%opts = templateSVM('BoxConstraint',1.1,'KernelFunction','gaussian');
classifier = trainImageCategoryClassifier(imdsTrain,bag) %Note that this function relies on the multiclass linear SVM classifier from the Statistics and Machine Learning Toolbox™.
%CompactClassificationSVM  >>> https://se.mathworks.com/help/stats/classreg.learning.classif.compactclassificationsvm.html

%Now that we have a trained classifier, categoryClassifier, let's evaluate it. 
% Next, let's evaluate the classifier on the validationSet, which was not used during the training. 
% By default, the evaluate function returns the confusion matrix, which is a good initial indicator of how well the classifier is performing.

confMatrix = evaluate(classifier,imdsValidation)
% Compute average accuracy
mean(diag(confMatrix))
 

%https://se.mathworks.com/help/vision/ref/trainimagecategoryclassifier.html
%https://se.mathworks.com/help/stats/fitrlinear.html