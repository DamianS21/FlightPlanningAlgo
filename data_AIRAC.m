data1=[50 40 29   
023 04 24   
50 37 59   
023 07 24   
50 31 29   
023 00 54   
50 36 29   
022 53 24   
50 40 29   
023 04 24   ];%EPR16
data2=[50 57 59   
020 48 54   
50 56 49   
020 53 34   
50 54 54   
020 59 34   
50 53 24   
021 07 14   
50 50 05   
021 04 15   
50 52 59   
020 52 24   
50 55 29   
020 49 14   
50 57 59   
020 48 54   ];%EPR 18 Œwiêtokrzyski Park Narodowy
data3=[49 37 17  
020 03 24  
49 35 59  
020 13 14  
49 33 59  
020 15 14  
49 31 49  
020 13 54  
49 30 29  
020 08 54  
49 33 44  
020 02 14  
49 34 44  
020 01 14  
49 37 17  
020 03 24  ];%EPR 11 Gorczañski Park Narodowy
data4=[50 32 59.0    
022 03 53.7    
50 26 59.0    
022 08 53.7    
50 25 59.0    
021 56 53.7    
50 23 59.0    
021 44 53.7    
50 27 59.0    
021 45 53.7    
50 31 59.0    
021 54 53.7    
50 32 59.0    
022 03 53.7    ];%EPD25 Dêba
n=4;%ilosc stref
xpunkt=zeros(n,9);
ypunkt=zeros(n,9);
[e1 w1]=konwersja(data1); %Konwersja to funkcja s³u¿aca tylko obs³udze Ÿle sformatowanych danych
[e2 w2]=konwersja(data2);
[e3 w3]=konwersja(data3);
[e4 w4]=konwersja(data4);
xpunkt(1,1:length(w1)) = w1;
xpunkt(2,1:length(w2)) = w2;
xpunkt(3,1:length(w3)) = w3;
xpunkt(4,1:length(w4)) = w4;
ypunkt(1,1:length(e1)) = e1;
ypunkt(2,1:length(e2)) = e2;
ypunkt(3,1:length(e3)) = e3;
ypunkt(4,1:length(e4)) = e4;
xpunkt=xpunkt';
ypunkt=ypunkt';
clear w1 e1 w2 e2;