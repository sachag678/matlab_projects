Action=1;BallDirection=2;
n=2;
dag = zeros(n,n);
dag(Action,BallDirection)=1;

ns = [2 1];
dnodes = 1;

bnet = mk_bnet(dag, ns, dnodes); % create bnet with dag and definition of dnodes

bnet.CPD{2} = gaussian_CPD(bnet, 2); %vonMises
bnet.CPD{1} = tabular_CPD(bnet, 1); %tabular

%get data
%num_data_points = 1000;
%data1 = vmrand(0,2,[num_data_points,1]);
%data1 = [ones(num_data_points,1),data1];
%data2 = vmrand(4,40.2,[num_data_points,1]);
%data2 = [ones(num_data_points,1)*2,data2];
%data = [data1;data2];

data = [1 0.1; 2 0.8; 2 0.9; 1 0.2];
%data = [1 0.8*pi; 1 0.9*pi];
%data = degtorad(data);
ncases = size(data, 1);			% number of data points
cases = cell(n,ncases);		% create an empty table to store the data to be given to the learning algorithm
cases([1:n],:) = num2cell(data(:,:)');	% copy the data

%learn
%learn EM
%engine = jtree_inf_engine(bnet);
%[bnet2, ~, engine] = learn_params_em(engine, cases);

%learn ML
bnet2 = learn_params(bnet, cases);
engine = jtree_inf_engine(bnet2);

network = struct(bnet2.CPD{1});
network.CPT

%PERFORM INFERENCE
%-------------------------------------------------------------------------
evidence = cell(1,n);

%evidence{BallDirection} =0.55;

engine = enter_evidence(engine, evidence);

%calculate marginal on a specific node
marg = marginal_nodes(engine, 1);
prob = marg.T;
fprintf('Inference: --------------------------------- \n');
fprintf('P(X=1|Y=0.9pi) = %.2f \n',prob(1));
fprintf('P(X=2|Y=0.9pi) = %.2f \n',prob(2));

