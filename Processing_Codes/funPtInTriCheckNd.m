function ptInTriOrNot = funPtInTriCheckNd(TriNodeCoord,PtToCheckCoord)
%FUNPTINTRICHECK: To check N points inside or outside a given DIM-dimensional simplex [1].
%
% In geometry, a simplex is a generalization of the notion of a triangle or 
% tetrahedron to arbitrary dimensions. 
% E.g.: A 2D simplex is a triangle. A 3D simplex is a tetrahedral. 
%
%   ptInTriOrNot = funPtInTriCheck(TriNodeCoord,PtToCheckCoord)
%   
%   INPUT: 
%       DIM-dimention simplex node coordinates:  TriNodeCoord: (DIM+1)*DIM matrix
%                                   [coordx_triangle_pt1, coordy_triangle_pt1, ... , coordDIM_triangle_pt1 ;
%                                    coordx_triangle_pt2, coordy_triangle_pt2, ... , coordDIM_triangle_pt2 ;
%                                    coordx_triangle_pt3, coordy_triangle_pt3, ... , coordDIM_triangle_pt3 ;
%                                    ...                  ...                  ...              
%                                    coordx_triangle_pt(DIM+1), coordy_triangle_pt(DIM+1), ... , coordDIM_triangle_pt(DIM+1)];
%
%      Coordinates of the checking points:  PtToCheckCoord: N*DIM matrix with N points to check
%                                   [coordx_pti, coordy_pti, ... , coordDIM_pti] = PtToCheckCoord(i,1:DIM)
%
%   OUTPUT:
%       Logical variable: ptInTriOrNot: N*1 vector
%                         1 --> Yes, point is inside the given triangle
%                         0 --> No,  point is outside the given triangle
%
% -----------------------------------------------
% Author: Jin Yang (jyang526@wisc.edu)
% Date: 07-07-2020
%
% Reference
% [1] Simplex. https://en.wikipedia.org/wiki/Simplex
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DIM = size(TriNodeCoord,2);
ptInTriOrNot = nan(size(PtToCheckCoord,1),1);

