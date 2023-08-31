function F = myfft2(f)
F = fftshift( fft2( ifftshift( f )));
end