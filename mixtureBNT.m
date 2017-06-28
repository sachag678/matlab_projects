n=3;
dag = [0 1 1; 0 0 1; 0 0 0];
s = RandStream('mcg16807','Seed',0);
RandStream.setGlobalStream(s);

% ns = ones(1, n); %cts nodes have size of 1
% dnodes = E; %define discrete nodes
% cnodes = mysetdiff(1:n, dnodes);%number of continuous nodes
% ns(dnodes) = 2; %node size of the discrete variables
ns = [2 2 1];
dnodes = [1 2];

bnet = mk_bnet(dag, ns, dnodes); % create bnet with dag and definition of dnodes

%setup
bnet.CPD{1} = tabular_CPD(bnet, 1); %tabular
bnet.CPD{2} = tabular_CPD(bnet, 2); % final one should be softmax
bnet.CPD{3} = gaussian_CPD(bnet, 3); %gaussian

%create inference engine
%engine = likelihood_weighting_inf_engine(bnet);
engine = jtree_inf_engine(bnet);

%get data
% data = [];
% traces = 's_obst2_n.csv';
% for i = 1:size(traces,1)
%   tmp = load(traces(i,:));
%   data = [data ; tmp];
% end
% ncases = size(data, 1);			% number of data points
% cases = cell(n,ncases);		% create an empty table to store the data to be given to the learning algorithm
% cases(:,:) = num2cell(data(:,:)');	% copy the data

X = [-2.5 -3.4  -3.2 2.6] ;
C = [1 1 1 2];
training = cell(n, length(X));
training(3,:) = num2cell(X,1);
training(1,:) = num2cell(C,1);

%learn
[bnet2, ~, engine] = learn_params_em(engine, training);
%bnet2 = learn_params(bnet, cases);

%setup evidence
evidence = cell(1,n);
evidence{3} = 1.4;

%enter evidence
engine = enter_evidence(engine, evidence);

%calculate marginal on a specific node
marg = marginal_nodes(engine, 1);
marg.T

% CPT1 = cell(1,3);
% for i=[1 2]
%   s1=struct(bnet2.CPD{i});  % violate object privacy
%   CPT1{i}=s1.CPT;
% end
% 
% %outputs the probabilities
%  celldisp(CPT1)
%  
%  gauss = struct(bnet2.CPD{3});
%  gauss.mean
%  gauss.cov