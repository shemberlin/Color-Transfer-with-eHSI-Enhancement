
function hsi = rgb2mhsi(x)
F = im2double(x);
r = F(:, :, 1);
g = F(:, :, 2);
b = F(:, :, 3);

I = (r + g + b) / 3; % intensity

th = acos((0.5 * ((r - g) + (r - b))) ./ ((sqrt((r - g) .^ 2 + (r - b) .* (g - b))) + eps));
th(b > g) = 2 * pi - th(b > g);
H = th / (2 * pi); % hue

S = zeros(size(I)); % saturation
dir = mod(th, 2 * pi / 3);
id = I > 2 / 3 - abs(dir / pi - 1 / 3);
vsum = sum(F, 3);
vsum(id) = 3 - vsum(id);
vmax = max(F, [], 3);
vmin = min(F, [], 3);
S(id) = 1 - 3 * (1 - vmax(id)) ./ vsum(id);
S(~id) = 1 - 3 * vmin(~id) ./ vsum(~id);
S(vsum == 0) = 0;

hsi = cat(3, H, S, I);
end