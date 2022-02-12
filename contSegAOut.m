function patchChild = contSegAOut( contAngle, cont, mcsn, ocsn)  
% Create patches corresponding to bullseye segments starts from -180 degrees 
% Input:
%   - contAngle: angles of contours points
%   - cont: contours points
%   - mcsn is the middle levels number of desired segments 
%   - ocsn is the outer level number of desired segments 

    othStep = round(360/ocsn);
    patchChild = [];
    thStart = -180;
    angleso = thStart:othStep:(thStart+360);
    for j = 1:length(angleso)
        [mv, mio(1,j)] = min(abs(contAngle{1}-angleso(j))); 
        mind = find(abs(contAngle{2}-angleso(j))<10); 
        [med, medi] = min(sqrt((cont{2}(1,mind)'-cont{1}(1,mio(1,j))).^2 + (cont{2}(2,mind)'-cont{1}(2,mio(1,j))).^2 ));
        mio(2,j) = mind(medi);
    end
    
    mthStep = round(360/mcsn);
    angles = thStart:mthStep:(thStart+360);
    for j = 1:length(angles)
        [mv, mi(1,j)] = min(abs(contAngle{1}-angles(j))); 
    end
    for i = 2:length(cont)
        for j = 1:length(angles)
            mind = find(abs(contAngle{i}-angles(j))<10); 
            [med, medi] = min(sqrt((cont{i}(1,mind)'-cont{i-1}(1,mi(i-1,j))).^2 + (cont{i}(2,mind)'-cont{i-1}(2,mi(i-1,j))).^2 ));
            mi(i,j) = mind(medi);   
        end
    end

    patchChild = [patchChild; patch('XData',cont{end}(1,:),'YData',cont{end}(2,:), 'EdgeColor','green','FaceColor','none','LineWidth',2)];
    for i = 2:length(cont)-1
        for j = 1:length(angles)-1
            if mi(i,j)==max(mi(i,:))
                cont1x = [cont{i}(1,mi(i,j):end) cont{i}(1,1:mi(i,j+1))];
                cont1y = [cont{i}(2,mi(i,j):end) cont{i}(2,1:mi(i,j+1))];
            else
                cont1x = cont{i}(1,mi(i,j):mi(i,j+1)); 
                cont1y = cont{i}(2,mi(i,j):mi(i,j+1)); 
            end
            if mi(i+1,j)==max(mi(i+1,:))
                cont2x = [cont{i+1}(1,mi(i+1,j+1):-1:1) cont{i+1}(1,end:-1:mi(i+1,j))];
                cont2y = [cont{i+1}(2,mi(i+1,j+1):-1:1) cont{i+1}(2,end:-1:mi(i+1,j))];
            else
                cont2x = cont{i+1}(1,mi(i+1,j+1):-1:mi(i+1,j));
                cont2y = cont{i+1}(2,mi(i+1,j+1):-1:mi(i+1,j));
            end
            patchChild = [patchChild;  patch('XData',[cont1x cont2x],'YData',[cont1y cont2y], 'EdgeColor','green','FaceColor','none','LineWidth',2)];
        end
    end
         for j = 1:length(angleso)-1
            if mio(1,j) == max(mio(1,:))
                cont1x = [cont{1}(1,mio(1,j):end) cont{1}(1,1:mio(1,j+1))];
                cont1y = [cont{1}(2,mio(1,j):end) cont{1}(2,1:mio(1,j+1))];
            else
                cont1x = cont{1}(1,mio(1,j):mio(1,j+1)); 
                cont1y = cont{1}(2,mio(1,j):mio(1,j+1)); 
            end
            if mio(2,j) == max(mio(2,:))
                cont2x = [cont{2}(1,mio(2,j+1):-1:1) cont{2}(1,end:-1:mio(2,j))];
                cont2y = [cont{2}(2,mio(2,j+1):-1:1) cont{2}(2,end:-1:mio(2,j))];
            else
                cont2x = cont{2}(1,mio(2,j+1):-1:mio(2,j));
                cont2y = cont{2}(2,mio(2,j+1):-1:mio(2,j));
            end
            patchChild = [patchChild; patch('XData',[cont1x cont2x],'YData',[cont1y cont2y], 'EdgeColor','green','FaceColor','none','LineWidth',2)];
        end
end