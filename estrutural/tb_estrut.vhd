-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, BCC, ci210 2013-2 autor: Roberto Hexsel, 28jul2015
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para modelagem estrutural de circuitos combinacionais
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity tb_estrut is
end tb_estrut;

architecture TB of tb_estrut is

  -- declaracao dos componentes por testar
  component mux2 is
    port(A,B : in  bit; S : in  bit; Z : out bit);
  end component mux2;

  component mux4 is
    port(A,B,C,D : in  bit; S0,S1 : in bit; Z : out bit);
  end component mux4;

  component mux8 is
    port(A,B,C,D,E,F,G,H : in  bit; S0,S1,S2 : in bit; Z : out bit);
  end component mux8;

  component mux8vet is
    port(entr : in  bit_vector; sel: in bit_vector; Z : out bit);
  end component mux8vet;

  
  component demux2 is
    port(A : in  bit; S : in  bit; Z,W : out bit);
  end component demux2;

  component demux4 is
    port(A : in bit; S0,S1 : in bit; X,Y,Z,W : out bit);
  end component demux4;

  component demux8 is
    port(A : in  bit; S0,S1,S2 : in bit; P,Q,R,S,T,U,V,W : out bit);
  end component demux8;

  
  component sel2 is
    port(S : in  bit; Z,W : out bit);
  end component sel2;

  component sel4 is
    port(S0,S1 : in bit; X,Y,Z,W : out bit);
  end component sel4;

  component sel8 is
    port(S0,S1,S2 : in bit; P,Q,R,S,T,U,V,W : out bit);
  end component sel8;

  -- definicao do vetor de testes
  type test_record is record
    k  : bit;       -- entrada de bit
    a  : reg8;      -- entrada
    s  : reg3;      -- selecao
    mx : bit;       -- saida esperada do MUX
    dm : reg8;      -- saida esperada do DEMUX
    sl : reg8;      -- saida esperada do SEL
  end record;
  type test_array is array(positive range <>) of test_record;

  -- vetor de testes
  constant test_vectors : test_array := (
    --k,   a,          s,   mx,   dm,         sl 
    ('0',b"00000011",b"000",'1',b"00010000",b"00000000"),
    ('0',b"00000011",b"001",'1',b"00010000",b"00000000"),
    ('0',b"00000011",b"000",'1',b"00010000",b"00000000"),
    ('0',b"00000011",b"001",'1',b"00000000",b"00000000"),
    ('0',b"00000011",b"000",'1',b"00010000",b"00000000"),
    ('0',b"00000011",b"001",'1',b"00000000",b"00000000"),
    ('0',b"00000011",b"000",'1',b"00000000",b"00000000"),
    ('0',b"10000011",b"001",'1',b"00000000",b"00000010"),
    -- adicionar vetores de teste aqui
    --
    --
    -- nao alterar estes tres ultimos --
    ('0',b"00000000",b"000",'0',b"00000000",b"00000000"),
    ('0',b"00000000",b"000",'0',b"00000000",b"00000000"),
    ('0',b"00000000",b"000",'0',b"00000000",b"00000000")
    );

  signal inp,s0,s1,s2 : bit;
  signal s : reg3;
  signal entr : reg8;
  
  signal saidaMUX2, saidaMUX4, saidaMUX8, saidaMUX8vet, esperadaMUX : bit;
  signal sDEMUX2, sSEL2 : reg2;
  signal sDEMUX4, sSEL4 : reg4;
  signal sSEL8, sDEMUX8, esperadaDEMUX, esperadaSEL : reg8;

