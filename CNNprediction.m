Path = 'C:\IoTaP-CoSIS-DISS\Projects\Database\ClassifiedDB\TestDB\p8\acwt_27.jpg';
Path = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\individual_headsets\classes_copy\headset3_resized\acwt_80.jpg';
I = imread(Path);
clc

[labelIdx, score] = predict(classifier,I)
cnt = 0;
for i=1:2
    if score(i)<-0.1 
        cnt=cnt+1;
    end 
end 
if cnt == 2
    mess = 'NEW SPEAKER'
else 
    labelIdx
end
    

%[YPred,scores] = classify(net,I)
%YPreddd = predict(net,I) 
%%scoreMap = occlusionSensitivity(net,I,label);
