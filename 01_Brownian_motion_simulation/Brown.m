%% �wiczenie 1: Symulacja ruch�w Browna. 05.03.2018 ( pon.13:00 ), K�kol Tomasz
clear all; close all; clc;

%% Dane pocz�tkowe - wszystkie parametry posiadaj�  jednostki nominalne 
u = 0;                            % warto�� �rednia (rozk�ad normalny)
sigma = 1;                   % odchylenie standardowe (rozk�ad normalny)
k =1000;                         % liczba krok�w
dt = 0.5;                        % warto�� przyrostu czasu
t = 0:dt:k/2;                 % wektor czasu
D = 0;                            % dyfuzja (warto�� pocz�tkowa)              
x = zeros(k,k);            % pocz�tkowa definica macierzy po�o�enia, startowa definicja warto�ci pocz�tkowych [0 0] 
y = zeros(k,k);

%% Symulacja metod� Monte Carlo
for j=1:k
    for i=1:k
        dx = normrnd(u, sigma);
        dy = normrnd(u, sigma);
        dr2 = dx.^2 + dy.^2;                 % kwadrat pojedynczego przemieszczenia
        D = D + dr2/(2*2*dt);                 % <dr2> = 2*n*D*dt , n-liczba wymiar�w 2D
        x(j,i+1) = x(j,i) + dx;
        y(j,i+1) = y(j,i) + dy;
    end
end
R = x.^2 + y.^2;                                  % macierz przemieszcze�
r = cumsum(R,1) /(length(R));

%% Podgl�d

% pierwsza trajektoria cz�stki Brownowskiej w 2 wymiarach
figure(1);
plot(x(1,:),y(1,:));
xlabel('x [j]');
ylabel('y [j]');
title('Obraz trajektorii cz�stki Brownowskiej w 2 wymiarach. .');
grid on;

% krzywa reprezentuj�ca �redni� z n trajektorii cz�stek
figure(2);
plot(t,r(end,:),'r');
xlabel('Czas [j]');
ylabel('�redni kwadrat przemieszczenia [j^2]');
title('Zale�no�� �redniego kwadratu przemieszczenia od czasu.');
grid on;

% podgl�d warto�ci parametru dyfuzji
disp(D/(k*k));   %ca�kowita suma warto�ci podzielona przez k^2 element�w macierzy
