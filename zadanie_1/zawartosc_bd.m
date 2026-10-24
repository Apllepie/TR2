function zawartosc_bd
    % ZAWARTOSC_BD - Wyświetla na ekranie (ze stronicowaniem) nazwy wszystkich systemów w bazie
    global baza;
    
    if isempty(baza)
        disp('Baza danych jest pusta.');
        return;
    end
    
    more on;
    disp('--- Zawartość bazy danych systemów dynamicznych ---');
    for i = 1:length(baza)
        fprintf('System %d: %s\n', i, baza(i).nazwa);
    end
    more off;
end