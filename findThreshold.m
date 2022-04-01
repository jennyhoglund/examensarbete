%% Experimentell framtagning av gränsvärden genom att jämföra bilder inom samma klass och bilder mellan två olika klasser.
%%Gör det genom att skriva encode(bag, I).
%%testa först för två av samma och sedan för två av olika, bestäm vilket
%%avstånd man ska använda. Testa både euclidean och cosine.
%%Testa också att göra en forloop och loopa igenom alla avstånd för en
%%klass. Gör det för varje klass. Ta medelvärdet.
%%Upprepa testet för cosine.

%räkna ut standard deviation genom att ta slumpmässiga eller ett fåtal
%jämförelser inom en klass, summera, ta en nt klass, summera, etc, för
%kanske 4 okända klasser. Håll koll på det totala antalet jämförelser som
%har gjorts.


Path1 = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\ES2003a_3R\ES2003a_3R\ES2003a-0\'
Path2 = 'C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\amicorpus\ES2003a_3R\ES2003a_3R\ES2003a-0\'
a=dir([strcat(Path2,'*.jpg')])
b = numel(a)
tot = 0;
max = 0;
times = 0;
distancesVector = zeros(1, 1);
c = dir([strcat(Path1,'*.jpg')]);
d = numel(c);


%%

for i = 1: 10: d
    temp1 = strcat(Path1,'acwt_', int2str(i), '.jpg');
    I1 = imread(temp1);
    f1 = encode(bag, I1);
    
    for j = i: 2: b
        times = times + 1;
        temp2 = strcat(Path2,'acwt_', int2str(j), '.jpg');
        I2 = imread(temp2);
        f2 = encode(bag, I2);
        dist = pdist([f1 ; f2 ]);
        distancesVector(times) = dist;
        tot = tot+ dist;
        if (dist > max)
            max = dist;
            maximname = temp1;
        end


    end
end
%% beräkna mean absolute deviation
tot
mean = tot/numel(distancesVector)
deviations = distancesVector-mean;
distancesVector;
times
deviations = abs(deviations);
mad = sum(deviations)/numel(deviations)

%%Beräkna standard deviation
mean = tot/numel(distancesVector);
deviations = distancesVector-mean;
sqrtdeviations = sqrt(deviations);
sumroots = sum(sqrtdeviations);
variance = sumroots/numel(deviations);
standarddeviation = sqrt(variance)

%% testa att lägga till nya kolumner dynamiskt

V = zeros(1, 10)
V(:,11) = 1




%%




