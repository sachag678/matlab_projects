function [ mu, k] = VonMisLearnParamsTwoDim( data )
% Calculates the mean and k of the von Mise distribution for 2D data
% where the data is in between 0 and 2pi. It calculates mean by estimating
% the arg(Z) where Z is the mean of the complex exponential. It calculates
% k by calculating the square length of the acerage vector and then 
% equating that to a ratio of bessel functions and estimating k. 
% 
n = length(data);
%calculate z
z=sum(exp(1i*(data)))/n;

%calculate mu
mu = angle(z);

%calculate R^2
Rsqr = ((sum(cos(data))*(1/n))^2 + (sum(sin(data))*(1/n))^2);

%calc Re^2
ReSqr = (n/(n-1))*(Rsqr-(1/n));

% syms m
% k = vpasolve(besseli(1,m)==besseli(0,m)*ReSqr,m);
if mean(data)==data(1)
    k = 1;
else
    k = fzero(@(l) besseli(1,l)-besseli(0,l)*ReSqr,[0,100]);
end

