function [wc, NwXout, NwYout] = getWc(Nx,Ny, wType, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jae-Hyeung Park, Inha University
% jh.park@inha.ac.kr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [wc, NwXout, NwYout] = getWc(Nx,Ny, wType, 'NwX',NwX, 'NwY',NwY, 'halfBW',halfBW, 'maxIter',maxIter, 'verbose',verbose)
% wc : weight coffiecnt of Ny x Nx size
% passband of wc is centerered (cx,cy) = ( floor((Nx+1)/2), floor((Ny+1)/2) )
% wType: "Floyd_Steinberg", "Single_Right", "Single_Down",
% "Iterative_Design"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if wType == "Iterative_Design"
%    NwX, NwY, halfBW, maxIter, verbose are required
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wc(cy, cx + (1:NwX))  ---> Non-zero
% wc(cy + (1:NwY),  cx + (-NwX:NwX)) --> Non-zero
% Total number of non-zero coefficient = NwX + (2*NwX+1)*NwY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% input parser
p = inputParser; %��ü�����

validWtype = {'Floyd_Steinberg','Floyd_Steinberg2x', 'Single_Right','Single_Right2x', 'Single_Down', 'Iterative_Deisgn', 'kyosik_cross', 'kyosik_leftupper', 'kyosik_rightupper', 'kyosik_rightupperEX', 'kyosik_rightupperEX2'};
checkWtype = @(x) any(validatestring(x, validWtype)); %x�� validWtype�� ������ 1�� ����ϴ� �Լ� checkWtype('Single_Right') = 1

addRequired(p, 'Nx',@isnumeric); %p��ü�� 'Nx' �׸��� �߰� & isnumeric�Լ�(���ڰ� �ƴϸ�)�� �ǵ��Լ��� �Ἥ ���ڿ� ���� ��� ����
addRequired(p, 'Ny',@isnumeric);
addRequired(p,'wType',checkWtype); %p��ü�� wTyoe �׸��߰� , ���� checkWtyoe�� �ǵ��Լ��� ���

defaultNwX = 1;
defaultNwY = 0;
defaultHalfBW = 10;
defaultMaxIter = 10;
defaultVerbose = 0;

addParameter(p,'NwX', defaultNwX); %NwX , Y �� x or y �������� ������ ������ ����? �హ��? ����
addParameter(p,'NwY', defaultNwY);
addParameter(p,'halfBW', defaultHalfBW);
addParameter(p,'maxIter', defaultMaxIter);
addParameter(p,'verbose', defaultVerbose);

parse(p, Nx,Ny, wType, varargin{:});

%%
Nx = p.Results.Nx;
Ny = p.Results.Ny;
wType = p.Results.wType; % ��� ���� ��?

%%
cx=floor((Nx+1)/2);    cy=floor((Ny+1)/2);
wc = zeros(Ny, Nx);

%%
switch wType
    
    case 'kyosik_cross'        
        wc(cy+1,cx)=1; %���ڰ�
        wc(cy,cx+1)=1;
        wc(cy+1,cx+1)=-1;
               
        NwXout=2; NwYout=2;
        
    case 'kyosik_leftupper'
        wc(cy+1,cx-1)=1;    
        
        NwXout=1; NwYout=1;
        
    case 'kyosik_rightupper'
        wc(cy+1,cx+1)=1;    
        
        NwXout=1; NwYout=1;   
        
    case 'kyosik_rightupperEX'
        wc(cy+1,cx+1)=2;
        wc(cy+2,cx+2)=-1;
        
        NwXout=2; NwYout=2;
        
    case 'kyosik_rightupperEX2'
        wc(cy+1,cx+1)=3;
        wc(cy+2,cx+2)=-3;
        wc(cy+3,cx+3)=1;
        
        NwXout=3; NwYout=3;
    case 'Floyd_Steinberg'
        wc(cy, cx+1) = 7/16;
        wc(cy+1, cx-1) = 3/16;
        wc(cy+1, cx) = 5/16;
        wc(cy+1, cx+1) = 1/16;
        NwXout=1; NwYout=1;
                
    case 'Floyd_Steinberg2x'
        wc(cy, cx+3) = 7/16;
        wc(cy+3, cx-3) = 3/16;
        wc(cy+3, cx) = 5/16;
        wc(cy+3, cx+3) = 1/16;
        NwXout=3; NwYout=3;
    
    case 'Single_Right'
        wc(cy, cx+1) = 1;
        NwXout=1; NwYout=0;
      
    case 'Single_Right2x'
        wc(cy, cx+3) = 1;
        NwXout=3; NwYout=0;
        
    case 'Single_Down'
        wc(cy+1, cx) = 1;
        NwXout=0; NwYout=1;
        
    case 'Iterative_Deisgn'
        NwX = p.Results.NwX;
        NwY = p.Results.NwY;
        halfBW = p.Results.halfBW;
        maxIter = p.Results.maxIter;
        verbose = p.Results.verbose;
        
        if NwX == 0     % 1D
            wc1D = getW1D(Ny, NwY, halfBW, maxIter, verbose);
            wc(:,cx) = wc1D;
        elseif NwY == 0     %1D
            wc1D = getW1D(Nx, NwX, halfBW, maxIter, verbose);
            wc(cy,:) = wc1D;
        else    %2D
            wc = getW2D(Nx, Ny, NwX, NwY, halfBW, maxIter, verbose);
        end
        NwXout=NwX; NwYout=NwY;        
end
end

%%
function wc1D = getW1D(N, Nw, halfBW, maxIter, verbose)
c = floor( (N+1)/2 );

mask = zeros(N,1);
mask(c + (1:Nw))=1;

passBand = c + (-halfBW:halfBW);
wTemp = zeros(N,1);
wTemp(c+1)= 1;
%wTemp(c+1)=2;
%wTemp(c+2)=-1;
error = zeros(maxIter,1);

for iter=1:maxIter
    Hc = W2H(myfft(wTemp));
    %Hc = -1 + fftshift( fft( ifftshift( wTemp )));
    error(iter) = sum(sum(abs(Hc(passBand))));
    Hc(passBand) = 0;
    %wTemp = fftshift(ifft(ifftshift(Hc + 1)));
    wTemp = myifft( H2W(Hc)  );
    wTemp = wTemp.*mask;
    if verbose && mod(iter, 50)==0
        display(['iteration = ',num2str(iter)])
    end
end

if verbose
    figure(); plot(error); title('error vs iteration');
end
wc1D = wTemp;
end

%%
function wc2D = getW2D(Nx, Ny, NwX, NwY, halfBW, maxIter, verbose)

cx=floor((Nx+1)/2);    cy=floor((Ny+1)/2);

mask = zeros(Ny,Nx);
mask(cy, cx+(1:NwX)) = 1;
mask(cy+(1:NwY), cx+(-NwX:NwX)) = 1; %mask ���� cy�࿡�� x�������� NwX��ŭ�� ������ ���� , �״��� cy +NwY�࿡�� x�������� -NwX~NwX��ŭ ����

passBandX = cx + (-halfBW:halfBW); % ?
passBandY = cy + (-halfBW:halfBW);

wcTemp = zeros(Ny,Nx);
wcTemp(cy,cx+1)=1; %default���� �켱 �ٷο� ���� 1��ŭ ���������ϴ� ������
%wcTemp(cy+1,cx)=1;
%%%%%%
%wcTemp(cy,cx+2) = 1;
%wcTemp(cy-1,cx+1)= -1;
%wcTemp(cy+1,cx+1)= -1;
error = zeros(maxIter,1); %iteration �ϴ� ������ ���� ��ȭ �������� error�� ����

for iter=1:maxIter
    Hc = W2H(myfft2(wcTemp));
    %Hc = -1 + fftshift( fft2( ifftshift( wcTemp ))); 
    %W2H(myfft2(wcTemp))�� ��������
    error(iter) = sum(sum(abs(Hc(passBandY, passBandX))));
    Hc(passBandY, passBandX) = 0;
    wcTemp = myifft2( H2W(Hc) );
    %wcTemp = fftshift(ifft2(ifftshift(Hc+1)));
    wcTemp = wcTemp.*mask;

    if verbose && mod(iter, 50)==0
        display(['iteration = ',num2str(iter)])
    end
end
if verbose
    figure(); plot(error); title('error vs iteration');
end
wc2D = wcTemp;
end



