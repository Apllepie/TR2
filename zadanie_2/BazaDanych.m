classdef BazaDanych < handle
% BAZADANYCH - klasa reprezentuje baze danych dla systemow dynamicznych
% ze zmiennymi stanu, ktore sa liniowe, stacjonarne, SISO

    properties
        DaneNazwaPliku="noFile.txt";
        Dane=SystemDynamiczny;
        count=0;
    end

    methods
        function obj = BazaDanych(bdNazwaPliku)
            % BAZADANYCH jest konstruktorem parametrycznym dla tej klasy
            %   bdNazwaPliku - nazwa pliku z baza systemow dynamicznych
            if nargin==1
                obj.DaneNazwaPliku = bdNazwaPliku;
                [fid,message]=fopen(obj.DaneNazwaPliku,'r');
                if fid==-1
                    disp(message);
                else
                    obj.count=0;
                    while feof(fid) == 0
                     nazwa=fgetl(fid);
                     A=eval(fgetl(fid));
                     B=eval(fgetl(fid));
                     C=eval(fgetl(fid));
                     D=eval(fgetl(fid));
                     system=SystemDynamiczny(nazwa,A,B,C,D,...
                         @(t)exp(-t.^2/(2*0.1^2))/(0.1*sqrt(2*pi)));
                     obj.count=obj.count+1;
                     obj.Dane(obj.count)=system;
                    end
                st=fclose(fid);
                end
            end
        end

        function wyszukaj_BD(obj,string)
	% WYSZUKAJ_BD(string) - metoda, ktora wyswietla na ekranie 
	% nazwy wszystkich systemow w bazie danych, zawierajacych 
        % w sobie ciag znakow string.
        if obj.count == 0
                disp('Baza danych jest pusta.');
                return;
            end
            disp(['--- Wyniki wyszukiwania dla: ', string, ' ---']);
            for ind = 1:obj.count
                if contains(obj.Dane(ind).nazwa, string)
                    fprintf('Znaleziono: %s\n', obj.Dane(ind).nazwa);
                end
            end
        end

        function sortuj_N(obj,macierz)
	% SORTUJ_N('matrix') - metoda, ktora wyswietla na ekranie 
        % nazwy systemow z bazy danych wedlug rosnacych wartosci 
        % ||macierz||_2, gdzie macierz przyjmuje wartosci ze zbioru
	% {'A', 'B', 'C', 'D'}.
            if obj.count > 0
                for ind=1:obj.count
                    normM(ind)=norm(eval(['obj.Dane(ind).',macierz]),2);  
                end    
                while any(normM >= 0)
                    aux=find(normM == max(normM));
                    fprintf('%s\t%f\n', obj.Dane(aux(1)).nazwa, normM(aux(1)) );
                    normM(aux(1))=-1;
                end
            else
                fprintf('baza danych jest pusta\n');
            end
        end
        
        function s_stabilne(obj)
	    % S_STABILNE - metoda, ktora wyswietla na ekranie nazwy 
	    % systemow z bazy danych, ktore sa asymptotycznie stabilne.
           if obj.count == 0
                disp('Baza danych jest pusta.');
                return;
            end
            more on;
            disp('--- Systemy asymptotycznie stabilne ---');
            stabilne_count = 0;
            for i = 1:obj.count
                lambda = eig(obj.Dane(i).A); % Poprawiony odczyt macierzy A konkretnego systemu
                if all(real(lambda) < 0)
                     fprintf('System %d: %s (stabilny)\n', i, obj.Dane(i).nazwa);
                     stabilne_count = stabilne_count + 1;
                end
            end
            if stabilne_count == 0
                disp('Brak układów stabilnych.');
            end
            more off;
        end

        function wykresy(obj, nazwa, tk)
	    % WYKRESY  - metoda, ktora wyswietla rysunek z dwoma
	    % wykresami, jeden nad drugim. Pierwszy wykres przedstawia
	    % wyjscie systemu nazwa na przedziale czasu [0,tk] przy zalozeniu
	    % zerowych warunkow poczatkowych i pobudzeniu impulsowym.
	    % Drugi, dolny wykres, przedstawia trajektorie w przestrzeni stanu,
	    % o ile liczba zmiennych stanu jest rowna 2 lub 3. Jezeli ten
	    % warunek nie jest spelniony to w miejscu dolnego wykresu powinien
	    % sie pojawic komunikat o tresci: dim x > 0 lub dim x < 2
								      
            if obj.count > 0
                indf=0;
                for ind=1:obj.count
                    if ~isempty(strmatch(nazwa, obj.Dane(ind).nazwa))
                        indf=indf+1; figure(indf);
                        n=size(obj.Dane(ind).A,1); x0=zeros(n,1);
                        [x,y,u,t]=obj.Dane(ind).trajektoria(tk, x0);   
                        subplot(211); ...
                            plot(t,y), grid on, ...
                            xlabel('t'), ylabel('y'), ...
                            title(obj.Dane(ind).nazwa);
                        m=size(obj.Dane(ind).A,1);
                        if m==3
                            subplot(212); ...
                                plot3(x(:,1)',x(:,1)', x(:,1)'), ...
                                grid on, ...
                                xlabel('x_1'),ylabel('x_2'),zlabel('x_3');
                        else if m==2
                            subplot(212); ...
                                plot(x(:,1)',x(:,2)'), grid on, ...
                                xlabel('x_1'),ylabel('x_2');
                            else if m==1
                                    subplot(212); ...
                                        text(0.5,0.5,'dim x<2');
                                else
                                    subplot(212); ...
                                        text(0.5,0.5,'dim x>3');
                                end
                            end
                        end
                    end
                end
            end
        end

        function zapisz_bd(obj, nazwa_pliku)
	    % ZAPISZ_BD(nazwa_pliku) - metoda, ktora zapiszuje zawartosc 
            % bazy danych na pliku typu ASCII 
            fid = fopen(nazwa_pliku, 'w');
            if fid == -1
                error('Nie można utworzyć pliku.');
            end
            for ind = 1:obj.count
                fprintf(fid, '%s\n', obj.Dane(ind).nazwa);
                fprintf(fid, '%s\n', mat2str(obj.Dane(ind).A));
                fprintf(fid, '%s\n', mat2str(obj.Dane(ind).B));
                fprintf(fid, '%s\n', mat2str(obj.Dane(ind).C));
                fprintf(fid, '%s\n', mat2str(obj.Dane(ind).D));
            end
            fclose(fid);
            disp(['Zapisano do pliku: ', nazwa_pliku]);
        end

        function zawartosc_bd(obj)
	    % ZAWARTOSC_BD - metoda, ktora wyswietla na ekranie  
            % nazwy wszystkich systemow dynamicznych przechowywanych
	    % w bazie danych

            %more on;
            for ind=1:obj.count
                fprintf('%s\n', obj.Dane(ind).nazwa);
            end
            %more off;
        end

        function wczytaj_k(obj)
	    % WCZYTAJ_K - metoda, ktora umozliwia dolaczenie nowego systemu 
            % dynamicznego do bazy danych przy uzyciu klawiatury
            nazwa_s = input('Podaj nazwę systemu: ', 's');
            sA = input('Podaj macierz A (np. [-1 0; 0 -2]): ');
            sB = input('Podaj macierz B: ');
            sC = input('Podaj macierz C: ');
            sD = input('Podaj macierz D: ');
            
            % Konstrukcja nowego obiektu i dodanie do bazy
            nowy = SystemDynamiczny(nazwa_s, sA, sB, sC, sD, @(t)0);
            obj.count = obj.count + 1;
            obj.Dane(obj.count) = nowy;
            disp('Dodano system pomyślnie.');
        end
        
        function wczytaj_P(obj,nazwaPliku)
	    % WCZYTAJ_P(nazwaPliku) - metoda, ktora z pliku nazwaPliku,
	    % typu ASCII, wczytuje parametry systemow dynamicznych i przypisuje
	    % je odpowiednim polom zmiennej obj.Dane.
				
            obj.DaneNazwaPliku=nazwaPliku;
            [fid,message]=fopen(obj.DaneNazwaPliku,'r');
            if fid==-1
                disp(message);
            else
                while feof(fid) == 0
                    obj.count=obj.count+1;
                    obj.Dane(obj.count).nazwa=fgetl(fid);
                    obj.Dane(obj.count).A=eval(fgetl(fid));
                    obj.Dane(obj.count).B=eval(fgetl(fid));
                    obj.Dane(obj.count).C=eval(fgetl(fid));
                    obj.Dane(obj.count).D=eval(fgetl(fid));
                    obj.Dane(obj.count).u=@(t)exp(-t.^2/(2*0.1^2))/(0.1*sqrt(2*pi));
                end
            st=fclose(fid);
            end
        end
    end
end
