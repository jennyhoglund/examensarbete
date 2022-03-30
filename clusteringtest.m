%% Experimentell framtagning av gränsvärden genom att jämföra bilder inom samma klass och bilder mellan två olika klasser.
%%Gör det genom att skriva encode(bag, I).
%%testa först för två av samma och sedan för två av olika, bestäm vilket
%%avstånd man ska använda. Testa både euclidean och cosine. 
%%Testa också att göra en forloop och loopa igenom alla avstånd för en
%%klass. Gör det för varje klass. Ta medelvärdet.
%%Upprepa testet för cosine.








Path1 = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\unknownclasses\EN2009c.Headset-0\'
Path2 = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\unknownclasses\EN2009c.Headset-0\'

a=dir([strcat(Path2,'*.jpg')])
b = numel(a)
sum = 0;
max = 0;

for i = 20: 5: b-1 
    temp1 = strcat(Path1,'acwt_', int2str(i), '.jpg');
    I1 = imread(temp1);
    f1 = encode(bag, I1);
    for j = i: 5: b-1 
        temp2 = strcat(Path2,'acwt_', int2str(j), '.jpg');
        I2 = imread(temp2);
        f2 = encode(bag, I2);
        dist = pdist([f1 ; f2 ])
        sum = sum+ dist;
        if (dist > max)
            max = dist;
        end


    end
end
