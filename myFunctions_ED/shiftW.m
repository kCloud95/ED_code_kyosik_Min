function wout = shiftW(win, shiftX, shiftY)
[Ny, Nx] = size(win);
[xx, yy] = meshgrid( (1:Nx)-(Nx+1)/2, (1:Ny)-(Ny+1)/2 );
wout = win.*exp(1j*2*pi*( (shiftX/Nx)*xx + (shiftY/Ny)*yy ));
end