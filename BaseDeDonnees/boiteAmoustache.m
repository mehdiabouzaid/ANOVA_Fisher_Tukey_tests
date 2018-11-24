function [numFigure]=boiteAmoustache(variable, numFigure, nomVariable, xlabelBoxplot, ylabelBoxplot)
        
    figure(numFigure)
    hold on
        boxplot(variable)
        grid on
        title(['Boite a moustaches de la variable ', nomVariable])
        xlabel(xlabelBoxplot)
        ylabel(ylabelBoxplot)
    hold off
    
    numFigure=numFigure+1;
    
    minimum=min(variable);
    maximum=max(variable);
    Q1=quantile(variable, 0.25);
    Q3=quantile(variable, 0.75);
    Me=quantile(variable, 0.5);
    DIQ=Q3-Q1;
    MoustacheGauche=Q1-1.5*DIQ;
    MoustacheDroite=Q3+1.5*DIQ;

    resumeBoiteAMoustache = table(MoustacheGauche,minimum,Q1,Me,Q3,maximum,MoustacheDroite,DIQ)
end