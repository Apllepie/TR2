function wykresy(nazwa_sys, tk)
    % WYKRESY - Wyświetla dwa wykresy: 
    % wyjście systemu na [0, tk] i trajektorię stanu
    global baza A B C D;
    
    idx = [];
    for i = 1:length(baza)
        if strcmp(baza(i).nazwa, nazwa_sys)
            idx = i;
            break;
        end
    end
    
    if isempty(idx)
        error('Nie znaleziono systemu o nazwie: %s', nazwa_sys);
    end
    
    A = baza(idx).A;
    B = baza(idx).B;
    C = baza(idx).C;
    D = baza(idx).D;
    
    tspan = [0, tk];
    x0 = zeros(size(A, 1), 1);
    
    [t, X] = ode23(@dynamika, tspan, x0);
    
    n_pts = length(t);
    Y = zeros(n_pts, size(C, 1));
    for i = 1:n_pts
        u_val = impuls(t(i));
        Y(i, :) = (C * X(i, :)' + D * u_val)';
    end
    
    figure;
    subplot(2, 1, 1);
    plot(t, Y, 'LineWidth', 1.5);
    grid on;
    title(['Odpowiedź impulsowa systemu: ', nazwa_sys]);
    xlabel('Czas t');
    ylabel('Wyjście y(t)');
    
    subplot(2, 1, 2);
    dim_x = size(A, 1);
    if dim_x == 2
        plot(X(:, 1), X(:, 2), 'LineWidth', 1.5);
        grid on;
        title('Trajektoria w przestrzeni stanów (2D)');
        xlabel('x_1'); ylabel('x_2');
    elseif dim_x == 3
        plot3(X(:, 1), X(:, 2), X(:, 3), 'LineWidth', 1.5);
        grid on;
        title('Trajektoria w przestrzeni stanów (3D)');
        xlabel('x_1'); ylabel('x_2'); zlabel('x_3');
    elseif dim_x > 3
        text(0.5, 0.5, 'dim x > 3', 'FontSize', 14, 'HorizontalAlignment', 'center');
        axis off;
    else
        text(0.5, 0.5, 'dim x < 2', 'FontSize', 14, 'HorizontalAlignment', 'center');
        axis off;
    end
end