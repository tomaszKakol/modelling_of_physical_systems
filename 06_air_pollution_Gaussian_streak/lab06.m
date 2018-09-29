close all;clear all; clc

%% sta³e
H = 260; 
Ep = 3211.80; 
SRA = {'silnie chwiejna', 'chwiejna', ...
    'lekko chwiejna', 'obojêtna', 'lekko sta³a', 'sta³a'}; % Stan równowagi atmosfery (sprawozdanie Tab.1)
Uax = [1, 1, 1, 1, 1, 1;
             3, 5, 8, 11, 5, 4]; % Zakres prêdkoœci wiatru Uax [m/s] (sprawozdanie Tab.1)
m = [0.080, 0.143, 0.196, 0.270, 0.363, 0.440]; % sta³a = wartoœæ dla n-tego stanu równowagi atmosfery
a = [0.888, 0.865, 0.845, 0.818, 0.784, 0.756];
b = [1.284, 1.108, 0.978, 0.822, 0.660, 0.551];
Zo = 0.7988; 
Kapitol = 37940; 

%% inicjalizacja zmiennych dla najwiêkszych wartoœci stê¿eñ py³u zawieszonego PM2.5
max_PM_SRA = 0;
max_PM_Kapitol = 0;
max_PM_Uax = 0;
Sx =zeros(1,Kapitol);
 for wind=1:size(Uax,1)
     if(wind==2)
         figure(2) 
     end
for SA = 1:length(SRA)
   
        u = Uax(wind,SA) * (H/14)^(m(SA));
        A = 0.088*(6*power(m(SA),-0.3)+1-log(H/Zo)); 
        B = power(0.38*m(SA),1.3)*(8.7-log(H/Zo)); 
        for x=1:Kapitol
             sy = A*power(x,a(SA)); 
             sz = B*power(x,b(SA)); 
             Sx(x) = 1000*Ep*exp(-power(H,2)/(2*power(sy,2))) / (2*pi*u*sy*sz); 
             end
        
        % obliczanie maksymalnego stê¿enia w punkcie MS
        if Sx(Kapitol) > max_PM_Kapitol
            max_PM_Kapitol = Sx(Kapitol);
            max_PM_Uax = Uax(wind,SA);
            max_PM_SRA = SA;
            max_PM_SRA_2 = SRA{SA};
        end
  if(wind== 1)
      figure(1)
  end
  hold on
       subplot(6,wind,SA)
        plot(Sx)
        title(['Stan równowagi atmosfery: "',num2str(SA), ...
            ' - ', SRA{SA}, ...
            '", Prêdkoœæ wiatru: ', num2str(Uax(wind,SA)), ' [m/s]'])
        xlabel('Odleg³oœæ od emitora [m]')
        ylabel('PM 2.5 [ug/m^3]')
    end
 
end

dispPM_Kapitol = sprintf('Maksymalna wartoœæ PM 2.5 dla Kapitolu wynosi: %4.4f [ug/m^3] \n', max_PM_Kapitol);
disp(dispPM_Kapitol);
dispPM_Uax = sprintf('- pkt.1:  Zakresu prêdkoœci wiatru: %1.0f [m/s] ,', max_PM_Uax);
disp(dispPM_Uax);
dispPM_SRA = sprintf('- pkt.2: Stanu równowagi atmosfery: "%1.0f - %s"', max_PM_SRA, SRA{SA});
disp(dispPM_SRA); 


