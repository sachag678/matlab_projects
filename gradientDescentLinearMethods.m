%Linear Methods
%-------------------------------------------------------------------------
%Getting the dataset
num_params = 10;
weights = rand(num_params,1);
featureVector = zeros(100,10);
yt = zeros(100,1);
for i=1:100
    featureVector(i,:) = rand(num_params,1);
    yt(i,:) = weights'*featureVector(i,:)';
end

%------------------------------------------------------------------------
%Solving for weights using SGD
new_weights = zeros(num_params,1);

%small alpha
alpha = 0.01;

%no convergence conditions - however there is convergence at 50 epochs
for epochs=1:50
    for j =1:100
        y = new_weights'*featureVector(j,:)';
        error = y-yt(j,:);
        new_weights = new_weights - alpha*error*featureVector(j,:)';
    end
end

%------------------------------------------------------------------------
%testinng the similarity between the old and new weights.
test_features = rand(num_params,1);
y_old = weights'*test_features;
y_new = new_weights'*test_features;

percent = 100*(1-(y_old-y_new)/(y_old));

fprintf('There is a %.f%% similarity between the output using the old and new weights. \n',percent)
