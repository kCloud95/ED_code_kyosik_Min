function f = myifft2(F)
f = fftshift( ifft2( ifftshift( F )));
end