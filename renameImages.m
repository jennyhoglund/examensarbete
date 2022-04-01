%% rename images

PathFrom = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\unknownclasses\TS3012a.Headset-2\';
PathTo = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\unknownclasses\mixofUnknown\'
id = 'TS3012a.Headset-2';
amtOfImages = 83-72;
imageNumbr = 43;

for i = 72: 83
    oldname = strcat(PathFrom,'acwt_', int2str(i), '.jpg');
    newname = strcat(PathTo, id,'_', int2str(imageNumbr), '.jpg');
    [status, msg] = copyfile(oldname, newname )
    imageNumbr = imageNumbr+1;




end