%%
if DIM == 3
    
    pt1x = TriNodeCoord(1,1); pt1y = TriNodeCoord(1,2); pt1z = TriNodeCoord(1,3);
    pt2x = TriNodeCoord(2,1); pt2y = TriNodeCoord(2,2); pt2z = TriNodeCoord(2,3);
    pt3x = TriNodeCoord(3,1); pt3y = TriNodeCoord(3,2); pt3z = TriNodeCoord(3,3);
    pt4x = TriNodeCoord(4,1); pt4y = TriNodeCoord(4,2); pt4z = TriNodeCoord(4,3);
    
    pointOfx = PtToCheckCoord(:,1); pointOfy = PtToCheckCoord(:,2); pointOfz = PtToCheckCoord(:,3);

    % =================
    pt1x=pointOfx; pt1y=pointOfy; pt1z=pointOfz; 
    b1 = sign( pt1x*pt2z*pt3y - pt1x*pt2y*pt3z + pt1y*pt2x*pt3z - pt1y*pt3x*pt2z - pt2x*pt1z*pt3y + ...
        pt1z*pt2y*pt3x + pt1x*pt2y*pt4z - pt1x*pt2z*pt4y - pt1y*pt2x*pt4z + pt1y*pt2z*pt4x + ...
        pt2x*pt1z*pt4y - pt1z*pt2y*pt4x - pt1x*pt3y*pt4z + pt1x*pt3z*pt4y + pt1y*pt3x*pt4z - ...
        pt1y*pt4x*pt3z - pt1z*pt3x*pt4y + pt1z*pt3y*pt4x + pt2x*pt3y*pt4z - pt2x*pt3z*pt4y - ...
        pt2y*pt3x*pt4z + pt2y*pt4x*pt3z + pt3x*pt2z*pt4y - pt2z*pt3y*pt4x );
    
    pt1x=TriNodeCoord(1,1); pt1y=TriNodeCoord(1,2); pt1z=TriNodeCoord(1,3); pt2x=pointOfx; pt2y=pointOfy; pt2z=pointOfz;
    b2 = sign(  pt1x*pt2z*pt3y - pt1x*pt2y*pt3z + pt1y*pt2x*pt3z - pt1y*pt3x*pt2z - pt2x*pt1z*pt3y + ...
        pt1z*pt2y*pt3x + pt1x*pt2y*pt4z - pt1x*pt2z*pt4y - pt1y*pt2x*pt4z + pt1y*pt2z*pt4x + ...
        pt2x*pt1z*pt4y - pt1z*pt2y*pt4x - pt1x*pt3y*pt4z + pt1x*pt3z*pt4y + pt1y*pt3x*pt4z - ...
        pt1y*pt4x*pt3z - pt1z*pt3x*pt4y + pt1z*pt3y*pt4x + pt2x*pt3y*pt4z - pt2x*pt3z*pt4y - ...
        pt2y*pt3x*pt4z + pt2y*pt4x*pt3z + pt3x*pt2z*pt4y - pt2z*pt3y*pt4x );
    
    pt2x=TriNodeCoord(2,1); pt2y=TriNodeCoord(2,2); pt2z=TriNodeCoord(2,3); pt3x=pointOfx; pt3y=pointOfy; pt3z=pointOfz;
    b3 = sign( pt1x*pt2z*pt3y - pt1x*pt2y*pt3z + pt1y*pt2x*pt3z - pt1y*pt3x*pt2z - pt2x*pt1z*pt3y + ...
        pt1z*pt2y*pt3x + pt1x*pt2y*pt4z - pt1x*pt2z*pt4y - pt1y*pt2x*pt4z + pt1y*pt2z*pt4x + ...
        pt2x*pt1z*pt4y - pt1z*pt2y*pt4x - pt1x*pt3y*pt4z + pt1x*pt3z*pt4y + pt1y*pt3x*pt4z - ...
        pt1y*pt4x*pt3z - pt1z*pt3x*pt4y + pt1z*pt3y*pt4x + pt2x*pt3y*pt4z - pt2x*pt3z*pt4y - ...
        pt2y*pt3x*pt4z + pt2y*pt4x*pt3z + pt3x*pt2z*pt4y - pt2z*pt3y*pt4x );
    
    pt3x=TriNodeCoord(3,1); pt3y=TriNodeCoord(3,2); pt3z=TriNodeCoord(3,3); pt4x=pointOfx; pt4y=pointOfy; pt4z=pointOfz;
    b4 = sign( pt1x*pt2z*pt3y - pt1x*pt2y*pt3z + pt1y*pt2x*pt3z - pt1y*pt3x*pt2z - pt2x*pt1z*pt3y + ...
        pt1z*pt2y*pt3x + pt1x*pt2y*pt4z - pt1x*pt2z*pt4y - pt1y*pt2x*pt4z + pt1y*pt2z*pt4x + ...
        pt2x*pt1z*pt4y - pt1z*pt2y*pt4x - pt1x*pt3y*pt4z + pt1x*pt3z*pt4y + pt1y*pt3x*pt4z - ...
        pt1y*pt4x*pt3z - pt1z*pt3x*pt4y + pt1z*pt3y*pt4x + pt2x*pt3y*pt4z - pt2x*pt3z*pt4y - ...
        pt2y*pt3x*pt4z + pt2y*pt4x*pt3z + pt3x*pt2z*pt4y - pt2z*pt3y*pt4x ) ;
    
    ptInTriOrNot = 1-logical(sign(abs(b1-b2)+abs(b2-b3)+abs(b3-b4)));
    
    
else 
    %% DIM>3, but this step is slow
    
    for ptInd = 1:size(PtToCheckCoord,1) % For each checking point
        
        bVector = zeros(DIM+1,1);
        for DIMInd = 1:DIM+1
            
            tempMat = [ones(DIM+1,1), TriNodeCoord]; tempMat(DIMInd,:)=[1,PtToCheckCoord(ptInd,:)];
            bVector(DIMInd) = sign( det(tempMat) );
            
        end
        
        ptInTriOrNot(ptInd) = 1-logical(sign( sum( abs(bVector(2:end)-bVector(1:end-1)) ) ));
        
    end
    
end
 


end

 


