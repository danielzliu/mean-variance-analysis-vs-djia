function [] = plot_results_vs_index(optimal_portfolio_returns,djia_returns)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%Simulates the cumulative returns
optimal_portfolio_returns_cum = [1];
djia_returns_cum = [1];


for day_i = 1:length(optimal_portfolio_returns);
    new_value = (1 + optimal_portfolio_returns(day_i)) * optimal_portfolio_returns_cum(end);
    optimal_portfolio_returns_cum = [optimal_portfolio_returns_cum, new_value];
end

for day_i = 1:length(djia_returns);
    new_value = (1 + djia_returns(day_i)) * djia_returns_cum(end);
    djia_returns_cum = [djia_returns_cum, new_value];
end



% %plots everything
% % %Plots the returns per day
% subplot(2,1,1)
% hold on
% plot(100*optimal_portfolio_returns, 'r');
% plot(100*djia_returns, 'b');
% plot([0:length(optimal_portfolio_returns)],zeros(length(optimal_portfolio_returns)+1,1),'k');
% legend('Adjusted optimal portfolio', 'Index',  'Cash')
% xlabel('Business Day')
% xlim([1,inf])
% ylabel('Daily Return')
% ytickformat('percentage')
% %ylim([-1, 2]) 
% hold off

%subplot(2,1,2)
box on
hold on
plot(100*(optimal_portfolio_returns_cum - 1), 'r')
plot(100*(djia_returns_cum - 1), 'b');
%plot([0:length(optimal_portfolio_returns_cum)],zeros(length(optimal_portfolio_returns_cum)+1,1),'k');
legend('Optimal portfolio weighted by expected risk', 'Index')
xlabel('Business Day')
xlim([1,1265])
ylabel('Cumulative Return')
ytickformat('percentage')
%ylim([-2, 6])
hold off


end

