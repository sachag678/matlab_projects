% clear 
close all
clear
clc

%% plot raw data - cumulative sum
data = load('Results Run 282 - toPlot.csv');
raw_wins = data(:,2);
cumsum_wins = cumsum(raw_wins);
%plot
x =linspace(0,2000,2000);
plot(x,cumsum_wins)
%plot all on 1 figure
hold on

%% finite difference method - slope
step_size = 100;
%set initial slope at zero
slope(1) = 0;
count = 2;
%take the difference between the cumulative sum at i and i+step_size
%plot it at intervals of length stepsize
for i=1:step_size:2000-step_size
slope(count)=(cumsum_wins(i+step_size)-cumsum_wins(i));
count = count + 1;
end
%handle the excess - connect to the final datapoint at 2000
slope(length(slope)+1) = cumsum_wins(2000)-cumsum_wins(i+step_size);
%plot
k = 0:step_size:2000;
plot(k, slope, 'y-')

%% segmentation
step_size_straight = 100;
%get the cumsum_wins at intervals of step_size_straight
%plot at intervals of step_size_straight
segment = cumsum_wins(1:step_size_straight:2000);
%handle the excess - connect to the final datapoint at 2000
segment(length(segment)+1)=cumsum_wins(2000);
%plot
i = 0:step_size_straight:2000;
plot(i,segment,'m-', 'LineWidth',2)

%% smoothing
% plot the moving average using the step size, (centered moving average)
step_size_smooth = 100;
backward = 0;
forward = (step_size_smooth/2)-1;
for i=1:2000
    if i>step_size_smooth/2
        backward = step_size_smooth/2;
    else
        backward = i-1;
    end
    if i>2000-forward
        forward = 2000-i;
    end
    smooth(i)=mean(cumsum_wins(i-backward:i+forward));
end
%smooth1 = movmean(cumsum_wins,step_size_smooth);
%smooth2 = filter(ones(step_size_smooth,1), step_size_smooth, cumsum_wins);
%plot
i = linspace(0,2000,length(smooth1));
plot(i,smooth,'c-', 'LineWidth',2)

%labels
legend('cumsum','cumsumDer', 'segment', 'smoothing')
xlabel('Epochs')
ylabel('Cumulative Wins')

