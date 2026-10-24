function xdot = dynamika(t, x)
    % DYNAMIKA - Równanie różniczkowe x_dot = A*x + B*u, gdzie u(t) = impuls(t)
    global A B;
    u = impuls(t);
    xdot = A * x + B * u;
end