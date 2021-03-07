function [djia_returns_all, djia_actual_risk_month] = simulate_djia(djia_returns_all, current_year, current_month, all_returns_table);
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    %Selects the returns in appropriate month
    

    dates = table2array(all_returns_table(1,4:end));

    dates_in_month_indexes = find(startsWith(dates, strcat(current_year, '-', current_month)));

    all_returns_table = all_returns_table(2:end,4:end);
    all_returns_matrix = all_returns_table{:,:};
    all_returns_matrix = str2double(all_returns_matrix);

    returns_for_month = all_returns_matrix(:,dates_in_month_indexes);

    %Simulates the performances of the portfolios
    djia_returns_days_in_month = returns_for_month(1,:);

    %Adds the per month performance to an all vector
    djia_returns_all = [djia_returns_all, djia_returns_days_in_month];
    djia_actual_risk_month = std(djia_returns_days_in_month);

end