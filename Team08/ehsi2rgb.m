function [R, G, B] = ehsi2rgb(H, S, I, flag)
    doRG = flag(1);
    doGB = flag(2);
    doBR = flag(3);
    doYC = flag(4);
    doCM = flag(5);
    doMY = flag(6);
    RG_sec = find(H <= 120 & I <= (2/3 - abs(H-60)/ 180));
    GB_sec = find(H > 120 & H <= 240 & I <= (2/3 - abs(H-180)/ 180));
    BR_sec = find(H > 240 & H <= 360 & I <= (2/3 - abs(H-300)/ 180));
    YC_sec = find(H > 60 & H <= 180 & I > (1/3 + abs(H-120)/ 180));
    CM_sec = find(H > 180 & H <= 300 & I > (1/3 + abs(H-240)/ 180));
    MY_sec1 = find(H > 300 & H <= 360 & I > (1/3 + abs(360 - H)/ 180));
    MY_sec2 = find(H <= 60 & I > (1/3 + H/ 180));
    MY_sec = union(MY_sec1, MY_sec2);
    
    [M, N] = size(H);
    %{
    figure();
    subplot(2, 3, 1);
    show_section(M, N, RG_sec, 'RG');
    subplot(2, 3, 2);
    show_section(M, N, GB_sec, 'GB');
    subplot(2, 3, 3);
    show_section(M, N, BR_sec, 'BR');
    subplot(2, 3, 4);
    show_section(M, N, YC_sec, 'YC');
    subplot(2, 3, 5);
    show_section(M, N, CM_sec, 'CM');
    subplot(2, 3, 6);
    show_section(M, N, MY_sec, 'MY');
    %suptitle('eHSI region');
    %}
    R = zeros(M, N);
    G = zeros(M, N);
    B = zeros(M, N);
    
    if doRG
        B(RG_sec) = I(RG_sec) .* (1-S(RG_sec));
        R(RG_sec) = I(RG_sec) .* (1+(S(RG_sec) .* cosd(H(RG_sec)) ./ cosd(60 - H(RG_sec) + eps)));
        G(RG_sec) = 3*I(RG_sec) - (R(RG_sec)+B(RG_sec));
    end
    
    if (doGB)
    R(GB_sec) = I(GB_sec) .* (1-S(GB_sec));
    G(GB_sec) = I(GB_sec) .* (1+(S(GB_sec) .* cosd(H(GB_sec) - 120) ./ (cosd(60 - H(GB_sec) + 120) + eps)));
    B(GB_sec) = 3*I(GB_sec) - (R(GB_sec)+G(GB_sec));
    end
    if (doBR)
    G(BR_sec) = I(BR_sec) .* (1-S(BR_sec));
    B(BR_sec) = I(BR_sec) .* (1+(S(BR_sec) .* cosd(H(BR_sec) - 240) ./ (cosd(60 - H(BR_sec) + 240) + eps)));
    R(BR_sec) = 3*I(BR_sec) - (G(BR_sec)+B(BR_sec));
    end
    if (doYC)
    G(YC_sec) = I(YC_sec) .* (1-S(YC_sec)) + S(YC_sec);
    B(YC_sec) = 1 - (1-I(YC_sec)) .* (1 + (S(YC_sec) .* cosd(H(YC_sec) - 240) ./ (cosd(60 - H(YC_sec) + 240) + eps)));
    R(YC_sec) = 3*I(YC_sec) - (G(YC_sec) + B(YC_sec));
    end
    if (doCM)
    B(CM_sec) = I(CM_sec) .* (1-S(CM_sec)) + S(CM_sec);
    R(CM_sec) = 1 - (1-I(CM_sec)) .* (1 + (S(CM_sec) .* cosd(H(CM_sec)) ./ (cosd(60 - H(CM_sec) + eps))));
    G(CM_sec) = 3*I(CM_sec) - (R(CM_sec) + B(CM_sec));
    end
    if (doMY)
    R(MY_sec) = I(MY_sec) .* (1-S(MY_sec)) + S(MY_sec);
    G(MY_sec) = 1 - (1-I(MY_sec)) .* (1 + (S(MY_sec) .* cosd(H(MY_sec) - 120) ./ (cosd(60 - H(MY_sec) + 120) + eps)));
    B(MY_sec) = 3*I(MY_sec) - (R(MY_sec) + G(MY_sec));
    end
    
end