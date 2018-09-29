%% Tomasz K�kol, Modelowanie metod� sztucznych sieci neuronowych, 04.06.2018
clear all;close all;clc;

is = [48, 60,72, 80, 84, 96,120, 132, 144];     
D = 0.7:0.1:0.9; 
spread = [1 5 10 15 20 30 40];
bestError =  1e5;
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
for i = is
     localError = 1e5;
     for d =  D
        indexD =  find(D<=d);
        countD = ind2sub(size(D), indexD(1, size(indexD,2)));
        for s = spread;
         indexSpread =  find(spread<=s);
         countSpread = ind2sub(size(spread), indexSpread(1, size(indexSpread,2)));
              file = strcat(strcat('tryt_',num2str(i)),'.dat');
              data = load(file);
              n = size(data,1);
              NN = 1:n;
              m =  size(data,2);
              ouputData = data(:,1);
              inputData = data(:, 2:m);
              for iteration = 1:1% tutaj nale�y powtarza� algorytm uczenia w celu znalezienia najlepszego rozwi�zania, np 20 razy
                    Mtrain = randperm(n, floor(d*(n)));      
                    const1 = size(Mtrain,2);
                    const2 = n - const1;
                    % inicjalizacja 
                    Xtrain = zeros(const1, size(inputData,2));
                    Xtest = zeros(const2, size(inputData,2));
                    Dtrain = zeros( const1,size(ouputData,2));
                    Dtest = zeros(const2,size(ouputData,2));
                    xlimXtest = zeros(const2, size(inputData,2));
                    Ltrain = 0;
                    Ltest = 0;
                    
                    for j = 1:n
                      if (ismember( j ,Mtrain) == 1)
                            Ltrain = Ltrain+1;
                            Xtrain(Ltrain,:) = inputData(j,:);
                            Dtrain(Ltrain,:) = ouputData(j,:);
                        else 
                            Ltest = Ltest+1;
                            Xtest(Ltest,:) = inputData(j, :);
                            Dtest(Ltest,:) = ouputData(j,:);
                            indexXtest = find( abs(NN-j) < 0.001 );
                            xlimXtest(Ltest,:) = indexXtest ;
                      end
                     end
                    
                      net = newgrnn( Xtrain', Dtrain', s);
                      Ytest = net(Xtest');
                      %Ytrain = net(Xtrain');
                      error = mean((Ytest - Dtest') .* (Ytest - Dtest'))/size(inputData,2); 
                      % poprawka do wzoru
                      %size(inputData,2) poniewa� jest r�na liczba danych,  wiadomo gdy mniej danych to b��d mniejszy co fa�szuje wyniki
                      if error < bestError
                          bestError = error;
                          bestMonthGroup = i;
                          bestSpread = s;
                          bestD =d;
                          bestIteration = iteration;
                          bestXtrain= Xtrain';
                          bestDtrain = Dtrain';
                          bestXtest = Xtest';
                          bestDtest = Dtest';
                          bestNet = net;      
                          bestXlimXtest = xlimXtest;
                      end
                       if error < localError
                          localError = error;
                          localMonthGroup = i;
                          localSpread = s;
                          localD =d;
                          localIteration = iteration;
                          localXtrain= Xtrain';
                          localDtrain = Dtrain';
                          localXtest = Xtest';
                          localDtest = Dtest';
                          localNet = net;       
                      end
              end
        end
 end

figure(1)
subplot(3,1,1)
xs = 1:localMonthGroup;
ys = localNet(rot90(eye(localMonthGroup)));
plot(xs, ys);
hold on
xlabel('Miesi�ce','fontsize',12)
ylabel('Amplituda','fontsize',12)
title(sprintf('Odpowiedz na macierz jednostkow�.\nNajlepsze lokalne dopasowanie dla:  %3.0f miesi�cy, D =%1.1f , Spread = %2.1f',i, localD, localSpread),'fontsize',12);
grid on
hold off

localTTmin = sum(xs .* ys)/sum(ys);
disp(sprintf('Najlepsze lokalne dopasowanie dla:  %3.0f  miesi�cy', i));
disp(sprintf('Dane testuj�ce: �redni wiek wody: %4.2f,  error: %4.5f, spread: %2.2f ,wsp�czynnik D: %1.1f ',localTTmin, localError,  localSpread, localD));

subplot(3,1,2)
plot(1:size(localXtest ,2),localNet(localXtest),'.r');

hold on
xlabel('Kolejne dane testuj�ce najlepszego przypadku','fontsize',12)
ylabel('Warto�� na wy�ciu sieci ','fontsize',12)
title(sprintf('Warto�ci uzyskane na wy�ciu sieci.\nNajlepsze lokalne dopasowanie dla %3.0f miesi�cy,  D =  %1.1f , spread = %2.1f.',i, localD,localSpread ),'fontsize',12);
grid on
hold off

subplot(3,1,3)
set(gcf,'color','w');
plot(localDtrain,localNet(localXtrain),'.b');
hold on
plot(localDtest,localNet(localXtest),'.r');
title('Regresja liniowa weryfikuj�ca dopasowanie modelu do rzeczywistych danych.','fontsize',12);
xlabel('Warto�ci rzeczywiste danych pomiarowych','fontsize',12)
ylabel('Warto�ci wyj�ciowe wyuczone i wytrenowane','fontsize',12)
legend('Dane uczace','Dane testujace');
hold off
end
     
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
figure(2)
subplot(3,1,1)
hold on
xs = 1:bestMonthGroup;
ys = bestNet(rot90(eye(bestMonthGroup)));
plot(xs, ys);
xlabel('Miesi�ce','fontsize',12)
ylabel('Amplituda','fontsize',12)
title(sprintf('Odpowiedz na macierz jednostkow�.\nNajlepsze dopasowanie: D = %1.1f , Spread = %2.1f , miesi�cy: %4.0f',bestD, bestSpread,bestMonthGroup),'fontsize',12);
grid on
hold off

bestTTmin = sum(xs .* ys)/sum(ys);
disp(sprintf('Najlepsze dopasowanie dla danych testuj�cych:'));
disp(sprintf('Wyniki: �redni wiek wody: %5.2f,  Error: %4.5f , Miesi�cy: %3.0f, Spread: %2.2f, Wsp�czynnik D: %1.1f ', bestTTmin, bestError, bestMonthGroup , bestSpread, bestD));

figure(2)
subplot(3,1,2)
plot(1:size(bestXtest ,2),bestNet(bestXtest));
hold on
xlabel('Kolejne dane testuj�ce','fontsize',12)
ylabel('Warto�ci na wyj�ciu sieci','fontsize',12)
title(sprintf('Najlepsze dopasowanie:\n.\n Wsp�czynnik D:  %1.1f , Spread: %2.1f , Miesi�cy: %4.0f. ',bestD,bestSpread, bestMonthGroup  ),'fontsize',12);
grid on
hold off
   
figure(2)
subplot(3,1,3)
plot(bestDtrain,bestNet(bestXtrain),'.b');
hold on
plot(bestDtest,bestNet(bestXtest),'.r');
title('Regresja liniowa weryfikuj�ca dopasowanie modelu do rzeczywistych danych.','fontsize',12);
xlabel('Warto�ci rzeczywiste danych pomiarowych','fontsize',12)
ylabel('Warto�ci wyj�ciowe wyuczone i wytrenowane','fontsize',12)
legend('Dane uczace','Dane testujace');
hold off
  
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
figure(3)
plot(ouputData);
hold on
plot(bestXlimXtest,bestNet(bestXtest),'.r');
title('Charakterystyka zawarto�ci trytu w Dunaju.\nPor�wnanie wynik�w modelu z rzeczywistymi dla ostatnich lokalnych danych (144 miesi�cy)','fontsize',12);
xlabel('Miesi�c (losowe miesi�ce macierzy danych testuj�cych)','fontsize',12);
ylabel('Zawarto�� trytu (TU)','fontsize',12)
legend('Dane rzeczywiste','Dane symulacji (testuj�ce)');
grid on
hold off

view(bestNet)