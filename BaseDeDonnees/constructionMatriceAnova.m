function [MatriceAnova]=constructionMatriceAnova(matriceDonnees, indice_colonneVariableQualitative, indice_colonneVariableQuantitative, cellNomVariablesQualitatives)

    % Identifier les indices des differents groupes dans la matrice de
    % donnees
    variableQualitativeUniques=unique(matriceDonnees(:,indice_colonneVariableQualitative));
    cellIndices=cell(1, length(variableQualitativeUniques));

    for i=1:length(variableQualitativeUniques)
        cellIndices{1,i}=find(matriceDonnees(:,indice_colonneVariableQualitative)==variableQualitativeUniques(i));
        Vecteur_effectif(i)=length(cellIndices{i});
    end

    % Trouver l'effectif minimum tous groupes confondus
    [effectifMin indiceEffectifMin]=min(Vecteur_effectif);
    disp(['L''effectif minimum est de ', num2str(effectifMin)]);
    disp(['Il correspond au groupe ', char(cellNomVariablesQualitatives(indiceEffectifMin))]);

    % Reduire l'effectif de chaque groupe a celui de l'effecif minimum
    for i=1:length(variableQualitativeUniques)
        cellIndices{1,i}=cellIndices{i}(1:effectifMin);
    end

    % Construire la matrice qui contient chaque groupe avec un meme effectif
    % (effectif minimum)
    for i=1:length(variableQualitativeUniques)
        MatriceAnova(:,i)=matriceDonnees(cellIndices{i}, indice_colonneVariableQuantitative);
    end

end