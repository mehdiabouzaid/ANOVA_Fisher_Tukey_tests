%%
clear all
clc
close all

%% Lecture des donnees

indice_colonneSmoking = 11;
indice_colonneSprint = 12;

Donnees = xlsread('Sample_Dataset_2014.xlsx');

%% Y a-t-il des valeurs erronees dans la variable Smoking ?

Smoking = Donnees(:,indice_colonneSmoking);

unique(Smoking);
% On remarque qu'il y a des valeurs NaN dans Smoking

% On retire toutes les lignes contenant NaN pour la variable Smoking
IndicesNan = find(isnan(Smoking));
Donnees(IndicesNan,:) = [];

%% Y a-t-il des valeurs erronees dans la variable Sprint ?

Sprint = Donnees(:,indice_colonneSprint); % 35 meter sprint time (seconds)

IndicesNan = find(isnan(Sprint));
% On remarque qu'il y a des valeurs NaN dans Sprint

% On retire toutes lignes contenant NaN pour la variable Sprint
Donnees(IndicesNan,:) = [];

%% Smoking et Sprint contiennent maintenant des donnees sans NaN

Smoking = Donnees(:,indice_colonneSmoking);
Sprint = Donnees(:,indice_colonneSprint);

%% Boxplot de la variable Sprint
%% Y a-t-il des valeurs aberrantes ?

numFigure = 1;
numFigure = boiteAmoustache(Sprint, numFigure, 'Sprint', 'Les Athletes', 'Temps du sprint (en seconde)');

% D'apres la boite a moustache, il n'y a pas de valeur abberante donc on 
% garde toutes les valeurs de la variable Sprint

%% Verifions que Sprint suit une distribution normale

figure(numFigure)
hold on
grid on
h = normplot(Sprint);
legend([h(3), h(1)], 'ligne de reference (distribution normale)', 'valeurs de la variable Sprint', 'Location','southeast');
title('normplot de la variable Sprint');
xlabel('Sprint');
ylabel('Probabilite');
hold off
numFigure = numFigure+1;

% On peut considerer que la variable Sprint suit une distribution normale
% car la plupart des points bleus se trouvent sur ou proche de la droite de
% reference en rouge, meme si les valeurs aux extremites forment une
% courbure

% De plus, d'apres le site de Matlab Mathworks, l'ANOVA est un test robuste
% pour des violations modestes de cette hypothese que la population suit
% une distrubtion normale.

%% Test statistique pour verifier si la variable Sprint suit une
%% distribution normale

booleenDistributionNormale = chi2gof(Sprint) % chi-square goodness-of-fit test

% La fonction chi2gof de Matlab retourne la decision d'un test statistique
% avec les hypotheses suivantes :
% H0 : les donnees suivent une distribution normale
% H1 : les donnees ne suivent pas une distribution normale

% chi2gof = 1 si le test rejette l'hyptohese nulle avec alpha = 0.05
% chi2gof = 0 sinon

% Ici booleenDistributionNormale = 0 donc on rejette l'hypothese alternative
% Donc la variable Sprint suit bien une distribution normale

%% Matrice Anova

nomStatusFumeur = cell(1,3);
nomStatusFumeur{1} = 'Non fumeur (1)';
nomStatusFumeur{2} = 'Ancien fumeur (2)';
nomStatusFumeur{3} = 'Fumeur actuel (3)';

Matrice = [Smoking Sprint];
indice_colonneSmoking = 1;
indice_colonneSprint = 2;

MatriceAnova = constructionMatriceAnova(Matrice, indice_colonneSmoking, indice_colonneSprint, nomStatusFumeur);
% Maintenant on a 3 groupes de 33 individus (soit 99 individus au total)

%% Robustesse

% On retire la derniere ligne de la MatriceAnova
%MatriceAnova(end,:) = [];

% On ajoute une valeur aberrante a la colonne Non fumeur
%MatriceAnova(end,1) = 12;

