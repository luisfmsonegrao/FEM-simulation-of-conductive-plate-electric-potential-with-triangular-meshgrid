function res = phi(r, r1, r2, r3);

    function valor = prod_vec_2d( x, y )
        valor = x(1)*y(2) - x(2)*y(1);
    end

   r12 = r1 - r2;
   r32 = r3 - r2;
   
   rrel = r - r2;
   
   Atotal = 1/prod_vec_2d( r12, r32);
   
   res = Atotal*prod_vec_2d( rrel, r32 );
   
end