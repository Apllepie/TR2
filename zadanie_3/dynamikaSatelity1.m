%% A.4 DYNAMIKA SATELITY
clear all
close all

%% A.4.2 Modelowanie matematyczne

% definiowanie parametrow satelity
T=24*60*60;           % s, okres obrotu Ziemi
m=2;                  % kg
k=4e14;               % m^3/s^2
omega=2*pi/T;         % rad/s
rR=(k/omega^2)^(1/3); % m, promien orbity geostacjonarnej satelity

% definicje typowych sygnalow wejsciowych uzywanych podczas badan symulacyjnych 
% dynamiki satelity
ur=@(t)0; 
uth=@(t)0; 
dr=@(t)0; 
dth=@(t)0;

% tworzenie kodu dla dynamiki satelity (sD)
% x'=f(x,u)
sD=@(t,x)[...
    x(2,:); ...
    -k./(x(1,:).^2) + x(1,:).*(omega+x(4,:)).^2 + (ur(t)+dr(t))./m; ...
    x(4,:); ...
    -2*x(2,:).*(omega+x(4,:))./x(1,:) + (uth(t)+dth(t))./(m*x(1,:).^2) ...
    ];

%% A.4.3 Analiza punktu rownowagi
% weryfikacja wybranych rozwiazan ukladu rownan satelity ze zmiennymi stanu

disp('A.4.3')

x0=[rR;0;0;0];
test1=sD(0,x0);

%% A.4.4 Przyblizenie liniowe
% wyliczanie parametrow A, B, C przyblizenia liniowego
% x'=f(x,u)
% y =h(x,u)
% w punkcie rownowagi

A= ...
[        0,             1, 0,          0; ...
 3*omega^2,             0, 0, 2*omega*rR; ...
         0,             0, 0,          1; ...
         0, -(2*omega)/rR, 0,          0 ...
];

B= [  0,          0,   0,          0; ...
    1/m,          0, 1/m,          0; ...
      0,          0,   0,          0; ...
      0, 1/(m*rR^2),   0, 1/(m*rR^2) ];

C= [0, 0, 1, 0];

% tworzenie kodu dla przyblizenia liniowego (sLD) dynamiki satelity 
% f(x,u) w postaci fl(x,u):=A*x + B*u
sLD=@(t,x) A*x + B*[ur(t); uth(t); dr(t); dth(t)];

%% A.4.5 Analiza modelu
% stabilnosc przyblizenia liniowego
disp('A.4.5')
disp('stability:')
disp('eigenvalues of A')
ev=eig(A)

%% A.4.6 Symulacje
% badania symulacyjne dynamiki satelity

% 0
% system w punkcie rownowagi

% warunki poczatkowe i zaklocenie radialne
x0=[rR;0;0;0]; 
x0L=x0-[rR;0;0;0];

% tworzenie kodu dla dynamiki satelity (sD)
sD=@(t,x)[...
    x(2,:); ...
    -k./(x(1,:).^2) + x(1,:).*(omega+x(4,:)).^2 + (ur(t)+dr(t))./m; ...
    x(4,:); ...
    -2*x(2,:).*(omega+x(4,:))./x(1,:) + (uth(t)+dth(t))./(m*x(1,:).^2) ...
    ];
sLD=@(t,x) A*x + B*[ur(t); uth(t); dr(t); dth(t)];

% symulacja i kreslenie wykresow dla dynamiki satelity (sD)
[ts,ys] = ode45(sD,[0 T],x0);
figure(1)
subplot(2,1,1)
plot(ts,ys)
title("model nieliniowy (punkt rownowagi)")
xlabel("t[s]"), ylabel("x")

% symulacja i kreslenie wykresow dla aproksymacji liniowej dynamiki satelity (sLD)
[tls,yls] = ode45(sLD,[0 T],x0L);
subplot(2,1,2)
plot(tls,yls)
title("aproksymacja liniowa (punkt rownowagi)")
xlabel("t[s]"), ylabel("x")


% 1
% 1%-we zaburzenie r(0) wzgledem promienia orbity geostacjonarnej

% warunki poczatkowe (radialne zaklocenie jest niezmienione)
x0=[rR*1.01;0;0;0]; % warunek poczatkowy dla systemu nieliniowego
x0L=x0-[rR;0;0;0];  % warunek poczatkowy dla aproksymacji liniowej

% ZADANIE 1
[ts,ys]   = ode45(sD,[0 T],x0);
[tls,yls] = ode45(sLD,[0 T],x0L);
figure(2)
subplot(2,1,1)
plot(ts, ys(:,1)-rR, tls, yls(:,1), '--')
title("Zadanie 1: 1%-we zaburzenie r(0) - \Delta r(t) = r(t) - rR")
xlabel("t [s]"), ylabel("\Delta r [m]")
legend("model nieliniowy", "aproksymacja liniowa")

