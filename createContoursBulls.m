function BWS = createContoursBulls( msk, lev, mcsn, ocsn) 
%  Draw and return bullseye label image ( assigning each bullseye segment a
%  unique label) corresponding  to input mask
% Input:
%   - msk: outer mask of the bullseye
%   - lev: no. of inner contours 
%   - mcsn is the middle levels number of desired segments 
%   - ocsn is the outer level number of desired segments 
%  Example:
%   bw = createContoursBulls( mask, 2, 4, 6);

[B,L] = bwboundaries(msk,'noholes');
lvxy{1} = circshift( B{1}',1);
edtImage = bwdist(~msk);
m = contour( edtImage, lev ,'LineColor','Red');
[maxEDT,indc] = max(edtImage(:));
[yCen,xCen] = ind2sub(size(edtImage),indc);

% lvxy{k}: contour K points 
ind = 1;
lv = [];
lvp = [];
i = 1;
while ind<size(m,2)
    in = inpolygon(xCen,yCen,m(1,ind+1:ind+m(2,ind)),m(2,ind+1:ind+m(2,ind)));
    if (i>1&&m(1,ind)==lv(i-1)&&m(2,ind)>lvp(i-1)&&in==1)%~(i==1||(i>1&&m(1,ind)~=lv(i-1)))
        i = i-1;
        lv(i) = m(1,ind);
        lvp(i) = m(2,ind);
        lvxy{i+1} = m(:,ind+1:ind+m(2,ind));
        i=i+1;
    elseif (i==1||(i>1&&m(1,ind)~=lv(i-1)))
        lv(i) = m(1,ind);
        lvp(i) = m(2,ind);
        lvxy{i+1} = m(:,ind+1:ind+m(2,ind));
        i=i+1;   
    end
    ind = ind+m(2,ind)+1;
end
% pixelangle{k}: angles of contour K points
for k=1:length(lvxy)
    [angle,rho] = cart2pol(lvxy{k}(1,:)-xCen,lvxy{k}(2,:)-yCen); 
    pixelangle{k} = ((angle/(pi*2)) * 360);
end
% Create patches corresponding to bullseye segments 
ps = contSegAOut(pixelangle,lvxy,mcsn, ocsn);

% Create labels corresponding to bullseye segments 
BWS = zeros(size(msk,1),size(msk,2));
for i = 1: size(ps,1)
    bw = poly2mask(ps(i).XData,ps(i).YData,size(msk,1),size(msk,2));
    BWS(bw) = i;
end
imshow(imfuse(squeeze(edtImage),label2rgb(BWS),'blend'));
hold on, plot( xCen, yCen, 'r+')