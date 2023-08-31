function [wout, NwXout, NwYout] = scaleW(win, NwXin, NwYin, scaleX, scaleY)
% scaleX, scaleY = integer

[Ny, Nx] = size(win);
cx = floor( (Nx+1)/2 );
cy = floor( (Ny+1)/2 );

NwXout = NwXin*scaleX;
NwYout = NwYin*scaleY;

%% interpolation -- 문제 있는 듯
%{
wcropin = win(cy + (0:NwYin), cx + (-NwXin:NwXin));

xx = 0:2*NwXin;
yy = 0:NwYin;

xxi = (0:2*NwXout) / scaleX;
yyi = (0:NwYout) / scaleY;

if NwXin==0
    wcropout = interp1(yy, wcropin, yyi);
elseif NwYin==0
    wcropout = interp1(xx, wcropin, xxi);
else
    wcropout = interp2(xx, yy, wcropin, xxi, yyi);
end
wout = zeros(Ny, Nx);
wout(cy + (0:NwYout), cx + (-NwXout:NwXout)) = wcropout/scaleX/scaleY;
%}
%% 0을 사이사이 넣기
wout = zeros(size(win));
for idxY=0:NwYin
    for idxX=-NwXin:NwXin
        wout( cy + idxY*scaleY, cx + idxX*scaleX ) = win( cy+idxY, cx + idxX);
    end
end


end