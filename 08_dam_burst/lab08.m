%% Tomasz K¹kol, MPF 2018
clear all; close all; clc;

%% sta³e
L=10;  
T=5;       
time = 5;
fdw=1000;          
g=9.81;
hTup=15;
hTdown = 5;
deq=2;
dx=0.01;
dt=0.001;
Nx = L/dx;
Nt = time/dt;
S=(hTup-hTdown)/Nx;
trigonometric= tan(deq*pi/180);
checkpoints = [1*Nx/5  2.6*Nx/5 4*Nx/5];

%% inicjalizacja
Hpoint=zeros(size(checkpoints,2),Nt);  
Q=zeros(Nx,Nt);
h=zeros(Nx,Nt);

%% definicja warunków pocz¹tkowych
for i=1:(0.01*L*Nx)
    h(i,1)= hTup+  trigonometric*dx*(floor(0.01*L*Nx)-i);
end

 h((0.01*L*Nx+1) : floor(0.05*L*Nx),1)=hTup;

for i = ceil(0.05*L*Nx+1): Nx
    h(i,1)= hTdown - trigonometric*dx*(i-ceil(0.05*L*Nx));
end

h(Nx,:) = hTdown - trigonometric*dx*Nx;

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');

%% Rysunek 1
figure(1)
plot(linspace(0, Nx,Nx),h(:,1),'b','LineWidth',2);%linspace(0,L,L/dx),
hold on
line([floor(0.05*L*Nx) floor(0.05*L*Nx)], [5 15],'Color',[1 0 0],'LineWidth',4);
ylim([4 16]);
xlabel('Odleg³oœæ [kolejne wêz³y przesuniêcia przestrzennego]','fontsize',12)
ylabel('Wzglêdny poziom wody[m]','fontsize',12)
title('Warunki startowe. Widok lustra wody.','fontsize',12)
legend('Lustro wody', 'Zapora na wzglêdnej wysokoœci 5-15 [m]')
hold off;

%% inicjalizacja
Q(:,1)=0;
R=zeros(Nx,Nt);
A=zeros(Nx,Nt);
A(:,1)=T*h(:,1);
R(:,1)=T*h(:,1)./(T+2*h(:,1));

for n=1:Nt     %czas
    for i=1:Nx-1
        h(i,n+1)=h(i,n) -dt*((Q(i+1,n)-Q(i,n))/dx)/T;
        R(i,n+1)=T*h(i,n+1)/(T+2*h(i,n+1));
        A(i,n+1)=T*h(i,n+1);
        %h(Nx,n+1)= hTdown - trigonometric*dx*Nx; %warunek Dirichleta
        h(Nx,n+1)=h(Nx-1,n+1);  %warunek von Neumanna
    end

    for k=1:size(checkpoints,2)
        Hpoint(k,n)=h(checkpoints(1,k),n);
    end
    
    A(Nx,n+1)=T*h(Nx,n+1);
    R(Nx,n+1)=T*h(Nx,n+1)/(T+2*h(Nx,n+1));
    
%% uproszczony model FLDWAV, algorytm
    for i=2:Nx-1
                Q(i,n+1)=Q(i,n) - dt*((power(Q(i+1,n),2) / (A(i+1,n+1)) - power(Q(i-1,n),2) / A(i-1,n+1))/2/dx ...
                                            + abs(Q(i,n)/A(i,n+1))*Q(i,n) * fdw/(8*(R(i,n+1))) ...
                                            + g*A(i,n+1)*((h(i,n+1)-h(i-1,n+1))/dx -S));

    end
    
    Q(Nx,n)=Q(Nx-1,n);
    V(:,n)=Q(:,n)./A(:,n);
    dt=dx/(max(V(:,n)) +sqrt(9.81*max(h(:,n))));         
    
   %% Rysunek 2
    figure(2)
    subplot(2,1,1);
    plot(h(:,n));
    axis([0, Nx, 4, 16]);
    xlabel('Odleg³oœæ [kolejne wêz³y przesuniêcia przestrzennego]','fontsize',12)
    ylabel('Wzglêdny poziom wody[m]','fontsize',12)
    title(sprintf('Charakterystyka zmiany poziomu wody po pêkniêciu tamy.\nD³ugoœæ odcinka: %3.0f (m)',  i*dx),'fontsize',12)
    legend('Lustro wody')
    % pause(0.0001);
    
    figure(2)
    subplot(2,1,2);
    plot(Hpoint(1,:),'r');
    subplot(2,1,2);
    hold on
    plot(Hpoint(2,:),'g');
    subplot(2,1,2);
    hold on
    plot(Hpoint(3,:),'k');
    hold off
    axis([0, Nt, 4, 16]);
    xlabel('Czas [kolejne wêz³y przesuniêcia czasowego]','fontsize',12)
    ylabel('Wzglêdny poziom wody[m]','fontsize',12)
    title(sprintf('Zmiana wysokoœci zwierciad³a w  wybranych wêz³ach przestrzenny  w funkcji czasu.\nCzas: %1.4f (s)',  n*dt),'fontsize',12)
    legend(sprintf( 'Wêze³ przestrzenny: %4.0f ' , checkpoints(1,1)),...
                sprintf( 'Wêze³ przestrzenny: %4.0f ' , checkpoints(1,2)),...
                sprintf( 'Wêze³ przestrzenny: %4.0f ' , checkpoints(1,3)))
    %pause(0.0001)
end
