function A_el = el_mtx(pos)
    A_el = zeros(3,3);
    e1 = pos(3,:) - pos(2,:);
    e2 = pos(1,:) - pos(3,:);
    e3 = pos(2,:) - pos(1,:);
    Atot = (1/2)*(e2(1)*e3(2)-e2(2)*e3(1));
    if (Atot < 0)
        Atot = - Atot;
    end
    grad_phi1 = [-e1(2), e1(1)]/(2*Atot);
    grad_phi2 = [-e2(2), e2(1)]/(2*Atot);
    grad_phi3 = [-e3(2), e3(1)]/(2*Atot);
    grad_phi = [grad_phi1; grad_phi2; grad_phi3];
    for i = 1:3
        for j = 1:3
            A_el(i,j) = grad_phi(i,:)*transpose(grad_phi(j,:))*Atot;
        end
    end
end
    
    
