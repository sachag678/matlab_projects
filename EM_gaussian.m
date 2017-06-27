x = [-0.39, 0.12, 0.94, 1.67, 1.76, 2.44, 3.72,4.28,4.92,5.53,0.06,0.48,1.01,1.68,1.80,3.25,4.12,4.60,5.28,6.22];
sigma1 = 0.2;
mu1 = 0.5;
sigma2 = 0.2;
mu2 = 0.7;
omega1 = 0.6;
omega2 = 0.4;
num_iter = 100;

ll_old = 0;

for l=1:20
%E-step
for i=1:length(x)
    p_c(i,1) = omega1*(1/(2*pi*sigma1)^0.5)*exp(-(x(i)-mu1).^2/2*sigma1);
    p_c(i,2) = omega2*(1/(2*pi*sigma2)^0.5)*exp(-(x(i)-mu2).^2/2*sigma2);
    normalized_p(i,1) = p_c(i,1)/(p_c(i,1)+p_c(i,2));
    normalized_p(i,2) = p_c(i,2)/(p_c(i,1)+p_c(i,2));
end

%maximization step
sum1 =0;
sum2 = 0;
for i=1:length(x)
    sum1 = sum1 + (normalized_p(i,1)*x(i));
    sum2 = sum2 + (normalized_p(i,2)*x(i));
end

mu1 = sum1/sum(normalized_p(:,1));
mu2 = sum2/sum(normalized_p(:,2));

sum1 =0;
sum2 = 0;
for i=1:length(x)
    sum1 = sum1 + ((x(i)-mu1)^2*normalized_p(i,1))/sum(normalized_p(:,1));
    sum2 = sum2 + ((x(i)-mu2)^2*normalized_p(i,2))/sum(normalized_p(:,2));
end

sum1 = sum1;
sum2 = sum2;

sigma1 = sum1;
sigma2 = sum2;

omega1 = sum(normalized_p(:,1))/length(normalized_p(:,1));
omega2 = 1-omega1;

ll_new = 0;

for i=1:length(x)
    s = omega1*(1/(2*pi*sigma1)^0.5)*exp(-(x(i)-mu1).^2/2*sigma1)+omega2*(1/(2*pi*sigma2)^0.5)*exp(-(x(i)-mu2).^2/(2*sigma2));
    ll_new = ll_new + log(s);
end

if (abs(ll_new - ll_old) < 0.01)
    break;
end

ll_old = ll_new;
ll_new


end
    








