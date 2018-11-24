function [numFigure]=afficherTableauRecapitulatif(cellRecapitulatif, numFigure, titre)
    
    t = uitable(figure(numFigure), 'Data', cellRecapitulatif, 'units', 'normalized');
    numFigure=numFigure+1;

    t.BackgroundColor=[1 1 1];
    %t.BeingDeleted= 'off'
    %t.BusyAction='queue'
    %t.ButtonDownFcn= ''
    %t.CellEditCallback= @ageCheckCB
    %t.CellSelectionCallback= ''
    %t.Children= [0x0 handle]
    %t.ColumnEditable [0 1 1 1 1 1]
    %t.ColumnFormat= {[]  []  []  []  {1x4 cell}}
    t.ColumnName= [];
    t.ColumnWidth= {100 100  'auto'  'auto'  'auto' 110};
    %t.CreateFcn= ''
    %t.Data= {100x5 cell}
    %t.DeleteFcn= ''
    %t.Enable= 'on'
    %t.Extent= [0 0 479 1940]
    %t.FontAngle= 'normal'
    t.FontName= 'Times New Roman';
    t.FontSize= 14;
    t.FontUnits= 'points';
    %t.FontWeight= 'normal'
    %t.ForegroundColor= [1 1 1]
    %t.HandleVisibility= 'on'
    %t.InnerPosition= [15 25 495 200]
    %t.Interruptible= 'on'
    %t.KeyPressFcn= ''
    %t.KeyReleaseFcn= ''
    %t.OuterPosition= [15 25 495 200]
    %t.Parent= [1x1 Figure]
    t.Position=[0 0 1 0.94]; % [left bottom width height]
    %t.RearrangeableColumns= 'off'
    t.RowName= [];
    %t.RowStriping= 'on'
    %t.Tag= ''
    %t.TooltipString: ''
    %t.Type= 'uitable'
    %t.UIContextMenu= []
    t.Units='pixels'; 
    %t.UserData= []
    %t.Visible= 'on'

    % Titre
    txt_title = uicontrol('Style', 'text', 'Position', [0 400 600 20],...
        'String', titre, 'FontWeight', 'bold', 'FontSize', 13, 'FontUnits', 'points');
end