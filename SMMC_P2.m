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
p_f = fd(P); %p_f contém a distância de cada ponto à fronteira que lhe fica mais próxima. A funcao fd definida a cima faz este calculo automaticamente
pontos_f = zeros(length(p_f),1);
for i = 1:noNum % ciclo para determinar quais dos pontos estao na parte desejada da fronteira ( f = 10 em x=-0.,5 e y > 0 e f = 0 em y = -0.5 e x > 0)
    if abs(p_f(i)) < 0.001 & ((P(i,1) < -0.49 & P(i,2) >= 0) | (P(i,1)>=0 & P(i,2)<-0.49))  %alguns pontos de fronteira nao estao exatamente na fronteira - ha uma tolerancia.  excluir também os pontos onde a condição fronteira não é de dirichlet
        npf = npf+1;
        pontos_f(npf) = i; % colocar nodo nos pontos fronteira
    end
end
pontos_f = pontos_f(pontos_f > 0);%eliminar os zeros
all_nodes = 1:noNum;
p_int = setdiff(all_nodes, pontos_f); % pontos interiores / com condicao de fronteira na derivada do potencial
A = zeros(noNum);
b = zeros(noNum,1);

for ind = 1:triNum % calcular os elementos da matriz
    nodes = T(ind,:);
    xy = P(nodes,:);
    A_el = el_mtx(xy); %el_mtx calcula os elementos da matriz correspondentes a cada nodo
    A(nodes, nodes) = A(nodes, nodes) + A_el;
    
end

A_f = A(pontos_f, p_int); %parte correspondente aos nodos onde o potencial é conhecido
A_int = A(p_int,p_int); %parte onde e necessario calcular o potencial
z = zeros(noNum, 1); 
z(P(pontos_f,1) < -0.49) = f_side; % colocar o potencial a 10V na parte apropriada da fronteira
z_f = z(pontos_f);%parte conhecida da solucao
b_int = b(p_int); % b e zero por imposicao das condicoes fronteira em f e na derivada de f
z_int = A_int\(b_int-transpose(A_f)*z_f); %solucao nos pontos interiores e de fronteira com condicao fronteira na derivada de f
z = zeros(noNum,1);%construçao da soluçao total
z(pontos_f) = z_f;%construçao da soluçao total
z(p_int) = z_int; %construçao da solucao total
figure(2)
trisurf(T,P(:,1),P(:,2), z); title('Potencial (V)'); xlabel('x'); ylabel('y'); zlabel('U(V)'); %representação gráfica do potencial dentro do prato condutor
h = 1; %assumindo espessura unitária
Pw = h * transpose(z)*A*z %potência dissipada
R = (f_side^2)/Pw %resistência do prato = 2.03 ohms
%%
%representaçao grafica de uma funçºão base na fronteira e outra no interior
% não é 100% seguro que phi(p_int(30)) dê um ponto no interior do prato,
% pode dar um ponto numa das fronteiras onde a solução não é conhecida, mas
% eventualmente (ao fim de poucas tentativas, no pior caso) fará a representação correta
a=size(P);
a = a(1);
phi = zeros(a,1);
phi(p_int(30)) = 1;
phi(pontos_f(5)) = 1;
%figure(2)
%trisurf(T,P(:,1), P(:,2), phi) %representação gráfica das funções base utilizadas





