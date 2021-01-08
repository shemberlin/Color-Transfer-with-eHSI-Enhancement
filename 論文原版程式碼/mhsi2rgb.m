
function C = mhsi2rgb(hsi)
HV = hsi(:, :, 1) * 2 * pi;
SV = hsi(:, :, 2);
IV = hsi(:, :, 3);
R = zeros(size(HV));
G = zeros(size(HV));
B = zeros(size(HV));

%RG Sector
id = (pi <= HV) & (HV < 5 * pi / 3) & (IV >= 1 / 3 + abs(HV - 4 * pi / 3) / pi);
B(id) = IV(id) .* (1 - SV(id)) + SV(id);
R(id) = 1 - (1 - IV(id)) .* (1 + SV(id) .* cos(HV(id)) ./ cos(pi / 3 - HV(id)));
G(id) = 3 * IV(id) - (R(id) + B(id));
%BG Sector
id = (HV < 1 * pi / 3) & (IV >= 1 / 3 + HV / pi) | (5 * pi / 3 <= HV) & (IV >= 1 / 3 + 2 - HV / pi);
R(id) = IV(id) .* (1 - SV(id)) + SV(id);
G(id) = 1 - (1 - IV(id)) .* (1 + SV(id) .* cos(HV(id) - 2 * pi / 3) ./ cos(pi - HV(id)));
B(id) = 3 * IV(id) - (R(id) + G(id));
%BR Sector
id = (1 * pi / 3 <= HV) & (HV < pi) & (IV >= 1 / 3 + abs(HV - 2 * pi / 3) / pi);
G(id) = IV(id) .* (1 - SV(id)) + SV(id);
B(id) = 1 - (1 - IV(id)) .* (1 + SV(id) .* cos(HV(id) - 4 * pi / 3) ./ cos(5 * pi / 3 - HV(id)));
R(id) = 3 * IV(id) - (G(id) + B(id));

%RG Sector
id = (0 <= HV) & (HV < 2 * pi / 3) & (IV <= 2 / 3 - abs(HV - pi / 3) / pi);
B(id) = IV(id) .* (1 - SV(id));
R(id) = IV(id) .* (1 + SV(id) .* cos(HV(id)) ./ cos(pi / 3 - HV(id)));
G(id) = 3 * IV(id) - (R(id) + B(id));
%BG Sector
id = (2 * pi / 3 <= HV) & (HV < 4 * pi / 3) & (IV <= 2 / 3 - abs(HV - pi) / pi);
R(id) = IV(id) .* (1 - SV(id));
G(id) = IV(id) .* (1 + SV(id) .* cos(HV(id) - 2 * pi / 3) ./ cos(pi - HV(id)));
B(id) = 3 * IV(id) - (R(id) + G(id));
%BR Sector
id = (4 * pi / 3 <= HV) & (HV < 2 * pi) & (IV <= 2 / 3 - abs(HV - 5 * pi / 3) / pi);
G(id) = IV(id) .* (1 - SV(id));
B(id) = IV(id) .* (1 + SV(id) .* cos(HV(id) - 4 * pi / 3) ./ cos(5 * pi / 3 - HV(id)));
R(id) = 3 * IV(id) - (G(id) + B(id));

C = cat(3, R, G, B);
% C = max(min(C, 1), 0);
end
