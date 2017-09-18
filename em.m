%EM algorithm - example - coin toss with two biased coins. 
% we know the head tail seq but don't know which coin was used for which
% experiment. we want to find the bias of the coins.fgruhs
estA = zeros(1,20);
estB = zeros(1,20);

estA(1) = 0.6;
estB(1) = 0.5;
improvA = 1;
improvB = 1;
count = 1;
data = [1,0,0,0,1,1,0,1,0,1; 1,1,1,1,0,1,1,1,1,1; 1,0,1,1,1,1,1,0,1,1; 1,0,1,0,0,0,1,1,0,0; 0,1,1,1,0,1,1,1,0,1];

while(improvA>0.001 && improvB > 0.001)  
    
est = zeros(5,2);
normal_est = zeros(5,2);
tableA = zeros(5,2);
tableB = zeros(5,2);
%expectiation -----------------------------
for i=1:5
numHeads = sum(data(i,:));
est(i,1) = estA(count)^numHeads*(1-estA(count))^(10-numHeads); % use binomial 10 choose k where k is heads
est(i,2) = estB(count)^numHeads*(1-estB(count))^(10-numHeads);
normal_est(i,1) = est(i,1)/(est(i,1)+est(i,2)); %normalize the values 
normal_est(i,2) = est(i,2)/(est(i,1)+est(i,2));
tableA(i,1) = normal_est(i,1)*numHeads; %calculate how many heads vs tails one will get
tableA(i,2) = normal_est(i,1)*(10-numHeads);
tableB(i,1) = normal_est(i,2)*numHeads;
tableB(i,2) = normal_est(i,2)*(10-numHeads);
end
%maximiazation -----------------------------------------------
count = count+1;

estA(count) = sum(tableA(:,1))/(sum(sum(tableA))); % maximum likelihood
estB(count) = sum(tableB(:,1))/(sum(sum(tableB)));

improvA = abs(estA(count)-estA(count-1)); % convergence check
improvB = abs(estB(count)-estB(count-1));

end

%plots the values over time - shows them converge. 
subplot(2,1,1)
plot(estA(1:count));
ylabel('estimateA')
xlabel('iterations')
subplot(2,1,2)
plot(estB(1:count));
ylabel('estimateB')
xlabel('iterations')
    