subplot(2,1,2)
plot(ts, ys(:,3), tls, yls(:,3), '--')
title("Zadanie 1: 1%-we zaburzenie r(0) - \phi(t)")
xlabel("t [s]"), ylabel("\phi [rad]")
legend("model nieliniowy", "aproksymacja liniowa")


% 1%-we zaburzenie phi(0) wzgledem pelnego obrotu Ziemi wzgledem swojej osi

% warunki poczatkowe (radialne zaklocenie jest niezmienione)
x0=[rR; 0; 2*pi/100; 0]; % phi znajduje sie na 3. pozycji wektora stanu
x0L=x0-[rR;0;0;0];

% ZADANIE 2
[ts,ys]   = ode45(sD,[0 T],x0);
[tls,yls] = ode45(sLD,[0 T],x0L);
figure(3)
subplot(2,1,1)
plot(ts, ys(:,1)-rR, tls, yls(:,1), '--')
title("Zadanie 2: 1%-we zaburzenie \phi(0) - \Delta r(t) = r(t) - rR")
xlabel("t [s]"), ylabel("\Delta r [m]")
legend("model nieliniowy", "aproksymacja liniowa")

subplot(2,1,2)
plot(ts, ys(:,3), tls, yls(:,3), '--')
title("Zadanie 2: 1%-we zaburzenie \phi(0) - \phi(t)")
xlabel("t [s]"), ylabel("\phi [rad]")
legend("model nieliniowy", "aproksymacja liniowa")


% 2
% radialne zaklocenie skokowe o wartosci 5% grawitacyjnego przyciagania 
% satelity przez ziemie

% warunki poczatkowe i radialne zaklocenie
dr=@(t)(sign(t)+1)*m*9.81/2*0.05;
x0=[rR;0;0;0];
x0L=x0-[rR;0;0;0];

% ZADANIE 3
% tworzenie kodu dla dynamiki satelity (sD) i aproksymacji liniowej (sLD)
sD=@(t,x)[...
    x(2,:); ...
    -k./(x(1,:).^2) + x(1,:).*(omega+x(4,:)).^2 + (ur(t)+dr(t))./m; ...
    x(4,:); ...
    -2*x(2,:).*(omega+x(4,:))./x(1,:) + (uth(t)+dth(t))./(m*x(1,:).^2) ...
    ];
sLD=@(t,x) A*x + B*[ur(t); uth(t); dr(t); dth(t)];

[ts,ys]   = ode45(sD,[0 T],x0);
[tls,yls] = ode45(sLD,[0 T],x0L);
figure(4)
subplot(2,1,1)
plot(ts, ys(:,1)-rR, tls, yls(:,1), '--')
title("Zadanie 3: zaklocenie skokowe - \Delta r(t) = r(t) - rR")
xlabel("t [s]"), ylabel("\Delta r [m]")
legend("model nieliniowy", "aproksymacja liniowa")

subplot(2,1,2)
plot(ts, ys(:,3), tls, yls(:,3), '--')
title("Zadanie 3: zaklocenie skokowe - \phi(t)")
xlabel("t [s]"), ylabel("\phi [rad]")
legend("model nieliniowy", "aproksymacja liniowa")


% 3
% radialne zaklocenie o charakterze okresowym z amplituda rowna 5%  
% grawitacyjnego przyciagania satelity przez Ziemie o okresie rownym okresowi
% obrotu Ziemi

% radialne zaklocenie (warunki poczatkowe sa niezmienione)
dr=@(t)cos(2*pi/T*t)*m*9.81*0.05;
x0=[rR;0;0;0];
x0L=x0-[rR;0;0;0];

% ZADANIE 4
% tworzenie kodu dla dynamiki satelity (sD) i aproksymacji liniowej (sLD)
sD=@(t,x)[...
    x(2,:); ...
    -k./(x(1,:).^2) + x(1,:).*(omega+x(4,:)).^2 + (ur(t)+dr(t))./m; ...
    x(4,:); ...
    -2*x(2,:).*(omega+x(4,:))./x(1,:) + (uth(t)+dth(t))./(m*x(1,:).^2) ...
    ];
sLD=@(t,x) A*x + B*[ur(t); uth(t); dr(t); dth(t)];

[ts,ys]   = ode45(sD,[0 T],x0);
[tls,yls] = ode45(sLD,[0 T],x0L);
figure(5)
subplot(2,1,1)
plot(ts, ys(:,1)-rR, tls, yls(:,1), '--')
title("Zadanie 4: zaklocenie okresowe - \Delta r(t) = r(t) - rR")
xlabel("t [s]"), ylabel("\Delta r [m]")
legend("model nieliniowy", "aproksymacja liniowa")

subplot(2,1,2)
plot(ts, ys(:,3), tls, yls(:,3), '--')
title("Zadanie 4: zaklocenie okresowe - \phi(t)")
xlabel("t [s]"), ylabel("\phi [rad]")
legend("model nieliniowy", "aproksymacja liniowa")