function [cellRecapitulatif, moyenneDeChaqueEchantillon, c, CM_R, r]=anovaAlaMain(MatriceAnova)

    % Moyenne Inter-Classes
    moyenneGlobale=mean(mean(MatriceAnova));
    
    r=size(MatriceAnova, 1); % nombre de lignes
    c=size(MatriceAnova, 2); % nombre de colonnes    
    n=c*r; % nombre de donnees totales

    % Moyenne Intra-Classe
    for i=1:c
        moyenneDeChaqueEchantillon(i)=mean(MatriceAnova(:,i));
    end
    moyenneDeChaqueEchantillon=moyenneDeChaqueEchantillon';

    % Somme des carres des ecarts due au facteur
    SCE_F= r*(sum((moyenneDeChaqueEchantillon-moyenneGlobale).^2));
    ddl_InterClasses=c-1;
    CM_F = SCE_F/ddl_InterClasses;

    % Somme des carres des ecarts residuelle
    SCE_R=0;
    for j= 1:c
        for i= 1:r
            SCE_R=SCE_R+(MatriceAnova(i,j)-moyenneDeChaqueEchantillon(j))^2;
        end
    end
    ddl_IntraClasse=n-c;
    CM_R = SCE_R/ddl_IntraClasse;

    % Notation : F(ddl_InterClasses, ddl_IntraClasse)
    F=CM_F/CM_R;

    ddl_Total=n-1;
    SCE_T=SCE_F+SCE_R;

    cellRecapitulatif=cell(4,1);
    cellRecapitulatif(1,1:5)={'Source','SCE','DDL','CM','F'};
    cellRecapitulatif(2:4,1) = {'Inter-classes';'Intra-classe';'Total'};
    cellRecapitulatif(2:4,2) = {SCE_F, SCE_R, SCE_T};
    cellRecapitulatif(2:4,3) = {ddl_InterClasses, ddl_IntraClasse, ddl_Total};
    cellRecapitulatif(2:3,4) = {CM_F, CM_R};
    cellRecapitulatif(2,5) = {F};
    
    % Dans les tables trouvees sur internet pour la distribution de F :
    % - les colonnes correspondent aux degres de liberte Inter-Classes
    % - les lignes correspondent aux degres de liberte Intra-Classe
    
end