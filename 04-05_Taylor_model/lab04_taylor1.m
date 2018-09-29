clear; close all; clc;

%sta³e
t = 1000;              % [s]
l = 100;                % [m]
w = 5;                  % [m]
d = 1;                  % [m]
mfv = 0.1;          % [m/s]
dc = 0.01;          % [m^2/s]
lip = 10;              % [m]
lmp = [30 60 90];         % [m]
ait = 1;                % [kg]

dx = 0.1;
dt = 0.5;
lx = l / dx;
lt = t / dt;
ca = mfv * dt / dx;
cd = dc * dt / dx^2;

%%deklaracje
initPositionIndex = lip / 100 * lx;
measurePositionsIndexes = lmp / 100 * lx;
result = zeros(1, lx);
result(initPositionIndex) = ait / (w * d * dx);
resultInPoints = zeros(length(lmp), lt);

%%Rozwi¹zanie
a1 = cd*(1-ca)-(ca/6)*(ca^2-3*ca+2);
a2 = cd*(2-3*ca)-(ca/2)*(ca^2-2*ca-1);
a3 = cd*(1-3*ca)-(ca/2)*(ca^2-ca-2);
a4 = cd*ca+(ca/6)*(ca^2-1);
figure(1);
for n = 1:lt
   prevResult = result;
   for j = 3:lx-1
       result(j) = prevResult(j) + ...
           a1 * prevResult(j+1) - ...           
           a2 * prevResult(j) + ...           
           a3 * prevResult(j-1) + ...
           a4 * prevResult(j-2);          
  end
   for i = 1:length(lmp)
       resultInPoints(i, n) = result(measurePositionsIndexes(i));
   end
   
   if n == lt % || mod(n, 40) == 0
      subplot(1, 2, 1);
      plot(dx:dx:l, result);
      totalMass = sum(result) * (w * d * dx);
      title(sprintf('Rozk³ad znacznika w rzece.\nCzas symulacji: %0.2f (s), Masa: %0.3f (kg)', n * dt, totalMass));
      ylabel('Gêstoœæ (rozk³ad znacznika) [kg/m^3]');
      xlabel('Odleg³oœæ [m]');
      ylim([0 0.0003]);
      hold on; plot([90 90], [0 1], 'r--');
      grid on;
      legend('Krzywa gêstoœci znacznika','G³ówny punkt pomiaru', 'Location', 'NorthWest');
      subplot(1, 2, 2);
      hold on;
      legendLabels = cell(1, length(lmp));
      for i = 1:length(lmp)
          plot(dt:dt:t, resultInPoints(i, :),'color',rand(1,3));
          legendLabels{i} = sprintf('Punkt pomiaru: %0.2f (m), Masa: %0.3f (kg)', lmp(i), sum(resultInPoints(i, :)) * (w * d * mfv * dt));
      end
      hold off;
      title(sprintf('Rozk³ad znacznika w wyznaczonym punkcie pomiaru.\n Czas symulacji: %0.2f (s)', n * dt));
      legend(legendLabels);
      ylabel('Gêstoœæ (rozk³ad znacznika) [kg/m^3]');
      xlabel('Czas [s]');
      ylim([0 0.05]);
      grid on;
   end
end
