function dz = spaceshipcontrol(t,z,params)

m = params.m;
M = params.M;
G = params.G;
I = params.I;

% control
F = 1000;
tau = 0;

dz = zeros(6,1);

dz(1) = z(2);
dz(2) = -G*M*z(1)/(z(1)^2+z(3)^2)^(3/2) + F*cos(z(5))/m;
dz(3) = z(4);
dz(4) = -G*M*z(3)/(z(1)^2+z(3)^2)^(3/2) + F*sin(z(5))/m;
dz(5) = z(6);
dz(6) = tau/I;
end