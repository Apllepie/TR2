function wyszukaj_bd(string)
    % WYSZUKAJ_BD - Wyświetla nazwy systemów zawierających podany ciąg znaków
    global baza;
    
    if isempty(baza)
        disp('Baza danych jest pusta.');
        return;
    end
    
    more on;
    disp(['--- Wyniki wyszukiwania dla ciągu: "', string, '" ---']);
    znaleziono = 0;
    
    for i = 1:length(baza)
        if ~isempty(strfind(baza(i).nazwa, string))
            fprintf('System %d: %s\n', i, baza(i).nazwa);
            znaleziono = znaleziono + 1;
        end
    end
    
    if znaleziono == 0
        disp('Nie znaleziono systemów pasujących do wzorca.');
    end
    more off;
end