%% Est ce que chaque groupe a la meme variance ?
%% (une des conditions a verifier pour l'ANOVA)

% On utilise le test de Bartlett 

% La fonction vartestn(x) de Matlab retourne la decision d'un test statistique
% avec les hypotheses suivantes :
% H0 : chaque colonne de x suit une distribution normale avec la meme
% variance
% H1 : au moins une colonne de x n'a pas la meme variance que les autres
% colonnes

% On regarde la p-value pour savoir quelle hypothese on rejette
% si p-value>alpha alors H0 est validee
% si p-value<alpha alors H1 est validee

pvalue = vartestn(MatriceAnova,'TestType','Bartlett','Display','off')

% Ici pvalue = 0.4271 > alpha = 0.05
% Donc on H0 est validee

% Ainsi chaque colonne de MatriceAnova suit une distribution normale 
% avec la meme variance

%% Anova a la main 

[cellRecapitulatif, moyenneDeChaquegroupe, c, CM_R, r] = anovaAlaMain(MatriceAnova);

%% Affichage tableau recapitulatif ANOVA a la main

numFigure = afficherTableauRecapitulatif(cellRecapitulatif, numFigure, 'Tableau ANOVA a la main');

% Ici
% ddl_InterClasses = 2
% ddl_IntraClasse = 96

% F_tables = 3.09

% F_observe = 10.3687 >= F_tables donc on rejette H0
% Il existe donc au moins une des moyennes qui different des autres

% Il faut maintenant faire un post hoc test pour savoir entre quel(s)
% groupe(s) ont lieu ces differences

%% Boxplot des trois groupes (Non fumeur (1), Ancien fumeur (2), Fumeur actuel (3))

figure(numFigure)
hold on
    grid on
    title('Boite a moustache des trois groupes')
    ylabel('Temps du sprint (en secondes)')
    boxplot(MatriceAnova,'Notch','off','Labels',{'Non fumeur (1)','Ancien fumeur (2)', 'Fumeur actuel (3)'})
hold off
numFigure = numFigure+1;

%% Anova a un facteur Matlab et p-value

[p,tbl,stats] = anova1(MatriceAnova,[],'off');
%p %1-cdf('F',F,ddl_InterClasses,ddl_IntraClasse) % P(X>F)=1-P(X<F)

tbl(1,1:5) = {'Source','SCE','DDL','CM','F'};
tbl(2:4,1) = {'Inter-classes';'Intra-classe';'Total'};

numFigure = afficherTableauRecapitulatif(tbl, numFigure, 'Tableau ANOVA fonction anova1 de Matlab');

% En comparant les deux "Tableau ANOVA", on remarque qu'on retrouve les memes
% resultats

% La fonction anova1 de Matlab donne la p-value
% si p-value>alpha alors H0 est validee
% si p-value<alpha alors H1 est validee

% La p-value est une preuve contre l'hypothese nulle

% Prob>F : p-value, probabilite que F prenne une valeur plus grande que 
% la valeur F calculee. Cette p-value provient de la cdf de la distribution
% de F

% Ici p-value = 8.3744e-05 < alpha = 0.05 ce qui conforte le resultat trouve 
% precedemment avec F et les tables, a savoir que l'hypothese nulle est 
% rejetee

%% Tests Post Hoc

% ddl_IntraClasse = 96
% r = 33
% c = 3

for i = 1:c
    for j = 1:c
        differenceMoyennes(i,j) = abs(moyenneDeChaquegroupe(i)-moyenneDeChaquegroupe(j));
    end
end
    
differenceMoyennes

%% Test LSD de Fisher

% Calculs

dfT = [28 29 30 60 120]; % issu des tables
valeursT = [1.701 1.699 1.697 1.671 1.658]; % issu des tables
t = interp1(dfT,valeursT,96); % 1.6632
LSD = t*sqrt(CM_R*((1/r)+(1/r))) % 0.4534

% Matlab 

figure(numFigure)
stats.gnames = nomStatusFumeur';
LSDMatlab = multcompare(stats,'ctype','lsd');
hold on
title('Fisher (LSD)')
hold off
numFigure = numFigure+1;

% Groupes qui different : 1 et 2, 1 et 3
% Groupes qui se ressemblent : 2 et 3

%% Test HSD de Tukey 

% Calculs

dfQ = [20 24 30 40 60 120]; % issu des tables
valeursQ = [3.578 3.532 3.486 3.442 3.399 3.336]; % issu des tables, pour c=3
q = interp1(dfQ,valeursQ,96); % 3.3612
HSD = (1/sqrt(2))*q*sqrt(CM_R*((1/r)+(1/r))) % 0.6479

% Matlab 

figure(numFigure)
stats.gnames = nomStatusFumeur';
HSDMatlab = multcompare(stats,'ctype','hsd'); % pareil que 'tukey-kramer'
hold on
title('Tukey (HSD)')
hold off

% Groupes qui different : 1 et 2, 1 et 3
% Groupes qui se ressemblent : 2 et 3

% D'apres nos resultats, les resultats des anciens fumeurs et fumeurs actuels 
% different de ceux des non fumeurs

%% Mettre les figures dans l'ordre d'apparition

uistack(7,'top')
uistack(6,'top')
uistack(5,'top')
uistack(4,'top')
uistack(3,'top')
uistack(2,'top')
uistack(1,'top')