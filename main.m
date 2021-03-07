clear all,
clc

format long

all_returns_table = readtable('DATA\returns.csv');
all_rates_table = readtable('DATA\rates_month.csv');
        
years = ["2015", "2016", "2017", "2018", "2019"];
months = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];


optimal_portfolio_returns = [];
djia_returns= [];
summary = [];

portfolios = [];

for current_year = years;
    for current_month = months;
       
        
       
        %Get returns of optimal market portfolio with rate
        [tangency_portfolio_non_adjusted, tangency_portfolio_expected_return,tangency_portfolio_sigma, risk_djia] = find_tangency_portfolio(current_year, current_month);

        [optimal_portfolio_returns] = simulate_portfolio(optimal_portfolio_returns, current_year, current_month, 0, tangency_portfolio_non_adjusted, all_rates_table, all_returns_table);

        %Get returns of portfolio on Markowitz bullet
       
        %Get returns of index
        [djia_returns] = simulate_djia(djia_returns, current_year, current_month, all_returns_table);
        
        fprintf('Found optimal portfolio and simulated returns for ' + strcat(current_year, current_month) + '.\n');

      
    end
end


plot_results_vs_index(optimal_portfolio_returns,djia_returns);

optimal_portfolio_returns=optimal_portfolio_returns';
djia_returns = djia_returns';

dates = table2array(all_returns_table(1,end-length(optimal_portfolio_returns)+1:end))';

summarize_results(dates, optimal_portfolio_returns, djia_returns)

