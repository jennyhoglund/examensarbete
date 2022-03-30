%%Numrera om alla bilder i en mapp.
% Läs in en bild i taget, om siffran > förra+1, ändra namn på den, och på
% alla andra resterande bilder.

Path = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\classes_copy\EN2001-0\'

a=dir([strcat(Path,'*.jpg')])
b = numel(a);

%%Gå igenom alla filer i mappen, om en fil saknas, ändra namn på den


for i = 1: b 
   temp1 = strcat(Path,'acwt_', int2str(i), '.jpg');
   j = 1;
   while not(isfile(temp1))
    if not(isfile(temp1))
        j = j+1;
        temp1 = strcat(Path, 'acwt_', int2str(j+i), '.jpg');
    end
   end
   if j>1 %Om j>1 har while-loopen körts minst en gång.
       % temp1 = strcat(Path, 'acwt_', int2str(i+j), '.jpg'); byt namn från
       % den som finns dvs i+j till i. 
       newname = strcat(Path, 'acwt_', int2str(i), '.jpg');
       status = movefile(temp1, newname );
       disp('changing name')

   end

end
%
% clc
% testpath = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\classes_copy\ES2002headset2_resized\'
% im1 ='C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\classes_copy\ES2002headset2_resized\acwt_1.jpg'
% im2 = strcat(testpath,'acwt_', int2str(22), '.jpg')
% [status,msg] = movefile(im1 ,im2)
%%
