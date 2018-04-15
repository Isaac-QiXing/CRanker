function config()
% set the values of parameters of C-Ranker


% ============= arguments to be set by users =====================

% paths

       
path_user_data = pwd; % pwd: current path
                 % directory of users' PSM data files 
                  % for linux system, e.g.  '/media/data';
                  % for windows system, e.g., 'E:\data';
 
path_cranker_data = path_user_data;                         
    % path_cranker_data: path to store data and result files produced by C-Ranker          
 
    
% arguments for reading data from data files

delimiter = '\b\t';
%delimiter = ',';

decoyPrefix = 'Reverse';

sheet = 'sheet1';

titleRow = 1;           
    
% arguments for splitting the data to train set and test set
train_test_rate = 2/1; %%1/1;1/3; %   % cardinality of train set / cardinality of test set
                          



verbose = 1;%  1;%2;%
  % 0: do not print any iteration/calculation information to command window;  
  % 1: put out progress information briefly to command window;
  % 2: put out more detailed iteration information to command window;
  
  % parameters for output identified results
  
fdr = 0.05;  %  FDR level

threshold_tolFP = 10; % when the identified number of FPs less than this threshold, then  tolFP is effective 
tolFP = 3;  %  number of allowed FPs that to be added additionally if the total number of expected number of FPs  less than threshold_tolFP
ratio_discount = 0.4; 
        %  for setting the expected number of  added  identified  samples  once append one FP    
        %       expect_add_sample =  ratio_discount * round(2/arg.fdr);   
        %       this parameter is effective when tolFP > 0 
       
allowZeroFDR = 0; % whether allow  the extreme case that the calculated FDP == 0, default value 0;   

save_result_text = 1; % 0 or 1, whether save the identified PSM records and the scores to text files 

% -----------  features ------------------- 

%   the spell of these feature names should coincide with that in the title
%   row of the given PSMs data file  
feature_name_spectrum = 'spectrum';  % name of spectrum feature 
feature_name_peptide = 'peptide'; %  name of peptide feature 
feature_name_protein = 'protein'; % name of protein feature 
feature_name_xcorr = 'xcorr'; %  name of xcorr feature
feature_name_deltacn = 'deltacn'; %  name of deltacn feature
feature_name_ions = 'ions'; % name of ions feature

feature_name_enzN = 'enzN';
feature_name_enzC = 'enzC';
feature_name_numProt = 'numProt';
feature_name_xcorrR = 'xcorrR';

feature_name_label = 'label'; % name of the label 
feature_name_peptide_len = 'peptide_len';


 %   the features consists of two parts:
 %    (1) the features of original data (contained in the given data file),
 %        which contains 
 %          a. the basic features: ones that used for the peptide
 %             identification algorithm;
 %          b. the other features;
 %          Both of these features may be numeric or strings.
 %   (2) the calculated (user-defined) features 
 %        the ones that calculated based on the original features values; 

feature_origin_basic_numeric = {}; 
    % original in basic features of numeric value
feature_origin_basic_string = {feature_name_protein}; 
    % original basic features of string value;
    % it is recommended that feature_origin_basic_string at least contain
    %   the features spectrum, peptide and protein;

feature_origin_append_numeric = {feature_name_xcorr,feature_name_deltacn,...
       'sprank',feature_name_ions,'hit_mass'};
    % other original features of numeric values
    % If users have numerical data of other features to be added to train
    %   the model (or do not want to use the features listed currently),
    %   just revise this setting; 
    
    
feature_origin_append_string  = {feature_name_spectrum,feature_name_peptide};
    % other original features of string values
    
feature_calculate_numeric = {feature_name_enzN,feature_name_enzC,...
    feature_name_numProt,feature_name_xcorrR};
    % features calculated based on the original feature values;
    %   these values of the feature will be used to train the model;
    % If users do not want to use some of the features listed currently,
    %   remove them from the current cetting;
    
