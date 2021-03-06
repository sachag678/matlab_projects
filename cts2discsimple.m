BallDirection = 2; Action = 3; BallSeen=1;
n = 3;
dag = zeros(n,n);
dag(Action,BallDirection)=1;
dag(BallSeen,Action)=1;
dag(BallSeen,BallDirection)=1;

s = RandStream('mcg16807','Seed',0);
RandStream.setGlobalStream(s);

% ns = ones(1, n); %cts nodes have size of 1
% dnodes = E; %define discrete nodes
% cnodes = mysetdiff(1:n, dnodes);%number of continuous nodes
% ns(dnodes) = 2; %node size of the discrete variables
ns = [2 1 2];
dnodes = [1 3];

bnet = mk_bnet(dag, ns, dnodes); % create bnet with dag and definition of dnodes

%setup
bnet.CPD{3} = tabular_CPD(bnet, 3); % final one should be softmax
bnet.CPD{2} = gaussian_CPD(bnet, 2); %gaussian
bnet.CPD{1} = tabular_CPD(bnet, 1); %tabular


%create inference engine
%engine = likelihood_weighting_inf_engine(bnet);
engine = jtree_inf_engine(bnet);

%get data
data = [];
traces = 's_obst2_n.csv';
for i = 1:size(traces,1)
  tmp = load(traces(i,:));
  data = [data ; tmp];
end
ncases = size(data, 1);			% number of data points
cases = cell(n,ncases);		% create an empty table to store the data to be given to the learning algorithm
cases(:,:) = num2cell(data(:,:)');	% copy the data

%learn
[bnet3, ~, engine] = learn_params_em(engine, cases);
%bnet2 = learn_params(bnet, cases);
%engine = gaussian_inf_engine(bnet3);
%setup evidence
evidence = cell(1,n);
%evidence{BallDirection} = 6.6;
evidence{BallSeen} = 1;

%enter evidence
engine = enter_evidence(engine, evidence);

%calculate marginal on a specific node
marg = marginal_nodes(engine, Action);
marg.T

% CPT1 = cell(1,3);
% for i=[1 3]
%   s1=struct(bnet2.CPD{i});  % violate object privacy
%   CPT1{i}=s1.CPT;
% end
% 
% %outputs the probabilities
%  celldisp(CPT1)
%  
%  gauss = struct(bnet2.CPD{2});
%  gauss.mean
%  gauss.cov