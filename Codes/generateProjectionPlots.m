%% Generate plots from data

load ../Results/MIAS/cvAtlasSelectionResults.mat;
color = [0.4, 0.4, 0.4];
for fold = 1:length(ret)
    
    % t-SNE projection
    figure('Position', [300, 300, 500, 450]); 
    axes('Position',[.15 .13 .78 .84]);
    h=gscatter(ret(fold).projections(:,1),ret(fold).projections(:,2),ret(fold).belongingCluster,color, 'o>sdvp',5);
    for n = 1:max(ret(fold).belongingCluster)
       set(h(n), 'MarkerFaceColor', 'w', 'MarkerEdgeColor', color, 'linewidth', 1);
    end
    set(gca, 'box', 'off', 'tickdir', 'out', 'fontsize', 15);
    set(gcf,'Color','W');
    xlabel('Dimension 1');
    ylabel('Dimension 2');
    Legend = cell(ret(fold).kStar,1);
    for i=1:ret(fold).kStar
       Legend{i} = sprintf('Cluster %d',i); 
    end
    h_legend = legend(Legend, 'Orientation', ...
                      'vertical', 'location', 'best');
    
    print(sprintf('../Results/MIAS/Plots/t-SNE%d.pdf',fold),'-dpdf');
    print(sprintf('../Results/MIAS/Plots/t-SNE%d.jpg',fold),'-djpeg');
    
%     Install and use export_fig for better rendering
%     export_fig(sprintf('../Results/MIAS/Plots/t-SNE%d.pdf',fold));
%     export_fig(sprintf('../Results/MIAS/Plots/t-SNE%d.jpg',fold));
    
    
    % BIC vs. k
    figure('Position', [850, 300, 500, 450]);
    axes('Position',[.17 .13 .78 .84]);
    plot(2:9, ret(fold).bics,'-', 'color', color, 'LineWidth',2);
    set(gcf,'Color','W');
    hold on;
    
    ylim=get(gca,'ylim')-[30 -10];
    set(gca,'ylim',ylim);
    plot([ret(fold).kStar ret(fold).kStar], [ylim(1) ret(fold).bics(ret(fold).kStar-1)],'k:', 'LineWidth',2, 'color', color);
    plot(ret(fold).kStar,ylim(1),'.','MarkerSize', 25, 'color', color);
    plot(2:9, ret(fold).bics, 'o','color', color,  'MarkerFaceColor', 'w', 'Markersize', 8, 'Linewidth', 3);
    hold off;
    set(gca, 'box', 'off', 'tickdir', 'out', 'fontsize', 15);
    xlabel('Number of clusters k');
    ylabel('Bayesian Information Criterion');

    
    print(sprintf('../Results/MIAS/Plots/BIC%d.pdf',fold),'-dpdf');
    print(sprintf('../Results/MIAS/Plots/BIC%d.jpg',fold),'-djpeg');
    
%     Install and use export_fig for better rendering    
%     export_fig(sprintf('../Results/MIAS/Plots/BIC%d.pdf',fold));
%     export_fig(sprintf('../Results/MIAS/Plots/BIC%d.jpg',fold));
end