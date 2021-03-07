function [optimal_portfolio_returns_all] = simulate_portfolio(optimal_portfolio_returns_all,  current_year, current_month, weight, tangency_portfolio, all_rates_table, all_returns_table);
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    %Get the rate for appropriate month
    risk_free_rate = all_rates_table.RATE_PER_DAY_(all_rates_table.YEAR_ == str2double(current_year) & all_rates_table.MONTH_ == str2double(current_month));



    %Selects the returns in appropriate month
    

    dates = table2array(all_returns_table(1,4:end));

    dates_in_month_indexes = find(startsWith(dates, strcat(current_year, '-', current_month)));

    all_returns_table = all_returns_table(2:end,4:end);
    all_returns_matrix = all_returns_table{:,:};
    all_returns_matrix = str2double(all_returns_matrix);

    returns_for_month = all_returns_matrix(:,dates_in_month_indexes);



    %Simulates the performances of the portfolios
    optimal_portfolio_returns_days_in_month = (1- weight)*tangency_portfolio' * returns_for_month(2:end,:) + weight * risk_free_rate;

    %Adds the per month performance to an all vector

    optimal_portfolio_returns_all = [optimal_portfolio_returns_all, optimal_portfolio_returns_days_in_month];

end

