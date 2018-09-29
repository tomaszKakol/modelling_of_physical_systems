function zad03
%% czêœæ 1
clear all, close all, clc;
A = 0.3;
S = 1366; % W/m^2
B = 5.67*10^(-8); % W/m^2
T = ((S*(1-A))/(4*B))^(1/4);
T - 273.15 % [C]

%% czêœæ 2
S = 1366; % W/m^2
B = 5.67*10^(-8); % W/m^2
ta = 0.53;
as = 0.63; %0.19;
aa = 0.3;
tap = 0.06;
aap = 0.31;
c = 2.7;
treshold = 273.15-10; %-10C
all = [];
for i = 0.8:0.01:1.2
SP = S* i ;
result = fsolve(@heatfun, [273, 273]);
if (result(1) > treshold)
as = 0.19;
end
all = [all; result - 273.15]; % [C]
end
subplot(2, 1, 1);
plot([0.8:0.01:1.2]*S, all(:, 1));
hold on 
%plot(1.2*S, -50:0.1:50,'g-');
%hold on;
%plot(0.8*S, -50:0.1:50,'r--')
xlabel( 'Sta³a s³oneczna S [W/m^2]' );
ylabel( 'Temperatura (st. C)' );
title('Zale¿noœæ œredniej temperatury powierzchni i atmosfery od sta³ej s³onecznej');
grid on;
hold on;
as = 0.19;
all2 = [];
for i = 1.2:-0.01:0.8
SP = S* i ;
result = fsolve(@heatfun, [273, 273]);
if (result(1) < treshold)
as = 0.63;
end
all2 = [all2; result - 273.15]; % [C]
end
plot([0.8:0.01:1.2]*S, flipud(all2(:, 1)),'r');%fliplr
legend( 'Zmiany od 0.8S do 1.2 S' ,'Zmiany od 1.2S do 0.8 S' );
subplot(2, 2, 3);
plot([0.8:0.01:1.2]*S, all(:, 1));
title( 'Zmiany od 0.8S do 1.2 S' );
xlabel( 'Sta³a s³oneczna S [W/m^2]' );
ylabel( 'Temperatura (st. C)' );
grid on;
subplot(2, 2, 4);
plot([0.8:0.01:1.2]*S,flipud(all2(:, 1)),'r');
title('Zmiany od 1.2S do 0.8 S' );
xlabel( 'Sta³a s³oneczna S [W/m^2]' );
ylabel( 'Temperatura (st. C)' );
grid on;

as = 0.19;
SP = S;
fsolve(@heatfun, [273, 273]) - 273.15 %temperatury na powierzchni i w atmosferze
function F = heatfun (x)
F = [(-ta)*(1-as)*(SP/4)+c*(x(1)-x(2))+B*(1-aa)*(x(1))^4-B*x(2)^4;...
-(1-aa-ta+as*ta)*(SP/4)-c*(x(1)-x(2))-B*(1-tap-aap)*x(1)^4+2*B*x(2)^4];
end
end