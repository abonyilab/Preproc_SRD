%Derringer Desirability function. Written by János Abonyi and Ádám Ipkovich, 10.10.2021
%d = derringer(x, a, b, s) calculates the Derringer desirability of a
%vector, where x is the data, a is the upper limit, b is the lower limit, s
%is the power component
function d = derringer(x, a, b, s)
[N,n] = size(x)
d = zeros(N, 1)
d = ((x-a)./(b-a)).^s;
d(x > a) = 0;
d(x < b) = 1;
end