%% Æwiczenie 2: Symulacja transportu ciep³a. 12.03.2018
close all; clear all; clc;
%% dane
a = 0.2;               %m
b = 0.1;               %m
c = 0.05;             %m
d = 0.04;            %m
h = 0.002;         %m

N = 40;               %iloœæ wêzlów
Nt = N*20;         %iloœæ kroków czasowych
NX = N;             % iloœæ odcinków przestrzennych mw kierunku x
NY = NX;
delta_x = a/N;      %m
delta_y = delta_x;
delta_t = 0.002;        %s

% Material = Gêstoœæ | Ciep³o w³aœciwe | wspólczynnik przewodzenia 
Aluminium = [2700, 900, 237];
Miedz= [8920, 380, 401];
Stal = [7860, 450, 58];

% Warunki brzegowe 1
t_krawedzi = 10; %st.C
t_poczatkowa = 20;
t_grzalki = 80;

%% rozwi¹zanie
%OX brzeg
ob = zeros(N+1,N+1);
ob(1,                  1:N) = 10;
ob(N,                 (c*N/a+1) : (N - c*N/a) ) = 10;
ob((1+d*N/a),   1:c*N/a) = 10;
ob((1+d*N/a),   (N+1 - c*N/a):N) = 10;
%OY brzeg
ob((1:(1+ d*N/a)),      1) = 10;
ob((1:(1+ d*N/a)) ,     N) = 10;
ob((1+d*N/a):N,         1 + c*N/a) = 10;
ob((1+d*N/a):N,         (N - c*N/a)) = 10;

%grza³ka
ob(((1+ d*N/a/2) : ((d*N/a + d*N/a/2 ))),(1+(c*N/a) + ((b-d)*N/a/2) ): ((c*N/a) + ((b-d)*N/a/2)+ d*N/a)) = 80;
ob_grzalki = ob(((1+ d*N/a/2) : ((d*N/a + d*N/a/2 ))),(1+(c*N/a) + ((b-d)*N/a/2) ): ((c*N/a) + ((b-d)*N/a/2)+ d*N/a)) ;
ob_grzalki_pocz_x= 1+ d*N/a/2 ;
ob_grzalki_koniec_x= d*N/a + d*N/a/2 ;
ob_grzalki_pocz_y= 1+(c*N/a) + ((b-d)*N/a/2) ;
ob_grzalki_koniec_y= (c*N/a) + ((b-d)*N/a/2)+ d*N/a;

figure(1)
surf(ob(:,:))
 axis([0 NX+1 0 NY+1 0 t_grzalki+20]);
 title('Symulacja transferu ciep³a, warunki pocz¹tkowe.');
xlabel( 'x (cm)' );
ylabel( 'y (cm)' );
zlabel( 'temperatura (stC)' );

%%
x1_1 =  c*N/a;
y1_1 = N - c*N/a;
y2_1 = N+1 - c*N/a;%
y2_2 =N;

rezultat = zeros (N+1,N+1) + t_poczatkowa;% lub t_krawedzi (ustawiamy warunki pocz¹tkowe pomiêdzy krawêdziami i grza³k¹)
for i = 1:N
    for j = 1:N
        if  i == N &&  j>= 1 && j < x1_1 ...
             || i > x1_1   && i <= N && j > y1_1 +1 && j<= N ...
             || i > x1_1 && i <= N && j > 0 && j< x1_1 
             rezultat( i , j ) = 0;
        elseif i == 1 ...
               || i == N && j > x1_1 && j<= y1_1 ...
               || i ==x1_1 && j>= 1 && j <= x1_1 ...
               || i ==x1_1 && j> y1_1  && j<=y2_2 ...
               || j==1 && i>=1 && i<= x1_1 ...
               || j==N && i>=1 && i<=x1_1 ...
               || j == x1_1 && i>=x1_1 &&i <=N ...%
               || j == y2_1 && i>=x1_1  &&i <=N
           rezultat( i , j )  = t_krawedzi;
        elseif i >= ob_grzalki_pocz_x && i <= ob_grzalki_koniec_x  && j >= ob_grzalki_pocz_y && j <= ob_grzalki_koniec_y
            rezultat ( i , j ) = t_grzalki ;
        end
    end
end

figure(2)
surf(rezultat(:,:))
 axis([0 NX+1 0 NY+1 0 t_grzalki+20]);
  title('Symulacja transferu ciep³a, warunki pocz¹tkowe.');
xlabel( 'x (cm)' );
ylabel( 'y (cm)' );
zlabel( 'temperatura (stC)' );
grid on

%%
figure(3);
material = Miedz;
progStabilnosci = 0.0001;
czas_rys = 100;
for n = 1:Nt
    zmiana = 0;
    ostatniPomiar = rezultat;
    for i = 2:(N)
        for j = 2:(N)
          if ~( i >= ob_grzalki_pocz_x && i <= ob_grzalki_koniec_x && j >= ob_grzalki_pocz_y && j <= ob_grzalki_koniec_y)
            rezultat( i , j ) = ostatniPomiar( i , j ) ...
            + (material(3) * delta_t ) / (material(2) * material(1) * delta_x ^2) ...
            * (ostatniPomiar( i + 1, j ) - 2*ostatniPomiar( i , j ) + ostatniPomiar( i - 1, j )) ...
            + (material(3) * delta_t ) / (material(2) * material(1) * delta_y ^2) ...
            * (ostatniPomiar( i , j + 1) - 2*ostatniPomiar( i , j ) + ostatniPomiar( i , j - 1));
            zmiana = zmiana + abs (rezultat( i , j ) - ostatniPomiar( i , j ));
          end
         % problemem s¹ wartoœci graniczne i obszar nie nale¿¹cy do figury 
           if  i == N &&  j>= 1 && j < x1_1 ...
                     || i > x1_1   && i <= N && j > y1_1 +1 && j<= N ...
                     || i > x1_1 && i <= N && j > 0 && j< x1_1 
                     rezultat( i , j ) = 0;
                elseif i == 1 ...
                       || i == N && j > x1_1 && j<= y1_1 ...
                       || i ==x1_1 && j>= 1 && j <= x1_1 ...
                       || i ==x1_1 && j>= y2_1 && j<=y2_2 ...
                       || j==1 && i>=1 && i<= x1_1 ...
                       || j==N && i>=1 && i<=x1_1 ...
                       || j == x1_1 && i>=x1_1 &&i <=N ...%
                       || j == y2_1 && i>=x1_1  &&i <=N
                   rezultat( i , j )  = t_krawedzi;
           end
          
        end
    end
    if zmiana < progStabilnosci
        break ;
    end

    czas_rys = czas_rys + 1;
  %  if czas_rys > 100 || n == Nt
      %  czas_rys = 0;
        surf(rezultat);
        title(sprintf( 'Czas symulacji: %0.2f (s)' , n * delta_t ));
        xlabel( 'x (cm)' );
        ylabel( 'y (cm)' );
        zlabel( 'temperatura (stC)' );
      %  pause(0.05);
  %  end
end
 
mean(mean(rezultat,2),1)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 


