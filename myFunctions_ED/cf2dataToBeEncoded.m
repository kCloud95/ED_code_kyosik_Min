function dataToBeEncoded = cf2dataToBeEncoded(complexField)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % complex field �״�� �ϵ� ������鿡�� 0.5+0j �߽� ������ 0.5 �ȿ� ��ġ��Ŵ
    dataToBeEncoded = complexField;
    dataToBeEncoded = dataToBeEncoded/(2*max(abs(dataToBeEncoded(:)))) + 0.5;    % ũ�� -0.5~0.5 ���� ���� �ű⼭ +0.5 => �� ũ�� 0.0~1.0 ���� ����
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % �Ǽ��θ� ���� �� 0 ~ 1 ���̷� ��ġ��Ŵ 
    %{
    dataToBeEncoded = real(complexField);
    dataToBeEncoded = dataToBeEncoded - min(dataToBeEncoded(:));
    dataToBeEncoded = dataToBeEncoded/max(dataToBeEncoded(:));
    %}
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ��Ÿ 
    % complexField = complexField/max(abs(complexField(:)));
    % dataToBeEncoded = (abs(complexField+1));
    % dataToBeEncoded = angle(complexField)+pi;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end