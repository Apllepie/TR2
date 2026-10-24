function w = impuls(t)
    % IMPULS - Reprezentuje matematyczną funkcję impuls(t)
    sigma = 0.005;
    w = (1 / sqrt(2 * pi * sigma^2)) * exp(-t.^2 / (2 * sigma^2));
end