% ---- arguments for C-Ranker model ----

c1 = 4.8; % the weight of the training error of the decoys

c2 = 1.0*c1; % the weight for encouraging that more target PSMs are shot;
             % for online CRanker c2 is not used, since it is used by
             %   CRanker in history; 
             %  the weight parameter for target losses are c3 
             
c3 = 2.4; % % the weight of the training error of the targets

lambda =  c3;  %  the weight for encouraging that more target PSMs are shot;
             
kernelType = 'rbf'; % kernel type, 'rbf': RBF (Gaussian) kernel

r1 =  1.0; %  kernel argument

flag_split_train_test = 1;
    % 1 or 0: whether split the samples into train set and test set

flag_standardize = 1;
    % 1 or 0: whether standardize the columns of feature values
    %   i.e. transform each column of the values to be zero-mean and unit
    %   variance
    
flag_w = 'manual';     
    
    
svm_theta_solver =  'CCCP_online'; %'CCCP_batch'; %  
    % solver of the classification model    
    % 'CCCP_online': employ online CCCP solver to solve the model 
    % 'CCCP_batch': employ the batch CCCP solver to solve the model 
    % ¡®primal_SVM¡¯: employ the built-in solver to solve the model based on primal SVM
  
return_submodel = 0; 
    % whether to return the submodels (or the corresponding scores)
    
maxTrainSize = 20000; % maximum number of samples for training a submodel;

num_submodel = 5;
    % maximum number of submodels: C-Ranker calculate the scores of PSMs
    %   by combining the scores of certain number of submodels;
    
% ============= arguments for both the online and CCCP algorithms =======    

lambda_mode =   'Fix'; %'SPL';%
%   'Fix': Fix the value of lambda  
%   'SPL': update the parameter lambda with Self-paced
%                      learning terminated with the specified value; 

n_ite_lambda =  1;  %
% iteration number of lambda, Only effective when lambda_mode = 'SPL';
    

flag_gpu_on = 0; %1; % use gpu device, if exists, to speed computation 
    
% -------------- parameters for the online CCCP algorithm ---------- --
% % % n_ideal_cardinality_S = []; 
% % %     % Expected size of the supporting vectors. 
% % %     % Set [] to be determined by the algorithm itself.

    
n_initial_cardinality_S = 1000;
    % initial minimum number of the elements of the working set 
    %   for starting nonconvex CCCP procedure

period_clean = 400; 
             % the period (interval of number of cases) to operate clean procedure
             
% % % n_max_allowed_non_SV = []; 
% % %      % maximun number of allowed non-Support Vectors in the active set S 
% % %     %  this parameter is set in default as follows
% % %     % 
% % %     %      n_max_allowed_non_SV = min(ceil(n_ideal_cardinality_S/4),ceil(n_case/10)); 
% % %     %
% % %     % by the algorithm.

ratio_max_removed_non_SV = 0.25; % ratio of maximum number of removed non-SVs to the number of the active indices in S

mu_safe = 0.3; % threshold of the predicted function value as a safely correct prediction
     
mu_safe_target = Inf; % threshold of the predicted function value as a safely correct target. 
    % Set 
    %   mu_safe_target = Inf;
    %  to keep all the identified correct targets in the active set S 

n_max_size_S = 6000; % maximum capacity of the active set S 

max_ite_num_CCCP_reprocess = 1000;  % muximum number of reprocess operation for each sample


n_max_cache = []; 
    % maximum number of caching size of the kernel matrix
    % default value: n_ideal_cardinality_S*6.0


tol_violating_pair_initial = 5E-2;  % initial value of the tolerance of violating pair
% % % tol_decrease_factor = 0.2;  % factor of the tolerance of violating pair decreased after each epoch    
tol_violating_pair_min = 5E-2; 
    % minimum value of the tolerance of violating pair
    
    
n_epoch = 1;   % number of epochs

