%data
xt = [1,2,3,4,5];
yt = [1,3,3,2,5];

%initial estimates
b0 = 0;
b1 = 0;

alpha = 0.01;

for i=1:100
    for j = 1:5
        y = b0+b1*xt(j);
        error = y-yt(j);
        b0 = b0-alpha*error;
        b1 = b1-alpha*error*xt(j);
    end
end

y = b0+b1*xt

plot(xt,yt,'ro',xt,y,'bo-')



