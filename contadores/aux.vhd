-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, BCC, ci210                        autor: Roberto Hexsel, 21nov2012
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- ESTE ARQUIVO NAO PODE SER ALTERADO

--------------------------------------------------------------------------
-- Material adaptado de The Designer's Guide to VHDL [Ashenden96], e
--  Sistemas Digitais e microprocessadores [Hexsel12].
--------------------------------------------------------------------------


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- inversor
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--library IEEE; use IEEE.std_logic_1164.all;
              use work.p_wires.all;

entity inv is
  generic (prop : time := t_inv);
  port(A : in bit;
       S : out bit);
end inv;

architecture comport of inv is 
begin
    S <= (not A) after prop;
end architecture comport;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta AND de 2 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all; use work.p_wires.all;

entity and2 is
  generic (prop : time := t_and2);
  port(A,B : in bit;
       S   : out bit);
end and2;

architecture comport of and2 is 
begin
  S <= reject t_rej inertial (A and B) after prop;
end architecture comport;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta AND de 3 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all; use work.p_wires.all;

entity and3 is
  generic (prop : time := t_and3);
  port(A,B,C : in bit;
       S     : out bit);
end and3;

architecture comport of and3 is 
begin
  S <= reject t_rej inertial (A and B and C) after prop;
end architecture comport;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta OR de 2 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all; use work.p_wires.all;

entity or2 is
  generic (prop : time := t_or2);
  port(A,B : in bit;
       S   : out bit);
end or2;

architecture comport of or2 is 
begin
  S <= reject t_rej inertial (A or B) after prop;
end architecture comport;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta OR de 3 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all; use work.p_wires.all;

entity or3 is
  generic (prop : time := t_or3);
  port(A,B,C : in bit;
       S     : out bit);
end or3;

architecture comport of or3 is 
begin
  S <= reject t_rej inertial (A or B or C) after prop;
end architecture comport;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta XOR de 2 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all; use work.p_wires.all;

entity xor2 is
  generic (prop : time := t_xor2);
  port(A,B : in bit;
       S   : out bit);
end xor2;

architecture comport of xor2 is 
begin
  S <= reject t_rej inertial (A xor B) after prop;
end architecture comport;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- porta XOR de 3 entradas
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all; use work.p_wires.all;

entity xor3 is
  generic (prop : time := t_xor3);
  port(A,B,C : in bit;
       S     : out bit);
end xor3;

architecture comport of xor3 is 
begin
  S <= reject t_rej inertial (A xor B xor C) after prop;
end architecture comport;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- mux2(a,b,s,z)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all; use work.p_wires.all;

entity mux2 is
  port(A,B : in  bit;
       S   : in  bit;
       Z   : out bit);
end mux2;

architecture estrut of mux2 is 
  component inv is
    generic (prop : time);
    port(A : in bit; S : out bit);
  end component inv;
  component and2 is
    generic (prop : time);
    port(A,B : in bit; S : out bit);
  end component and2;
  component or2 is
    generic (prop : time);
    port(A,B : in bit; S : out bit);
  end component or2;
  signal negs,f0,f1 : bit;
 begin

  Ui:  inv  generic map (t_inv)  port map(s,negs);
  Ua0: and2 generic map (t_and2) port map(a,negs,f0);
  Ua1: and2 generic map (t_and2) port map(b,s,f1);
  Uor: or2  generic map (t_or2)  port map(f0,f1,z);
    
end architecture estrut;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- flip-flop tipo D com set e reset
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_WIRES.all;

entity FFD is
  generic (prop : time := t_FFD);
  port(rel, rst, set : in bit;
        D : in  bit;
        Q : out bit);
end FFD;

architecture funcional of FFD is
  signal estado : bit := '0';
begin

  process(rel, rst, set)
  begin
    if rst = '0' then
      estado <= '0';
    elsif set = '0' then
      estado <= '1';
    elsif rising_edge(rel) then
      estado <= D;
    end if;
  end process;

  Q <= estado after prop;

end funcional;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- flip-flop tipo T com set e reset
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_WIRES.all;

entity FFT is
  generic (prop : time := t_FFT);
  port(rel, rst, set : in bit;
        D : in  bit;
        Q,Qn : out bit);
end FFT;

architecture funcional of FFT is
  signal estado : bit := '0';
begin

  process(rel, rst, set)
  begin
    if rst = '0' then
      estado <= '0';
    elsif set = '0' then
      estado <= '1';
    elsif rising_edge(rel) then
      estado <= D xor estado;
    end if;
  end process;

  Q  <= estado after prop;
  Qn <= not(estado) after prop;

end funcional;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

