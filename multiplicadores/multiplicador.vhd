-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, BCC, ci210                        autor: Roberto Hexsel, 30ago2016
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- multiplica por 1 A(15..0)*B(i) => S(16..0)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all; use work.p_wires.all;

entity m_p_1 is
  port(A,B : in  reg16;                 -- entradas A,B
       S : in bit;                      -- bit por multiplicar
       R : out reg17);                  -- produto parcial
end m_p_1;

architecture funcional of m_p_1 is 

  component adderAdianta16 is port(inpA, inpB : in bit_vector;
                          outC : out bit_vector;
                          vem  : in  bit;
                          vai  : out bit);
  end component adderAdianta16;

  signal somaAB : reg17;

begin

  U_soma: adderAdianta16
    port map(A, B , somaAB(15 downto 0), '0', somaAB(16)); 

  -- defina a constante t_mux2 em packageWires.vhd
  R <= somaAB when S = '1' else ('0' & B) after t_mux2;

end funcional;
-- -------------------------------------------------------------------


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- multiplicador combinacional
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all; use IEEE.numeric_std.all;
use work.p_wires.all;

entity mult16x16 is
  port(A, B : in  reg16;   -- entradas A,B
       prod : out reg32);  -- produto
end mult16x16;

-- ======================================================================
-- especificação funcional para um multiplicador de 32 bits
-- ======================================================================
architecture funcional of mult16x16 is 
begin
  prod <= INT2BV32( BV2INT16(A) * BV2INT16(B) );
end funcional;
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- ------------------------------------------------------------------
-- descomente as linhas com --x para acrescentar o código do multiplicador
-- ------------------------------------------------------------------

 architecture estrutural of mult16x16 is 
 
   component m_p_1 is port(A,B : in  bit_vector;   -- reg16
                           S   : in  bit;
                           R   : out bit_vector);  -- reg17
   end component m_p_1;
 
   signal p01,p02,p03,p04,p05,p06,p07,p08: reg17;
   signal p09,p10,p11,p12,p13,p14,p15,p16: reg17;
 
 begin
 
    U_00: m_p_1 port map ( A, x"0000", B(0), p01);
    U_01: m_p_1 port map ( A, p01(16 downto 1), B(1), p02);
    U_02: m_p_1 port map ( A, p02(16 downto 1), B(2), p03);
    U_03: m_p_1 port map ( A, p03(16 downto 1), B(3), p04);
    U_04: m_p_1 port map ( A, p04(16 downto 1), B(4), p05);
    U_05: m_p_1 port map ( A, p05(16 downto 1), B(5), p06);
    U_06: m_p_1 port map ( A, p06(16 downto 1), B(6), p07);
    U_07: m_p_1 port map ( A, p07(16 downto 1), B(7), p08);
    U_08: m_p_1 port map ( A, p08(16 downto 1), B(8), p09);
    U_09: m_p_1 port map ( A, p09(16 downto 1), B(9), p10);
    U_10: m_p_1 port map ( A, p10(16 downto 1), B(10), p11);
    U_11: m_p_1 port map ( A, p11(16 downto 1), B(11), p12);
    U_12: m_p_1 port map ( A, p12(16 downto 1), B(12), p13);
    U_13: m_p_1 port map ( A, p13(16 downto 1), B(13), p14);
    U_14: m_p_1 port map ( A, p14(16 downto 1), B(14), p15);
    U_15: m_p_1 port map ( A, p15(16 downto 1), B(15), p16);
 
    prod <= p16 & p15(0) & p14(0) & p13(0) & p12(0) & p11(0) 
    			& p10(0) & p09(0) & p08(0) & p07(0) & p06(0) 
    			& p05(0) & p04(0) & p03(0) & p02(0) & p01(0);
   
 end estrutural;
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

