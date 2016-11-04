-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, BCC, ci210 2013-2, autor: Roberto Hexsel, 28jul2015
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- mux2(a,b,s,z)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity mux2 is
  port(a,b : in  bit;                   -- entradas de dados
       s   : in  bit;                   -- entrada de selecao
       z   : out bit);                  -- saida
end mux2;

architecture estrut of mux2 is 

  -- declara componentes que sao instanciados
  component inv is
    port(A : in bit; S : out bit);
  end component inv;

  component nand2 is
    port(A,B : in bit; S : out bit);
  end component nand2;

  signal r, p, q : bit;              -- sinais internos
  
begin  -- compare ligacoes dos sinais com diagrama das portas logicas

  Ui:  inv   port map(s, r);
  Ua0: nand2 port map(a, r, p);
  Ua1: nand2 port map(b, s, q);
  Uor: nand2 port map(p, q, z);
    
end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- mux4(a,b,c,d,s0,s1,z)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity mux4 is
  port(a,b,c,d : in  bit;               -- quatro entradas de dados
       s0,s1   : in  bit;               -- dois sinais de selecao
       z       : out bit);              -- saida
end mux4;

architecture estrut of mux4 is 

  component mux2 is
    port(A,B : in  bit; S : in  bit; Z : out bit);
  end component mux2;

  signal p,q : bit;                     -- sinais internos
begin

  -- implemente usando tres mux2
  Um0: mux2 port map(a, b, s0, p);
  Um1: mux2 port map(c, d, s0, q);
  Um2: mux2 port map(p, q, s1, z);

end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- mux8(a,b,c,d,e,f,g,h,s0,s1,s2,z)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity mux8 is
  port(a,b,c,d,e,f,g,h : in  bit;       -- oito entradas de dados
       s0,s1,s2        : in  bit;       -- tres sinais de controle
       z               : out bit);      -- saida
end mux8;

architecture estrut of mux8 is 

  component mux2 is
    port(A,B : in  bit; S : in  bit; Z : out bit);
  end component mux2;

  component mux4 is
    port(A,B,C,D : in  bit; S0,S1 : in  bit; Z : out bit);
  end component mux4;

  signal p,q : bit;                     -- sinais internos
  
begin
  
  -- implemente usando dois mux4 e um mux2
  Um0: mux4 port map(a, b, c, d, s0, s1, p);
  Um1: mux4 port map(e, f, g, h, s0, s1, q);
  Um2: mux2 port map(p, q, s2, z);

end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- mux8vet(entr(7downto0),sel(2downto1),z)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity mux8vet is
  port(entr : in  reg8;
       sel  : in  reg3;
       z    : out bit);
end mux8vet;

architecture estrut of mux8vet is 

  component mux2 is
    port(A,B : in  bit; S : in  bit; Z : out bit);
  end component mux2;

  component mux4 is
    port(A,B,C,D : in  bit; S0,S1 : in  bit; Z : out bit);
  end component mux4;

  signal x, y : bit;
  
begin

  -- implemente usando dois mux4 e um mux2
  Um0: mux4 port map(entr(0), entr(1), entr(2), entr(3), sel(0), sel(1), x);
  Um1: mux4 port map(entr(4), entr(5), entr(6), entr(7), sel(0), sel(1), y);
  Um2: mux2 port map(x, y, sel(2), z);

end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- demux2(a,s,z,w)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity demux2 is
  port(a   : in  bit;
       s   : in  bit;
       z,w : out bit);
end demux2;

architecture estrut of demux2 is 

-- declara componentes que sao instanciados
  component inv is
    port(A : in bit; S : out bit);
  end component inv;

  component nand2 is
    port(A,B : in bit; S : out bit);
  end component nand2;

  signal r, p, q : bit;              -- sinais internos

begin

  -- implemente com portas logicas
  Ua0: nand2 port map(a, s, r);
  Ui0:  inv   port map(r, z);
  
  Ui1:  inv   port map(a, p);
  Ua1: nand2 port map(p, s, q);
  Ui2:  inv   port map(q, w);

end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- demux4(a,s0,s1,x,y,z,w)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity demux4 is
  port(a       : in  bit;
       s0,s1   : in  bit;
       x,y,z,w : out bit);
end demux4;

architecture estrut of demux4 is
	component demux2 is
    port(A, S : in  bit; Z, W : out bit);
  end component demux2;
  
  signal p, q : bit;
begin
  -- implemente com demux2
  Ud0: demux2 port map(a, s0, p, q);
  Ud1: demux2 port map(p, s1, x, y);
  Ud2: demux2 port map(q, s1, z, w);
  

end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- demux8(a,s0,s1,s2,p,q,r,s,t,u,v,w)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity demux8 is
  port(a               : in  bit;
       s0,s1,s2        : in  bit;
       p,q,r,s,t,u,v,w : out bit);
end demux8;

architecture estrut of demux8 is
  component demux2 is
    port(A, S : in  bit; Z, W : out bit);
  end component demux2;
  
  component demux4 is
    port(A, S0, S1 : in  bit; X, Y, Z, W : out bit);
  end component demux4;
  
  signal i, j : bit;
begin
  -- implemente com demux4
  Ud0: demux2 port map(a, s0, i, j);
  Ud1: demux4 port map(i, s1, s2, p, q, r, s);
  Ud2: demux4 port map(j, s1, s2, t, u, v, w);

end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- sel2(s,z,w)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity sel2 is
  port(s   : in  bit;
       z,w : out bit);
end sel2;

architecture estrut of sel2 is 
   component inv is
     port (A : in bit; S : out bit);
   end component inv;
begin

  Ui: inv port map(S, z);
  w <= S;

end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- sel4(s0,s1,x,y,z,w)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity sel4 is
  port(s0,s1   : in  bit;
       x,y,z,w : out bit);
end sel4;

architecture estrut of sel4 is
	component sel2 is
    port(S : in  bit; Z, W : out bit);
  end component sel2;
  
  component demux2 is
    port(A, S : in  bit; Z, W : out bit);
  end component demux2;
	
	signal p, q : bit;
begin
	
  -- implemente com dois sel2
	Us0: sel2 port map(s0, p, q);
	Ud0: demux2 port map(p, s1, x, y);
	Ud1: demux2 port map(q, s1, z, w);

end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- sel8(s0,s1,s2,p,q,r,s,t,u,v,w)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity sel8 is
  port(s0,s1,s2        : in  bit;
       p,q,r,s,t,u,v,w : out bit);
end sel8;

architecture estrut of sel8 is 
  component sel2 is
    port (s : in bit; z, w : out bit);
  end component sel2;

  component demux4 is
    port (a, s0, s1 : in bit; x,y,z,w : out bit);
  end component demux4;

  signal f, g : bit;
begin
  
  -- implemente com dois sel4
  Us : sel2 port map (s0, f, g);
  Ud1: demux4 port map(f, s1, s2, p,q,r,s);
  Ud2: demux4 port map(g, s1, s2, t,u,v,w);
end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
