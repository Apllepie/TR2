function sortuj_N(macierz_typ)
    % SORTUJ_N - Wyświetla nazwy systemów według rosnących wartości normy ||macierz||_2
    global baza;
    
    if isempty(baza)
        disp('Baza danych jest pusta.');
        return;
    end
    
    n = length(baza);
    normy = zeros(n, 1);
    
    for i = 1:n
        switch upper(macierz_typ)
            case 'A', M = baza(i).A;
            case 'B', M = baza(i).B;
            case 'C', M = baza(i).C;
            case 'D', M = baza(i).D;
            otherwise, error('Nieznany typ macierzy. Wybierz A, B, C lub D.');
        end
        normy(i) = norm(M, 2);
    end
    
    [~, indeksy] = sort(normy);
    
    more on;
    fprintf('--- Systemy posortowane według rosnących norm macierzy %s ---\n', upper(macierz_typ));
    for i = 1:n
        idx = indeksy(i);
        fprintf('System: %s | Norma ||%s||_2 = %g\n', baza(idx).nazwa, upper(macierz_typ), normy(idx));
    end
    more off;
end