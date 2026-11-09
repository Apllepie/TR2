%% SKRYPT: temperatura.m - Regulacja temperatury pomieszczenia
clear all; close all;

%% 1. Definicja parametrów systemu
beta1 = 0.1; 
a1 = 0.5; a2 = 1.0; a3 = 0.1; a4 = 0.2; 
gamma1 = 0.7; gamma2 = 0.05;

% Budowa macierzy na podstawie równania (5)
A = [-a1, 0, 0;
    a2, -(a2+a3), a3;
    0, a4, -a4];
B1 = [beta1; 0; 0];
B2 = [a1; 0; 0];
C = [0, -gamma2, gamma1];

% Pomocnicza macierz wyjścia, gdy chcemy obserwować Tp (Tp to pierwszy stan x1)
C_Tp = [1, 0, 0];

tk = 100; % Czas symulacji

% Definicja skoku jednostkowego
skok_jednostkowy = @(t) double(t >= 0);
zero_in = @(t) zeros(size(t));;

%% CZĘŚĆ 2: Brak sterowania (u = 0), To - skok jednostkowy
disp('--- Symulacja Część 2: Brak sterowania ---');
x0_cz2 = [0; 0; 0];

% Badanie reakcji wielkości pomiarowej h
sys_cz2_h = SystemDynamiczny('Cz 2: h (reakcja odwrotna)', A, B2, C, 0, skok_jednostkowy);
figure(1);
sys_cz2_h.dsplots(tk, x0_cz2);

% Badanie reakcji samej temperatury Tp (żeby zobaczyć stany)
sys_cz2_Tp = SystemDynamiczny('Cz 2: Temperatury Tp, Tsz, THg', A, B2, C_Tp, 0, skok_jednostkowy);
figure(2);
sys_cz2_Tp.dsplots(tk, x0_cz2);

%% CZĘŚĆ 3: Sprzężenie zwrotne proporcjonalne, To=0, Tp(0)=1 (TEST KILKU Kp)
disp('--- Symulacja Część 3: Regulator P (Test różnych Kp) ---');
x0_cz3 = [1; 0; 0];

% Testujemy 3 różne wartości: małe, średnie (optymalne) i duże wzmocnienie
Kp_wartosci = [-0.5, -5, -20]; 
kolory = {'r', 'b', 'k'}; % czerwony, niebieski, czarny do wykresów

figure(3);
hold on; grid on;

for i = 1:length(Kp_wartosci)
    Kp = Kp_wartosci(i);

    % Wyliczenie nowej macierzy dla danego Kp
    A_bar = A + B1 * Kp * C; 

    % Tworzymy tymczasowy obiekt tylko po to, by wyciągnąć trajektorię
    sys_temp = SystemDynamiczny(['Temp Kp=', num2str(Kp)], A_bar, B1*0, C_Tp, 0, zero_in);

    % Pobieramy dane z metody trajektoria (nie używamy dsplots, by narysować to na 1 wykresie)
    [x, y, u, t] = sys_temp.trajektoria(tk, x0_cz3);

    % Rysujemy temperaturę Tp (czyli y)
    plot(t, y, kolory{i}, 'LineWidth', 1.5, 'DisplayName', ['Kp = ', num2str(Kp)]);
end

title('Wpływ wartości Kp na regulację temperatury Tp');
xlabel('Czas t');
ylabel('Temperatura Tp');
legend('show');
%% CZĘŚĆ 4: Sprzężenie P na zakłócenie (To=skok)
disp('--- Symulacja Część 4: Regulator P (To skok) ---');
x0_cz4 = [0; 0; 0];

sys_cz4 = SystemDynamiczny('Cz 4: Regulator P (To = skok)', A_bar, B2, C_Tp, 0, skok_jednostkowy);
figure(4);
sys_cz4.dsplots(tk, x0_cz4);

%% CZĘŚĆ 5: Regulator PI - kompensacja uchybu
disp('--- Symulacja Część 5: Regulator PI ---');
Ki = -2; % Wzmocnienie całkujące (do eksperymentowania)

% Tworzymy macierze rozszerzone (A_tilde, B_tilde, K_tilde itd.)
A_tilde = [A, zeros(3,1); 
    C, 0];
B1_tilde = [B1; 0];
B2_tilde = [B2; 0];
K_tilde = [Kp*C, Ki];

A_hat = A_tilde + B1_tilde * K_tilde;
B_hat = B2_tilde;
C_hat = [C_Tp, 0]; % Interesuje nas wyjście układu (Tp)

x0_cz5 = [0; 0; 0; 0]; % Rozszerzony wektor (dodany z=0)

sys_cz5 = SystemDynamiczny(['Cz 5: Regulator PI (Ki=', num2str(Ki), ')'], A_hat, B_hat, C_hat, 0, skok_jednostkowy);
figure(5);
sys_cz5.dsplots(tk, x0_cz5);