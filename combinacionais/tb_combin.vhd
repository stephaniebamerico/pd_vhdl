-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, BCC, ci210 2013-2 autor: Roberto Hexsel, 26ago2016
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para circuitos combinacionais
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity tb_combin is
end tb_combin;

architecture TB of tb_combin is

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

  
  component decod2 is
    port(S : in  bit; Z,W : out bit);
  end component decod2;

  component decod4 is
    port(S0,S1 : in bit; X,Y,Z,W : out bit);
  end component decod4;

  component decod8 is
    port(S0,S1,S2 : in bit; P,Q,R,S,T,U,V,W : out bit);
  end component decod8;

  -- definicao do vetor de testes
  type test_record is record
    k  : bit;       -- entrada de bit para demultiplexadores
    a  : reg8;      -- entrada para multiplexadores
    s  : reg3;      -- entrada de selecao (para todos circuitos)
    mx : bit;       -- saida esperada do MUX
    dm : reg8;      -- saida esperada do DEMUX
    dc : reg8;      -- saida esperada do DECOD
  end record;
  type test_array is array(positive range <>) of test_record;

  -- vetor de testes
  constant test_vectors : test_array := (
    --k,   a,          s,   mx,   dm,         dc
    ('0',b"00000011",b"001",'1',b"00010000",b"00000000"),
    ('1',b"00000011",b"101",'1',b"00010000",b"00000000"),
    ('0',b"00000000",b"100",'0',b"00010000",b"00000000"),
    ('1',b"00000011",b"001",'1',b"00000000",b"00000000"),
    ('1',b"00000011",b"010",'1',b"00010000",b"00000000"),
    ('0',b"00000011",b"111",'1',b"00000000",b"00000000"),
    ('0',b"00000011",b"010",'1',b"00000000",b"00000000"),
    ('1',b"10000011",b"111",'1',b"00000000",b"00000010"),
    -- adicionar vetores de teste aqui
    --
    --
    -- nao alterare estes tres ultimos --
    ('0',b"00000000",b"000",'0',b"00000000",b"00000001"),
    ('0',b"00000000",b"000",'0',b"00000000",b"00000001"),
    ('0',b"00000000",b"000",'0',b"00000000",b"00000001")
    );

  signal inp, s0,s1,s2 : bit := '0';
  signal s : reg3 := "000";
  signal entr : reg8 := "00000000";
  
  signal saidaMUX2, saidaMUX4, saidaMUX8, saidaMUX8vet, esperadaMUX : bit;
  signal sDEMUX2, sDECOD2 : reg2;
  signal sDEMUX4, sDECOD4 : reg4;
  signal sDECOD8, sDEMUX8, esperadaDEMUX, esperadaDECOD : reg8;

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


  U_decod2: decod2 port map (s0, sDECOD2(0),sDECOD2(1));

  U_decod4: decod4 port map (s0,s1,
                             sDECOD4(0),sDECOD4(1),sDECOD4(2),sDECOD4(3));

  U_decod8: decod8 port map (s0,s1,s2,
                             sDECOD8(0),sDECOD8(1),sDECOD8(2),sDECOD8(3),
                             sDECOD8(4),sDECOD8(5),sDECOD8(6),sDECOD8(7));

  
  -- este processo efetua os testes, executa em paralelo com seus modelos
  U_testValues: process
    variable v : test_record;
  begin

    for i in test_vectors'range loop
      v := test_vectors(i);             -- atribui valores de teste
      s     <= v.s;
      s0    <= v.s(0);                  -- usado no mux2,4,8 (decod,demux)
      s1    <= v.s(1);                  -- usado no mux4,8 (decod,demux)
      s2    <= v.s(2);                  -- usado no mux8 (decod,demux)
      inp   <= v.k;
      entr  <= v.a;
      esperadaMUX   <= v.mx;
      esperadaDEMUX <= v.dm;
      esperadaDECOD <= v.dc;

      wait for 1 ns;                  -- espera propagacao dos sinais


      --------------------------------------------------------------
      -- comente estes APOS testar os multiplexadores --------------
      --------------------------------------------------------------
    
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


      --------------------------------------------------------------
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

      
      -------------------------------------------------------------
      -- descomente estes para testar os demultiplexadores --------
      -------------------------------------------------------------
      
--      assert sDECOD2(1 downto 0) = esperadaDECOD(1 downto 0)
--        report "decod2: saida errada sel="& B2STR(s(0)) &
--        " saiu=" & BV2STR(sDECOD2(1 downto 0)) &
--        " esperada=" & BV2STR(esperadaDECOD(1 downto 0))
--        severity error;

--      assert sDECOD4(3 downto 0) = esperadaDECOD(3 downto 0)
--        report "decod4: saida errada sel="& BV2STR(s(1 downto 0)) &
--        " saiu=" & BV2STR(sDECOD4(3 downto 0)) &
--        " esperada=" & BV2STR(esperadaDECOD(3 downto 0))
--        severity error;

--      assert sDECOD8 = esperadaDECOD
--        report "decod8: saida errada sel=" & BV2STR(s) &
--        " saiu=" & BV2STR(sDECOD8) & " esperada=" & BV2STR(esperadaDECOD)
--        severity error;
          
    end loop;

    assert FALSE
      report " --###--fim da simulacao--###-- "
      severity failure;
    
    end process U_testValues;

end architecture TB;
-- --------------------------------------------------------------

-- --------------------------------------------------------------
configuration CFG_TB of TB_COMBIN is
        for TB
        end for;
end CFG_TB;
-- --------------------------------------------------------------
