function output = ehsiEnhancement(input, method, show_figure)
    % input should be a single or double type
    % R G B image
    % output will be a double type RGB image
    % method should be either 'ehsi' , 'mhsi' or 'hsi' 
    % show_figure is a flag decides whether to show figure or not
     
    R=input(:,:,1);
    G=input(:,:,2);
    B=input(:,:,3);
    if strcmp('ehsi', method)
        [H, S, I] = rgb2ehsi(R, G, B);
    elseif strcmp('mhsi', method)
        HSI = rgb2mhsi(input);
        H = HSI(:, :, 1);
        S = HSI(:, :, 2);
        I = HSI(:, :, 3);
    elseif strcmp('hsi', method)
        HSI = rgb2hsi(input);
        H = HSI(:, :, 1);
        S = HSI(:, :, 2);
        I = HSI(:, :, 3);
    end
    
    uintI = im2uint8(I);
    if show_figure == true
        figure()
        set(gcf,'numbertitle','off')
        set(gcf,'name','Original I value')
        hist(uintI, [0:255]);
        figure();
        set(gcf,'numbertitle','off')
        set(gcf,'name','After eq I value')
        uintI(uintI > 250) = 255;
    end
    uintI_eq=histeq(uintI);
    %hist(uintI_eq, [0:255]);
    I_eq = im2double(uintI_eq);
    
    
% S ª¬Âà´« S-type function transformation
% for n = 0.5
S_type1=(0.5*(I_eq)).^0.5;
S_type2=1-(0.5*(1-I_eq)).^0.5;
I_eqstransf=I_eq;
I_eqstransf(I_eq<=0.5)=S_type1(I_eq<=0.5);
I_eqstransf(I_eq>0.5)=S_type2(I_eq>0.5);
if show_figure == true
    figure()
    set(gcf,'numbertitle','off')
    set(gcf,'name','After eq and S-type I value')
    hist(I_eqstransf, [0:0.001:1]);
end

    hsi = cat(3, H, S, I_eqstransf);
    if strcmp(method, 'ehsi')
        [Rn, Gn, Bn] = ehsi2rgb(H, S, I_eqstransf, [1, 1, 1, 1, 1, 1]);
        rgb = cat(3, Rn, Gn, Bn);
    elseif strcmp(method, 'mhsi')
        rgb = mhsi2rgb(hsi);
    elseif strcmp(method, 'hsi')
        rgb = hsi2rgb(hsi);
    end
    if show_figure == true
        figure();
        subplot(1, 3, 1);
        imshow(input);
        subplot(1,3,2);
        imshow(rgb);
        subplot(1,3,3);
        imshow(hsi2rgb(hsi));
    end
    output = rgb;
end