begin

  -- instanciacao dos componentes por testar
  U_mux2:  mux2  port map (entr(0), entr(1), s0, saidaMUX2);

  U_mux4:  mux4 port map (entr(0),entr(1),entr(2),entr(3),
                          s0,s1, saidaMUX4);

  U_mux8:  mux8 port map (entr(0),entr(1),entr(2),entr(3),
                          entr(4),entr(5),entr(6),entr(7),
                          s0,s1,s2, saidaMUX8);
  
  U_mux8vet:  mux8vet port map (entr, s, saidaMUX8vet);
  

  U_demux2: demux2 port map (inp, s0, sDEMUX2(0),sDEMUX2(1));

  U_demux4: demux4 port map (inp, s0,s1,
                             sDEMUX4(0),sDEMUX4(1),sDEMUX4(2),sDEMUX4(3));

  U_demux8: demux8 port map (inp, s0,s1,s2,
                             sDEMUX8(0),sDEMUX8(1),sDEMUX8(2),sDEMUX8(3),
                             sDEMUX8(4),sDEMUX8(5),sDEMUX8(6),sDEMUX8(7));


  U_sel2: sel2 port map (s0, sSEL2(0),sSEL2(1));

  U_sel4: sel4 port map (s0,s1, sSEL4(0),sSEL4(1),sSEL4(2),sSEL4(3));

  U_sel8: sel8 port map (s0,s1,s2, sSEL8(0),sSEL8(1),sSEL8(2),sSEL8(3),
                         sSEL8(4),sSEL8(5),sSEL8(6),sSEL8(7));

  
  -- este processo efetua os testes, executa em paralelo com seus modelos
  U_testValues: process
    variable v : test_record;
  begin

    for i in test_vectors'range loop
      v := test_vectors(i);             -- atribui valores de teste
      s     <= v.s;
      s0    <= v.s(0);                  -- usado no mux2,4,8 (sel,demux)
      s1    <= v.s(1);                  -- usado no mux4,8 (sel,demux)
      s2    <= v.s(2);                  -- usado no mux8 (sel,demux)
      inp   <= v.k;
      entr  <= v.a;
      esperadaMUX   <= v.mx;
      esperadaDEMUX <= v.dm;
      esperadaSEL   <= v.sl;

      wait for 500 ps;                  -- espera propagacao dos sinais

      assert saidaMUX2 = esperadaMUX
        report "mux2: saida errada sel="& B2STR(s(0)) &
        " saiu=" & B2STR(saidaMUX2) & " esperada=" & B2STR(esperadaMUX)
        severity error;

      assert saidaMUX4 = esperadaMUX
        report "mux4: saida errada sel="& BV2STR(s(1 downto 0)) &
        " saiu=" & B2STR(saidaMUX4) & " esperada=" & B2STR(esperadaMUX)
        severity error;

      assert saidaMUX8 = esperadaMUX
        report "mux8: saida errada sel="& BV2STR(s) &
        " saiu=" & B2STR(saidaMUX8) & " esperada=" & B2STR(esperadaMUX)
        severity error;

      assert saidaMUX8vet = esperadaMUX
        report "mux8vet: saida errada sel="& BV2STR(s) &
        " saiu=" & B2STR(saidaMUX8vet) & " esperada=" & B2STR(esperadaMUX)
        severity error;


      -- descomente estes para testar os demultiplexadores ---------
      --------------------------------------------------------------
--      assert sDEMUX2(1 downto 0) = esperadaDEMUX(1 downto 0)
--        report "demux2: saida errada sel="& B2STR(s(0)) &
--        " entr="& B2STR(inp) &
--        " saiu=" & BV2STR(sDEMUX2(1 downto 0)) &
--        " esperada=" & BV2STR(esperadaDEMUX(1 downto 0))
--        severity error;

--      assert sDEMUX4(3 downto 0) = esperadaDEMUX(3 downto 0)
--        report "demux4: saida errada sel="& BV2STR(s(1 downto 0)) &
--        " entr="& B2STR(inp) &
--        " saiu=" & BV2STR(sDEMUX4(3 downto 0)) &
--        " esperada=" & BV2STR(esperadaDEMUX(3 downto 0))
--        severity error;

--      assert sDEMUX8 = esperadaDEMUX
--        report "demux8: saida errada sel=" & BV2STR(s) &
--        " entr="& B2STR(inp) &
--        " saiu=" & BV2STR(sDEMUX8) & " esperada=" & BV2STR(esperadaDEMUX)
--        severity error;


      -- descomente estes para testar os demultiplexadores --------
      -------------------------------------------------------------
--      assert sSEL2(1 downto 0) = esperadaSEL(1 downto 0)
--        report "sel2: saida errada sel="& B2STR(s(0)) &
--        " saiu=" & BV2STR(sSEL2(1 downto 0)) &
--        " esperada=" & BV2STR(esperadaSEL(1 downto 0))
--        severity error;

--      assert sSEL4(3 downto 0) = esperadaSEL(3 downto 0)
--        report "sel4: saida errada sel="& BV2STR(s(1 downto 0)) &
--        " saiu=" & BV2STR(sSEL4(3 downto 0)) &
--        " esperada=" & BV2STR(esperadaSEL(3 downto 0))
--        severity error;

--      assert sSEL8 = esperadaSEL
--        report "sel8: saida errada sel=" & BV2STR(s) &
--        " saiu=" & BV2STR(sSEL8) & " esperada=" & BV2STR(esperadaSEL)
--        severity error;
          
    end loop;

    assert FALSE
      report " --###--fim da simulacao--###-- "
      severity failure;
    
    end process U_testValues;

end architecture TB;
-- --------------------------------------------------------------

-- --------------------------------------------------------------
configuration CFG_TB of TB_ESTRUT is
        for TB
        end for;
end CFG_TB;
-- --------------------------------------------------------------
