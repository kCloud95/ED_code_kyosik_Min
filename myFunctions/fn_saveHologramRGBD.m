 function fn_saveHologramRGBD(rgb, depthMap, wavelength, px, py, Nx,Ny, rangeFxIdx, rangeFyIdx, dirName)
if ~exist(dirName,'dir') 
    mkdir(dirName);
end

allDepth = unique(depthMap); 
[xx,yy] = meshgrid( ((1:Nx)-Nx/2)*px, (Ny/2-(1:Ny))*py );

dfx=1/(Nx*px); dfy=1/(Ny*py);
[fx,fy] = meshgrid( ((1:Nx)-(Nx+1)/2)*dfx, ((Ny+1)/2-(1:Ny))*dfy );

%%
minFxIdx=rangeFxIdx(1); maxFxIdx=rangeFxIdx(2); stepFxIdx=rangeFxIdx(3); 
minFyIdx=rangeFyIdx(1); maxFyIdx=rangeFyIdx(2); stepFyIdx=rangeFyIdx(3); 

for cuFxIdx = minFxIdx : stepFxIdx : maxFxIdx
    for cuFyIdx = minFyIdx : stepFyIdx : maxFyIdx
        cuX = fx(cuFyIdx,cuFxIdx)*wavelength; % alpha_x
        cuY = fy(cuFyIdx,cuFxIdx)*wavelength; % beta_y direction cosines
        cuZ = real(sqrt(1 - cuX^2 - cuY^2));
        if cuZ < 0
            disp('cuZ is negative! Check cuX and cuY')
        end
        cu = [cuX, cuY, cuZ];
        hologram = zeros(Ny,Nx);
        for idxDepth = 1:length(allDepth)
            z = allDepth(idxDepth);
            layer = rgb.*(depthMap==z);
            zo = z;
            carrierPhase = exp(1j*2*pi/wavelength*(cu(1)*xx + cu(2)*yy + cu(3)*zo)); 
            layer = layer.*carrierPhase;
            [hologram_temp,~] = FresnelPropagation_as(layer, px, py, -zo, wavelength);
            hologram = hologram + hologram_temp;
        end
        fileName = [dirName,'/hologram_cuFxIdx',num2str(cuFxIdx),'_cuFyIdx',num2str(cuFyIdx)];
        save(fileName,'hologram')
    end
end

