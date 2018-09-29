clear all; close all, clc;

%% stale
l = 100;    % [m]
w = 5;      % [m]
d = 1;       % [m]
T = 1000;    % [s]
mfv = 0.1;  % [m/s]
dc = 0.01;  % [m^2/s]
lip = 10;       % [m]
lmp = [30 60 90];  % [m]
ait = 1;        % [kg]
dx = 0.1;
dt = 0.5;
x = 0:dx:l;
lx = round(l/dx)+1;
It = round(T/dt)+1;
Ix_lip = round(lip/dx)+1;
Ix_lmp = round(lmp/dx)+1;
initC = ait/(w*d*dx);
ca = mfv*dt/dx;
cd = dc*dt/(dx*dx);

%% deklaracje, inicjalizacje
C = zeros(It, lx);
C(1, Ix_lip) = initC;
C(:, 1:2) = 0;
Ct = [];
t = [];

%% rozwi¹zania
n = round(l/dx)+1;
AA = zeros(n);
aa00 = 1+cd;               aa01 = -(cd/2)+(ca/4);
aa10 = -(cd/2)-(ca/4);

bb00 = 1-cd;               bb01 = (cd/2)-(ca/4);
bb10 =(cd/2)+(ca/4);

for i=1:n
    for j=1:n
        if i == j
            AA(i,j) = aa00;
            BB(i,j) = bb00;
        end
        if j == i+1
            AA(i,j) = aa10;
            BB(i,j) = bb10;
        end
        if i == j+1
            AA(i,j) = aa01;
            BB(i,j) = bb01;
        end
    end
end
AB = AA\BB;
AB(1,:) = 0;
AB(:,lx) = AB(:,lx-1);

figure(1)
for n =1:It
   % t = [t n*dt];  
    t = [dt:dt:n*dt];
    C(n+1,:) = C(n,:) * AB;
    C(n+1,lx) = C(n+1,lx-1);
    Ct = [Ct [C(n+1, Ix_lmp(1));C(n+1, Ix_lmp(2));C(n+1, Ix_lmp(3))]];
    if mod(n,10) == 0
        sumC = sum(C(n+1,:))*w*d*dx;
        for i = 1:length(lmp)
            result(i) = sum(Ct(i,:))*w*d*mfv*dt;
        end
        subplot(2,2,1);
        plot(x, C(n+1,:));%,'color',rand(1,3)
         hold on;
        plot([90 90], [0 1], 'r--')
        title(sprintf('Pomiar czasu: %4.1f  [s]', n*dt));
        xlabel('Odleg³oœæ [m]');
        ylabel('Gêstoœæ [kg/m3]');
        ylim([0 initC/7]);
        legend (sprintf('Masa: %1.3f  [kg]', sumC),'Punkt pomiaru');
        grid on;
       
        subplot(2,2,2);
       % for i = 1:length(lmp)
            % plot(t, Ct(i,:),'color',rand(1,3));
            plot(t, Ct(1,:),'g');
            hold on; plot(t, Ct(2,:),'b');
            hold on; plot(t, Ct(3,:),'r');
        %end
        axis([0 T 0 0.08]);
         for i = 1:length(lmp)
            legendLabels{i} = sprintf('Punkt pomiaru: %0.2f [m], Masa ca³kowita: %1.3f  [kg]\n', lmp(i), result(i));
         end
         hold off;
         title(sprintf('Punkt pomiaru, czas: %4.1f  [s]', n*dt));
         xlabel('Czas [s]');
         ylabel('Gêstoœæ [kg/m3]');
         legend(legendLabels);
         grid on;
        pause(0.001);
    end;
end;
