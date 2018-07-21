[P,T] = geracao_grelha();
%fd=inline('ddiff(drectangle(p,-0.5,0.5,-0.5,0.5),dcircle(p,-0.5,-0.5,0.5))','p');
fd=inline('drectangle(p,-0.5,0.5,-0.5,0.5)','p'); %na zona curva o potencial nao e conhecido, pelo que nao incluo os pontos desta zona como pontos fronteira
f_side = 10; %condicao fronteira 10V

[x,y]=meshgrid(-0.5:0.1:0.5,-0.5:0.1*sqrt(3)/2:0.5);
x(2:2:end,:)=x(2:2:end,:)+0.1/2;

f_bottom = 0; %condicao fronteira fundo
noNum = size(P, 1);
triNum = size(T,1);
npf = 0; %numero de pontos fronteira
p_f = fd(P);
pontos_f = zeros(length(p_f),1);
for i = 1:noNum
    if abs(p_f(i)) < 0.001 & (P(i,1) < 0.49 & P(i,2) < 0.49) %alguns pontos de fronteira nao estao exatamente na fronteira - ha uma tolerancia.  excluir também os pontos onde a condição fronteira não é de dirichlet
        npf = npf+1;
        pontos_f(npf) = i;
    end
end
pontos_f = pontos_f(pontos_f > 0);%eliminar os zeros
P(pontos_f,:)
all_nodes = 1:noNum;
p_int = setdiff(all_nodes, pontos_f);
A = zeros(noNum);
b = zeros(noNum,1);

for ind = 1:triNum % calcular os elementos da matriz
    nodes = T(ind,:);
    xy = P(nodes,:);
    A_el = el_mtx(xy);
    A(nodes, nodes) = A(nodes, nodes) + A_el;
    
end

A_f = A(pontos_f, p_int);
A_int = A(p_int,p_int);
z = zeros(noNum, 1);
%P(P(:,1) < -0.49) = -0.5; %colocar fronteira lateral exatamente a 0.5 (abcissa)
z(P(pontos_f,1) < -0.49) = f_side;
z_f = z(pontos_f);
b_int = b(p_int);
z_int = A_int\(b_int-transpose(A_f)*z_f);
z = zeros(noNum,1);
z(pontos_f) = z_f;
z(p_int) = z_int;
trisurf(T,P(:,1),P(:,2), z)
size(b)
size(z)
h = 1; %assumindo espessura unitária
Pw = h * transpose(z)*A*z %potência dissipada
R = (f_side^2)/Pw %resistência do prato




