function dataToBeEncoded = cf2dataToBeEncoded(complexField)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % complex field 그대로 하되 복소평면에서 0.5+0j 중심 반지름 0.5 안에 위치시킴
    dataToBeEncoded = complexField;
    dataToBeEncoded = dataToBeEncoded/(2*max(abs(dataToBeEncoded(:)))) + 0.5;    % 크기 -0.5~0.5 범위 나옴 거기서 +0.5 => 즉 크기 0.0~1.0 범위 나옴
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 실수부를 취한 후 0 ~ 1 사이로 위치시킴 
    %{
    dataToBeEncoded = real(complexField);
    dataToBeEncoded = dataToBeEncoded - min(dataToBeEncoded(:));
    dataToBeEncoded = dataToBeEncoded/max(dataToBeEncoded(:));
    %}
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 기타 
    % complexField = complexField/max(abs(complexField(:)));
    % dataToBeEncoded = (abs(complexField+1));
    % dataToBeEncoded = angle(complexField)+pi;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end