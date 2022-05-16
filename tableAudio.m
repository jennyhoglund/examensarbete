clc
clearvars

tbl0 = readtable("C:\Users\hebam\Desktop\Examensarbete\xls files\ES2003B.0.xls");
 maintbl = readtable("C:\Users\hebam\Desktop\Examensarbete\xls files\ES2003B.1.xls");
tbl2 = readtable("C:\Users\hebam\Desktop\Examensarbete\xls files\ES2003B.2.xls");
tbl3 = readtable("C:\Users\hebam\Desktop\Examensarbete\xls files\ES2003B.3.xls");

audioPath ="C:\Users\hebam\Desktop\Examensarbete\AMI-corpus\10_klasser"
audiomixfile = "ES2003b.Mix-Lapel";
[y, fs] = audioread(strcat(audioPath, "\",audiomixfile, ".wav"));

temp1 = [300 350 ; 350 370];
temp2 = [310 331 ; 340 380];
%%

for i = 1:height(maintbl)
   maintbl = removeOverlapLoop(maintbl, tbl0, i);
   maintbl = removeOverlapLoop(maintbl, tbl2, i);
   maintbl = removeOverlapLoop(maintbl, tbl3, i);
end
filtertable(maintbl,audioPath,audiomixfile);

%%


function newtbl = removeOverlapLoop(maintbl, tbl1, i)
start = maintbl.start(i);
start2=0;
en = maintbl.xEnd(i);
en2 = 0;
j = 1;
while j <= height(tbl1)

    start2 = tbl1.start(j);
    en2 = tbl1.xEnd(j);
    %j = j+1
    if start2 >start && en2 <= en
        disp('segment1 -segment2- segment1')
        i
        tbl1.x_who(j)
        start2
        en2
        start
        en
        j
        height(tbl1)
        if (start2 - start) > (en - en2)
            en = start2;
            maintbl.xEnd(i) = en;
            %  temp1(i,2) = en
        else

            start = en2;
            maintbl.start(i) = start;
            %  temp1(i,1) = start

        end
       
% 
%     elseif start2 == start
%         disp('start at the same time')
%         maintbl.xEnd(i) = maintbl.start(i);
%         %  temp1(i,2) = temp1(i,1)

    elseif en2 > start && en2 < en
        disp('start1 < en2 < en')
        start = en2;
        maintbl.start(i) = start;

    elseif start2 <= start && en2>en
        disp('segment2 -segment1- segment2')
        en = start;
        maintbl.xEnd(i) = en;
       

    elseif start2 > start  && start2 < en
        disp(['start1 < start2 < en1'])
        en = start2;
        maintbl.xEnd(i) = en;

    end
    j = j+1;
end
newtbl = maintbl;
end
function filtertable(maintbl, audioPath, audiomixfile)
[audio, fs] = audioread(strcat(audioPath, "\",audiomixfile, ".wav"));
%
% tablePath = "C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\lapelmixes\excelfiler"
% audioPath = "C:\Users\jenny\OneDrive\Documents\Skola\Examensarbete\Material\nyaAmiCorpus\lapelmixes\ljud"
% audiomixfile = "ES2011a"
% tablename = "es2011a-A"


% t = readtable(strcat(tablePath,"\", tablename, ".xls"))


lastend=1;
onesec= zeros(floor(fs*(sum(maintbl.xEnd(1:end))-sum(maintbl.start(1:end)))),1);
totaltime = 0;




% Läs in alla tabeller, för varje rad i tabellen som ljudfil ska göras för,
% kolla jämförs dess starttid och sluttid med alla andra. Leta igenom de
% andra tabellerna tills man kommit till en rad som startar efter att den
% första slutar. Om en annan tabell har en starttid som är efter den
% första, men som startar innan den första slutar, ta bort del av
% segmentet. Om en tabell har en starttid som är innan den första men som
% slutar efter den första slutar. I princip, om antingen sluttiden eller
% starttiden för någon rad är mellan start till slut för den aktuella
% raden, ta bort. ta också bort om starttiden är exakt samtdigigt. om en
% bit av signalen måste tas bort, skriv in nya start och sluttiden. Om
% startiderna är samma, ta bort hela segmentet. I den inre loopen, sök
% igenom en tabell tills dess sluttid är efter segmentet.



for i=1:height(maintbl)
    start=floor(fs*maintbl.start(i));
    endd=floor( fs*maintbl.xEnd(i));
    x = audio(start:endd-1);
    a = endd-start;
    totaltime = totaltime+a/fs;
    onesec(lastend:lastend+a-1)=x;
    lastend=lastend+ a+1;

end

audiowrite(strcat(audioPath, "\","ES2003B.1", "_filtered.wav"),onesec,fs);
end
