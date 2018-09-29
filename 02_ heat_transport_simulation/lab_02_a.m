clear all;close all;clc;

%% dane
a = 0.2;               %m
b = 0.1;               %m
c = 0.05;             %m
d = 0.04;            %m
h = 0.002;         %m

Aluminium = [2700, 900, 237];
Miedz= [8920, 380, 401];
Stal = [7860, 450, 58];

Tmax=7; %czas symulacji
t_grzalki=80;
t_krawedzi=20;
K=Miedz(1,3);
cw=Miedz(1,2);
ro=Miedz(1,1);

NX = 41;       % ilosc wezlow w kier x
NY = 41;       % ilosc wezlow w kier y
dx = a/(NX-1);  % krok przestrzenny x
dy = a/(NY-1);  % krok przestrzenny y
delta_t = 0.01;
NT = round(Tmax/delta_t);

%% rozwi¹zanie

ob = ones(NX,NY)*t_krawedzi;
ob(7:41,1:11) = 0;
ob(7:41,31:41) = 0;
ob(3:11,18:25) = t_grzalki;
%figura
fig = ones(NX,NY);
fig(7:41,31:41) = 0;
fig(7:41,1:11) = 0;

Cx = K*delta_t/(cw*ro*dx^2);
Cy = K*delta_t/(cw*ro*dy^2);
[XX YY] = meshgrid(0:dx:a, 0:dy:a);

T1 = ob;
for n=1:NT
    %T1 = T;
    for i=2:NX-1
        for j=2:NY-1
            if(fig(i,j)==1)
                 T1(i,j) = ob(i,j) + Cx*( ob(i-1,j) - 2*ob(i,j) + ob(i+1,j)) + Cy*( ob (i,j-1) - 2*ob(i,j) + ob(i,j+1));
              end;
        end;
    end;
if(max(max(abs(ob-T1))) < 0.001)
       break;
    end;
    ob = T1;
    surf(XX,YY,ob);
 title(sprintf( 'Czas symulacji: %0.2f (s)' , n * delta_t ));
        xlabel( 'x (m)' );
        ylabel( 'y (m)' );
        zlabel( 'temperatura (stC)' );
    zlim([0 90]);
    %pause(0.2);
end
mean(mean(ob,2),1)