check_lambda_ite = 0; % 0 or 1, whether to check the iteration of lambda, only effective on SPL mode

fix_train_test_set = 1;  
    % 1: fix the train set and test set when splitting the whole PSMs at different calls
    % 0: make the splitted train set and test set different at different calls

fix_train_order = 1; 
    % 1: fix the order for the training PSMs to enter into the online learning iteration at different calls
    % 0: make the order of the training PSMs to enter into the online learning iteration different at different calls
    
reject_nonactive_sample = 1; 
   % 1: keep certain part of non-active PSM samples from entering into the active set
   % 0: add each new coming PSM sample to the active set 

   % the following 3 parameters set the rules to reject a PSM enter into
   % the working set for training 
   
   % rule to reject a PSM: 
   %  if (y(i_case)==-1 && g_icase >= mu_decoy_nonact) || (y(i_case)==1 && g_icase <= - mu_target_nonact_predict_correct ) || ...
   %             (y(i_case)== 1 && g_icase >= 1-s_loss + mu_target_nonact_predict_wrong )
   %  then  the PSM i_case will be reject to enter into the working set
   
mu_decoy_nonact = 12.0;
mu_target_nonact_predict_correct = 20.0;
mu_target_nonact_predict_wrong  = 20.0;
   
% -------------- arguments for the Batch-CS-Ranker solver    ---------- --


display = 'off'; 
        % Level of display:
        % 'off' or 'none' displays no output.
        % 'iter' displays output at each iteration, and gives the default exit message.
        % 'iter-detailed' displays output at each iteration, and gives the technical exit message.
        % 'notify' displays output only if the function does not converge, and gives the default exit message.
        % 'notify-detailed' displays output only if the function does not converge, and gives the technical exit message.
        % 'final' (default) displays just the final output, and gives the default exit message.
        % 'final-detailed' displays just the final output, and gives the technical exit message.
    

flag_low_rank_approx = 0;  %1;
    % whether approximate the kernel matrix K = G*G' by Cholesky factorization
    %   where K is the kernel matrix, G is a low rank matrix
tol_low_rank_approx = 5.0E-3;%1.0E-3;%
    % tolence to do the Cholesky factorization
    %       K = G*G'
    %   the factorization terminates if the diagnal elements of the matrix
    %     G decreased to this given tolerance;
flag_calculate_initial_point = 1.0;
    % whether to calculate a initial point before iteration  

max_ite_CCCP_batch = 10; %3; % maximum number of CCCP iterations

tolFun = 2.0; % initial tolerance of iterated funcation values for the subproblem solver
tolX = 0.5;  % initial tolerance of iterated solutions for the subproblem solver

decrease_factor_tolFun =0.2; % decrease factor of tolFun
decrease_factor_tolX  =0.2; % decrease factor of tolX

min_tolFun =  0.005; % minimum value of the tolerance iterated funcation values for the subproblem solver1
min_tolX = 0.005;  % minimum value of the tolerance of iterated solutions for the subproblem solver0.1
    % tolFun is iterated as follows after each iteration 
    %
    %   TolFun = max(TolFun * decrease_factor_tolFun, min_tolFun)
    %
    % similarly tolX is iterated as follows after each iteration     
    %
    %   TolX = max(TolX * decrease_factor_tolFun, min_tolX)

 % -------------- arguments for the matlab built-in solver for primal-SVM-based C-Ranker model ---------- --
 
 tolFun_cranker = 0.1; 
 
% flag_low_rank_approx = 0;  %1;
    
% tol_low_rank_approx = 5.0E-3;%1.0E-3;%
    % tolence to do the Cholesky factorization
    %       K = G*G'
    %   the factorization terminates if the diagnal elements of the matrix
    %     G decreased to this given tolerance;
    
    

% assign the callers the variables
varName = whos();
varName_c = {varName.name};
for ii = 1:length(varName_c)
    varName = varName_c{ii};
    assignin('caller',varName,eval(varName));
end

end
