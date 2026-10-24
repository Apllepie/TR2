function wczytaj_k
    % WCZYTAJ_K - Umożliwia dołączanie nowego systemu dynamicznego z klawiatury
    global baza;
    
    nazwa = input('Podaj nazwę systemu: ', 's');
    sA = input('Podaj macierz A (np. [-2 -1; 1 0]): ');
    sB = input('Podaj macierz B: ');
    sC = input('Podaj macierz C: ');
    sD = input('Podaj macierz D: ');
    
    nowy_sys.nazwa = nazwa;
    nowy_sys.A = sA;
    nowy_sys.B = sB;
    nowy_sys.C = sC;
    nowy_sys.D = sD;
    
    if isempty(baza)
        baza = nowy_sys;
    else
        baza(end+1) = nowy_sys;
    end
    
    disp('System został pomyślnie dodany do bazy.');
end