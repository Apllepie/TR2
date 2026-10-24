function wczytaj_p(nazwa_pliku)
    % WCZYTAJ_P - Wczytuje parametry systemów dynamicznych z pliku ASCII
    global baza;
    
    fid = fopen(nazwa_pliku, 'r');
    if fid == -1
        error('Nie można otworzyć pliku: %s', nazwa_pliku);
    end
    
    while ~feof(fid)
        nazwa = fgetl(fid);
        if ~ischar(nazwa) || isempty(strtrim(nazwa))
            break;
        end
        nazwa = strtrim(nazwa);
        
        sA = fgetl(fid);
        sB = fgetl(fid);
        sC = fgetl(fid);
        sD = fgetl(fid);
        
        A = eval(sA);
        B = eval(sB);
        C = eval(sC);
        D = eval(sD);
        
        nowy_sys.nazwa = nazwa;
        nowy_sys.A = A;
        nowy_sys.B = B;
        nowy_sys.C = C;
        nowy_sys.D = D;
        
        if isempty(baza)
            baza = nowy_sys;
        else
            baza(end+1) = nowy_sys;
        end
    end
    
    fclose(fid);
    disp(['Wczytano bazę danych z pliku: ', nazwa_pliku]);
end