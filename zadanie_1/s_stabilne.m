function s_stabilne
    % S_STABILNE - Wyświetla nazwy systemów, które są asymptotycznie stabilne
    global baza;
    
    if isempty(baza)
        disp('Baza danych jest pusta.');
        return;
    end
    
    more on;
    disp('--- Systemy asymptotycznie stabilne ---');
    stabilne_count = 0;
    
    for i = 1:length(baza)
        lambda = eig(baza(i).A);
        if all(real(lambda) < 0)
            fprintf('System %d: %s (stabilny)\n', i, baza(i).nazwa);
            stabilne_count = stabilne_count + 1;
        end
    end
    
    if stabilne_count == 0
        disp('Brak systemów asymptotycznych stabilnych w bazie.');
    end
    more off;
end