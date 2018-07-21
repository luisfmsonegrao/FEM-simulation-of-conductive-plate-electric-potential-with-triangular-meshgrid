function [P, T] = geracao_grelha

   fd=inline('ddiff(drectangle(p,-0.5,0.5,-0.5,0.5),dcircle(p,-0.5,-0.5,0.5))','p');
   fd
   %fd = ddiff(drectangle(p,-0.5,0.5,-0.5,0.5), dcircle(p,-0.5,-0.5,0.5))
   
   fh = @(p) 0.5 + 0.5*dcircle(p,-0.5,-0.5,0.5);
   
   pfix = [-0.50,  0.00; ...
           -0.50,  0.25; ...
           -0.50,  0.50; ...
            0.00,  0.50; ...
            0.50,  0.50; ...
            0.50,  0.25; ...
            0.50,  0.00; ...
            0.50, -0.25; ...
            0.50, -0.50; ...
            0.25, -0.50; ...
            0.00, -0.50];
        
        ang = 15;
        
        theta = ang;
        
        while theta < 90
            
            xp = -0.5 + 0.5*cos(theta*pi/180);
            yp = -0.5 + 0.5*sin(theta*pi/180);
            
            pfix = [pfix; xp, yp]
            
            theta = theta + ang
            
        end
        
        [p,t] = distmesh2d(fd,fh,0.05,[-0.5,-0.5;0.5,0.5],pfix);
        p
        t
        P = p;
        T = t;
        
        
%         input(' Continuar para distribuicao nao uniforme ? ');
%         
%         [p1,t1] = distmesh2d(fd,fh,0.05,[-0.5,-0.5;0.5,0.5],pfix);    
%         
%         fileID = fopen('uniform.inf','w');
%            fprintf(fileID,' %d \n', size(t,1));  %... numero de elementos
%            fprintf(fileID,' %d \n', size(p,1));  %... numero de vertices
%         fclose(fileID);
%         
%         fileID = fopen('meshuniform.txt','w');
%         fprintf(fileID,' %f %f \n',p);
%         fclose(fileID);
%         
%         fileID = fopen('triangleuniform.txt','w');
%         fprintf(fileID,' %d %d %d \n',t);
%         fclose(fileID);
%         
%         fileID = fopen('non_uniform.inf','w');
%            fprintf(fileID,' %d \n', size(t1,1));  %... numero de elementos
%            fprintf(fileID,' %d \n', size(p1,1));  %... numero de vertices
%         fclose(fileID);
% 
%         fileID = fopen('mesh_non_uniform.txt','w');
%         fprintf(fileID,' %f %f \n',p1);
%         fclose(fileID);
%         
%         fileID = fopen('triangle_non_uniform.txt','w');
%         fprintf(fileID,' %d %d %d \n',t1);
%         fclose(fileID);

end