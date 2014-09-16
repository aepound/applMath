




h = [12 11 10 9 8 7 6 5 4 3 2 1 0];
t= [nan 0.82 1.46 2.16 3.19 4.4  5.57 6.67 8.09  9.43 11.3  13.49 16.83]; 
t = [t; [nan 1.13 2.34 3.37  4.4 5.65 6.73 8.16 8.72 11.33 13.53 16.78 19.27]];
t = [t;  [1.22 1.98 2.73 3.74 4.92 5.95 6.93 8.55 10.2 12.16 14.07 16.75 nan]]; 
t = [t; [1.06 1.99 3.12 4.22 5.5  6.65 8.02 9.61 11.3 13.31 16.43 18.47 nan]]; 
t = [t; [.79  1.73 2.65 3.84 4.9  6.14 7.32 8.51 10.17 12.2 14.39 17.25 19.91]]; 


T = nanmean(t);

Type2 = @(a,N) a(1)*N./(1+ a(1)*a(2)*N);


g = 9.81; % m/sec
g = g*100; % cm/sec

A = 30.876; % Area of the crosssection of the bottle. cm^2

a = .275; % Area of the hole. cm^2

h0 = h(1);

tt = 0:0.1:20;
h_est = (sqrt(h0) - a/A*sqrt(g/2)*tt).^2;

%a = nlinfit(N,P,Type2,[0 0])

%% Graph the average of the data and the Toricelli's model
figure(4)
clf
plot(tt, h_est)

hold on, plot(T-T(1),h,'r','linewidth',2)
grid on
ylabel('height')
xlabel('time')
legend('Torricelli''s Law','Average data')
