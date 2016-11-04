-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, BCC, ci210 2013-2, autor: Roberto Hexsel, 25ago2016
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- mux2(a,b,s,z)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity mux2 is
  port(A,B : in  bit;                   -- entradas de dados
       S   : in  bit;                   -- entrada de selecao
       Z   : out bit);                  -- saida
end mux2;

architecture estrut of mux2 is 

  -- declara componentes que sao instanciados
  component inv is
    generic (prop : time; cont : time);
    port(A : in bit; S : out bit);
  end component inv;

  component nand2 is
    generic (prop : time; cont : time);
    port(A,B : in bit; S : out bit);
  end component nand2;

  component nor2 is
    generic (prop : time; cont : time);
    port(A,B : in bit; S : out bit);
  end component nor2;

  component nand3 is
    generic (prop : time; cont : time);
    port(A,B,C : in bit; S : out bit);
  end component nand3;


  signal p, q, r: bit;  -- sinais internos
  
begin  -- compare ligacoes dos sinais com diagrama das portas logicas

  Ui:  inv   generic map (t_inv,   t_cont) port map(s, r);
  Ua0: nand2 generic map (t_nand2, t_cont) port map(a, r, p);
  Ua1: nand2 generic map (t_nand2, t_cont) port map(b, s, q);
  Uor: nand2 generic map (t_nand2, t_cont) port map(p, q, z);
  
end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- mux4(a,b,c,d,s0,s1,z)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity mux4 is
  port(A,B,C,D : in  bit;               -- quatro entradas de dados
       S0,S1   : in  bit;               -- dois sinais de selecao
       Z       : out bit);              -- saida
end mux4;

architecture estrut of mux4 is 

  component mux2 is
    port(A,B : in  bit; S : in  bit; Z : out bit);
  end component mux2;

  signal p,q : bit;                   -- sinais internos
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
  port(A,B,C,D,E,F,G,H : in  bit;       -- oito entradas de dados
       S0,S1,S2        : in  bit;       -- tres sinais de controle
       Z               : out bit);      -- saida
end mux8;

architecture estrut of mux8 is 

  component mux2 is
    port(A,B : in  bit; S : in  bit; Z : out bit);
  end component mux2;

  component mux4 is
    port(A,B,C,D : in  bit; S0,S1 : in  bit; Z : out bit);
  end component mux4;

  signal p,q : bit;                   -- sinais internos
  
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
       Z    : out bit);
end mux8vet;

architecture muxwithselect of mux8vet is
begin
	with sel select
          Z <= entr(0) when "000",
               entr(1) when "001",
               entr(2) when "010",
               entr(3) when "011",
               entr(4) when "100",
               entr(5) when "101",
               entr(6) when "110",
               entr(7) when others;
end architecture muxwithselect;

architecture muxwhenelse of mux8vet is
begin
	Z <= entr(0) when (sel = "000") else
	     entr(1) when (sel = "001") else
	     entr(2) when (sel = "010") else
	     entr(3) when (sel = "011") else
	     entr(4) when (sel = "100") else
	     entr(5) when (sel = "101") else
	     entr(6) when (sel = "110") else
	     entr(7);
end architecture muxwhenelse;

architecture estrut of mux8vet is 

  component mux2 is
    port(A,B : in  bit; S : in  bit; Z : out bit);
  end component mux2;

  component mux4 is
    port(A,B,C,D : in  bit; S0,S1 : in  bit; Z : out bit);
  end component mux4;

  signal x,y : bit;                   -- sinais internos
  
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
  port(A   : in  bit;
       S   : in  bit;
       Z,W : out bit);
end demux2;

architecture estrut of demux2 is 

-- declara componentes que sao instanciados
  component inv is
    generic ( prop : time ; cont : time );
    port(A : in bit; S : out bit);
  end component inv;

  component nand2 is
    generic ( prop : time ; cont : time );
    port(A,B : in bit; S : out bit);
  end component nand2;

  signal r, p, q : bit;              -- sinais internos

begin

  -- implemente com portas logicas
  Ua0: nand2 generic map (t_nand2, t_cont)  port map(a, s, r);
  Ui0:  inv  generic map (t_inv, t_cont)    port map(r, z);

  Ui1:  inv  generic map (t_inv, t_cont)    port map(a, p);
  Ua1: nand2 generic map (t_nand2, t_cont)  port map(p, s, q);
  Ui2:  inv  generic map (t_inv, t_cont)    port map(q, w);

end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- demux4(a,s0,s1,x,y,z,w)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity demux4 is
  port(A       : in  bit;
       S0,S1   : in  bit;
       X,Y,Z,W : out bit);
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
  port(A               : in  bit;
       s0,s1,s2        : in  bit;
       P,Q,R,S,T,U,V,W : out bit);
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
-- decod2(s,z,w)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity decod2 is
  port(S   : in  bit;
       Z,W : out bit);
end decod2;

architecture estrut of decod2 is 
  component inv is
    generic ( prop : time ; cont : time );
    port (A: in bit; S : out bit);
  end component inv;
begin

  Ui: inv generic map (t_inv, t_cont) port map(S, z);
  w <= S;

end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- decod4(s0,s1,x,y,z,w)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity decod4 is
  port(S0,S1   : in  bit;
       X,Y,Z,W : out bit);
end decod4;

architecture estrut of decod4 is
  component decod2 is
    port(S : in bit; Z, W : out bit);
  end component decod2;

  component demux2 is
    port(A, S : in bit; Z, W : out bit);
  end component demux2;

  signal p, q : bit;
begin
  
  -- implemente com decod2 e demux
   Us0: decod2 port map(s0, p, q);
   Ud0: demux2 port map(p, s1, x, y);
   Ud1: demux2 port map(q, s1, z, w);

end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- decod8(s0,s1,s2,p,q,r,s,t,u,v,w)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity decod8 is
  port(S0,S1,S2        : in  bit;
       P,Q,R,S,T,U,V,W : out bit);
end decod8;

architecture estrut of decod8 is 
  component decod2 is
    port (s : in bit; z, w : out bit);
  end component decod2;

  component demux4 is
    port (a, s0, s1 : in bit; x,y,z,w : out bit);
  end component demux4;

  signal f, g : bit;

begin

  -- implemente com decod2 e demux
  Us : decod2 port map (s0, f, g);
  Ud1: demux4 port map(f, s1, s2, p,q,r,s);
  Ud2: demux4 port map(g, s1, s2, t,u,v,w);
end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
