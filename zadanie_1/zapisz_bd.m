function zapisz_bd(nazwa_pliku)
    % ZAPISZ_BD - Zapisuje zawartość bazy danych do pliku ASCII
    global baza;
    
    fid = fopen(nazwa_pliku, 'w');
    if fid == -1
        error('Nie można utworzyć pliku do zapisu: %s', nazwa_pliku);
    end
    
    for i = 1:length(baza)
        fprintf(fid, '%s\n', baza(i).nazwa);
        fprintf(fid, '%s\n', mat2str(baza(i).A));
        fprintf(fid, '%s\n', mat2str(baza(i).B));
        fprintf(fid, '%s\n', mat2str(baza(i).C));
        fprintf(fid, '%s\n', mat2str(baza(i).D));
    end
    
    fclose(fid);
    disp(['Zapisano bazę danych do pliku: ', nazwa_pliku]);
end