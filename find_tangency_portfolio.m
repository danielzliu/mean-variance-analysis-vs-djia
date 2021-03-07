function [tangency_portfolio, tangency_portfolio_expected_return, tangency_portfolio_sigma, risk_djia] = find_tangency_portfolio(year, month)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

covariance_data = readtable(strcat('DATA_v2\covariance_matrix', year, month, '.csv'));
C = table2array(covariance_data(1:height(covariance_data),1:height(covariance_data))); % covariance matrix
%Apparently Matlab does not consider a matrix symmetrical if this is not
%done
C = 0.5*(C+C');

return_data = readtable(strcat('DATA_v2\expected_returns', year, month, '.csv'));    % check file!
mu = table2array(return_data(1:height(return_data),1))'; %expected returns

index_return = mu(1);
index_variance = C(1,1);

mu = mu(2:end);
C = C(2:end,2:end);
c = zeros(size(mu,2),1)';
e = ones(size(mu,2),1)';
returns = linspace(0,max(mu), 1000);   % highest possible return while still being feasible.

%Adapted to real world changes in DJI
%201807: WBA in GE out
%201504 AAPL in T out
if str2double(strcat(year, month)) < 201807;
    mu(28) = 0;
elseif str2double(strcat(year, month)) >= 201807;
    mu(30) = 0;  
end
if str2double(strcat(year, month)) < 201504;
    mu(3) = 0;
elseif str2double(strcat(year, month)) >= 201504;
    mu(31) = 0;
end

options =  optimset('Display','off');

sigma_X = zeros(size(returns,2),1);
mu_X = zeros(size(returns,2),1);
portfolios_wo_rate = zeros(size(C,1),(size(returns,2)));
count = 1;
for i = 1:size(returns,2)
    X = quadprog(C,c,[],[],[mu;e],[returns(i);1],c,[], [], options);
    portfolios(:,count) = X;
    sigma_X(count) = sqrt(X'*C*X);
    mu_X(count) = mu*X;
    count = count + 1;
end

sharpe = mu_X./sigma_X;
[a,index_max] = max(sharpe);

tangency_portfolio = portfolios(:,index_max);
tangency_portfolio_expected_return = mu_X(index_max);
tangency_portfolio_sigma = sigma_X(index_max);
risk_djia = index_variance^0.5;

% 
% figure('name','Efficient Frontier')
% plot(sigma_X,mu_X)
% hold on
% xlabel('Risk (sigma)')
% ylabel('Return')
% 
% plot(sigma_X(index_max), mu_X(index_max), 'o')








end

