%% Æwiczenie 1: Symulacja ruchów Browna. 05.03.2018 ( pon.13:00 ), K¹kol Tomasz
clear all; close all; clc;

%% Dane pocz¹tkowe - wszystkie parametry posiadaj¹  jednostki nominalne 
u = 0;                            % wartoœæ œrednia (rozk³ad normalny)
sigma = 1;                   % odchylenie standardowe (rozk³ad normalny)
k =1000;                         % liczba kroków
dt = 0.5;                        % wartoœæ przyrostu czasu
t = 0:dt:k/2;                 % wektor czasu
D = 0;                            % dyfuzja (wartoœæ pocz¹tkowa)              
x = zeros(k,k);            % pocz¹tkowa definica macierzy po³o¿enia, startowa definicja wartoœci pocz¹tkowych [0 0] 
y = zeros(k,k);

%% Symulacja metod¹ Monte Carlo
for j=1:k
    for i=1:k
        dx = normrnd(u, sigma);
        dy = normrnd(u, sigma);
        dr2 = dx.^2 + dy.^2;                 % kwadrat pojedynczego przemieszczenia
        D = D + dr2/(2*2*dt);                 % <dr2> = 2*n*D*dt , n-liczba wymiarów 2D
        x(j,i+1) = x(j,i) + dx;
        y(j,i+1) = y(j,i) + dy;
    end
end
R = x.^2 + y.^2;                                  % macierz przemieszczeñ
r = cumsum(R,1) /(length(R));

%% Podgl¹d

% pierwsza trajektoria cz¹stki Brownowskiej w 2 wymiarach
figure(1);
plot(x(1,:),y(1,:));
xlabel('x [j]');
ylabel('y [j]');
title('Obraz trajektorii cz¹stki Brownowskiej w 2 wymiarach. .');
grid on;

% krzywa reprezentuj¹ca œredni¹ z n trajektorii cz¹stek
figure(2);
plot(t,r(end,:),'r');
xlabel('Czas [j]');
ylabel('Œredni kwadrat przemieszczenia [j^2]');
title('Zale¿noœæ œredniego kwadratu przemieszczenia od czasu.');
grid on;

% podgl¹d wartoœci parametru dyfuzji
disp(D/(k*k));   %ca³kowita suma wartoœci podzielona przez k^2 elementów macierzy
