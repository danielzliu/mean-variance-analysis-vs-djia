function [] = summarize_results(dates, optimal_portfolio_returns, djia_returns)


%Creates table
difference = optimal_portfolio_returns - djia_returns;

returns_table = table(dates, optimal_portfolio_returns, djia_returns, difference);

%Adds dates and factors to table

dv = datevec(returns_table.dates);
returns_table.Year = dv(:,1);
returns_table.Month = dv(:,2);
returns_table.portfolio_factors= 1 + optimal_portfolio_returns;
returns_table.djia_factors = 1 + djia_returns;

%Total return for whole period

total_return_portfolio = prod(returns_table.portfolio_factors) - 1;
total_return_djia = prod(returns_table.djia_factors) - 1;

%Mean and standard deviation for whole period
avg_daily_return_portfolio = varfun(@mean,returns_table,'InputVariable','optimal_portfolio_returns');
avg_daily_return_djia = varfun(@mean,returns_table,'InputVariable','djia_returns');

std_portfolio = varfun(@std,returns_table,'InputVariable','optimal_portfolio_returns');
std_djia = varfun(@std,returns_table,'InputVariable','djia_returns');

%Counts the fraction of time portfolio beat index
fraction_portfolio_beat_index_days = sum(returns_table.difference > 0) / height(returns_table);

portfolio_returns_yearmonth = varfun(@prod,returns_table,'GroupingVariables',{'Year','Month'},'InputVariable','portfolio_factors');
djia_returns_yearmonth = varfun(@prod,returns_table,'GroupingVariables',{'Year','Month'},'InputVariable','djia_factors');
fraction_portfolio_beat_index_months = sum(portfolio_returns_yearmonth.prod_portfolio_factors > djia_returns_yearmonth.prod_djia_factors) / height(portfolio_returns_yearmonth);

portfolio_returns_year = varfun(@prod,returns_table,'GroupingVariables',{'Year'},'InputVariable','portfolio_factors');
djia_returns_year = varfun(@prod,returns_table,'GroupingVariables',{'Year'},'InputVariable','djia_factors');
fraction_portfolio_beat_index_years = sum(portfolio_returns_year.prod_portfolio_factors > djia_returns_year.prod_djia_factors) / height(portfolio_returns_year);

%Counts the fraction of time portfolio moved the same direction as index

fraction_same_direction = sum(returns_table.optimal_portfolio_returns .* returns_table.djia_returns > 0) / height(returns_table);

%Calculates correlation

correlation_matrix = corrcoef(returns_table.optimal_portfolio_returns, returns_table.djia_returns);
correlation = correlation_matrix(1,2);

%Calculates beta

covariance_matrix = cov(returns_table.optimal_portfolio_returns, returns_table.djia_returns);
realized_beta = covariance_matrix(1,2) / covariance_matrix(2,2);

%Displays summary

disp(table(total_return_portfolio, total_return_djia));

disp([avg_daily_return_portfolio, avg_daily_return_djia])
disp([std_portfolio, std_djia])

fraction_portfolio_beat_index_by_day = fraction_portfolio_beat_index_days;
by_month = fraction_portfolio_beat_index_months;
by_year = fraction_portfolio_beat_index_years;
disp(table(fraction_portfolio_beat_index_by_day, by_month, by_year));

disp(table(fraction_same_direction));
disp(table(correlation, realized_beta));
 

end

