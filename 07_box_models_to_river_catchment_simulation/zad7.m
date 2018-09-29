function error = zad7(tt)
danaj = load( 'dunaj.prn' );
opady = load( 'opady.prn' );
lambda = log (2)/(12.3 * 12);
[N, ~] = size (danaj);
result = zeros (1, N);
for t = 162:N
    for tp = 1:t
        result(t) = result(t) + ...
        opady(tp, 2) * ...
        1 / tt * exp (-(t - tp) / tt) * ...
        exp (-lambda * (t - tp));
    end
end
figure(1)
plot(danaj(:, 1), danaj(:, 2), '-' );
hold on;
plot(danaj(:, 1), result, 'ro' );
hold off;
title( 'Charakterystyka modelu i obserwacji dotycz¹ca zawartoœci trytu w Dunaju' );
xlabel( 'Czas [miesi¹ce]' );
ylabel( 'Zawartoœæ trytu (TU)' );
legend( 'Danaj' , 'Opady' );
ylim([0 550]);
grid on;
drawnow; %pause(0.1);
error =  sum((danaj(:, 2) - result').^2);
error_disp = sprintf('Wartoœæ b³êdu wynosi: %10.4f  %', error);
disp(error_disp);

figure(2)
hold on
plot(tt,'gx','Linewidth',2)
%xlabel( 'Brak jednostki, charakterystyka 1-wymiarowa' );
ylabel( 'Amplituda [s]' );
title( 'Charakterystyka spadku wartoœci œredniego czasu przebywania "tt" ' );
 text(1.1, tt, ['Wartoœæ ' num2str(tt, '%10.3f') ' [s]']);
grid on;

figure(3)
hold on
plot(error,'rx','Linewidth',2)
%xlabel( 'Brak jednostki, charakterystyka 1-wymiarowa' );
ylabel( 'Amplituda [TU]' );
title( 'Charakterystyka spadku wartoœci b³êdu' );
text(1.1, error, ['Wartoœæ ' num2str(error, '%10.4f') ' [TU]']);
grid on;
