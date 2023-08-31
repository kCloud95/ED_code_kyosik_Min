function binaryEncoded = errorDiffusion(dataToBeEncoded, wp, NwX, NwY, threshold)
    
    [Ny,Nx] = size(dataToBeEncoded);
    cx=floor((Nx+1)/2); cy = floor((Ny+1)/2);

    binaryEncoded = zeros(Ny,Nx);
    for iy=1:Ny-NwY
    %for iy=1+NwY:Ny-NwY
        for ix=1+NwX:Nx-NwX
            binaryEncoded(iy,ix)=binarize(dataToBeEncoded(iy,ix), threshold);
            error = dataToBeEncoded(iy,ix) - binaryEncoded(iy,ix);
            
            for iwy=0:NwY
                for iwx=-NwX:NwX
                    %dataToBeEncoded(iy+iwy, ix+iwx) = dataToBeEncoded(iy+iwy, ix+iwx) + wp(cy+iwy, cx+iwx)*error;
                    dataToBeEncoded(iy+iwy, ix+iwx) = dataToBeEncoded(iy+iwy, ix+iwx) + wp(cy+iwy, cx+iwx)*error;
                end
            end
        end
    end
end