data = [pi/2,pi/3,8*pi/5,0,pi/4,pi*3/7];
[mu,k] = VonMisLearnParamsTwoDim(data);
x = linspace(-pi,pi,100);
y = VonMisDistribution(x,mu,k);
plot(x,y);
set(gca,'XTick',[-pi -3*pi/4 -pi/2 -pi/4 0 pi/4 pi/2 3*pi/4 pi]);
set(gca,'XTickLabel',{'-pi','-3*pi/4','-pi/2','-pi/4','0','pi/4','pi/2','3*pi/4','pi'});
