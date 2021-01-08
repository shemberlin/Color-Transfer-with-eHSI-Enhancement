function [H, S, I] = rgb2ehsi(R, G, B)
    [M, N] = size(R);
    H = zeros(M, N);
    S = zeros(M, N);
    %�p��G�� I
    rgbSum = R + G + B;
    I=rgbSum/3;
    %�p���� H
    theta=acosd((0.5 * ((R-G)+(R-B))) ./ (((R-G).^2 + (R-B).*(G-B)).^0.5 +eps));

    index1=find(B<=G);
    H(index1)=theta(index1);
    index2=find(B>G);
    H(index2)=360-theta(index2);
    %�ץ���� H�Ψӭp��U��S�Ϊ�
    new_H=mod(H,120);

    %�̫G�� I �p�⹡�M�� S
    minimum = min(min(R, G), B);
    maximum= max(max(R, G), B);
    disp(size(maximum));
    disp(size(minimum));
    part1=find(I>(2/3-(abs(new_H-60)/180)));
    part2=find(I<=(2/3-(abs(new_H-60)/180)));
    x=1-((3.*(1-maximum))./(3-rgbSum+eps));
    %x(find(isnan(x)==1)) = 0;%�N�x�}��Nan�S���N�q���ƴ�����0
    y=1-(3.*minimum./(rgbSum + eps));
    %y(find(isnan(y)==1)) = 0;%�N�x�}��Nan�S���N�q���ƴ�����0
    S(part1)=x(part1);
    S(part2)=y(part2);
    
end