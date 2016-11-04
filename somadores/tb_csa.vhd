-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, BCC, ci210                        autor: Roberto Hexsel, 31ago2016
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para somador com seleção de vai-um (carry select adder)
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE;
use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity tb_CSA is
end tb_CSA;

architecture TB of tb_CSA is

  component adderCSA32 is port(inpA, inpB : in bit_vector;
                          outC : out bit_vector;
                          vai  : out bit);
  end component adderCSA32;

  signal inpA,inpB : reg32;             -- entradas de teste
  signal resCSA    : reg32;             -- resultados
  signal vaiCSA    : bit;
  signal esp_res   : reg32;             -- valores esperados
  signal esp_vai   : bit;
  
  type test_record is record
    a : reg32;      -- entrada
    b : reg32;      -- entrada
    c : reg32;      -- saida
    v : bit;        -- vai-um
  end record;
  type test_array is array(positive range <>) of test_record;
    
  constant test_vectors : test_array := (
    -- a,        b,           c,         vai-um
    -- testes para soma
    (x"00000000",x"00000000",x"00000000",'0'),
    -- acrescente novos valores aqui
    (x"00000001",x"00000001",x"00000002",'0'),  -- corrija valores de c e v
    (x"00000fff",x"00000001",x"00001000",'0'),  
    (x"00000000",x"00000000",x"00000000",'0'),
    (x"00000000",x"00000000",x"00000000",'1'),
    (x"00000000",x"00000000",x"00000000",'1'),
    -- nao alterar estes dois ultimos --
    (x"00000000",x"00000000",x"00000000",'0'),
    (x"00000000",x"00000000",x"00000000",'0')
    );

begin  -- TB

  U_CSA: adderCSA32   port map(inpA, inpB, resCSA, vaiCSA);

  U_testValues: process                -- test the circuit
    variable v : test_record;
  begin

    for i in test_vectors'range loop
      v := test_vectors(i);
      inpA <= v.a;
      inpB <= v.b;
      esp_res <= v.c;
      esp_vai <= v.v;

      assert resCSA = esp_res
        report LF & "addCSA:  saida errada " &
        LF & "    A="& BV2STR(inpA) &
        LF & "    B="& BV2STR(inpB) &
        LF & " soma="& BV2STR(resCSA) &
        LF & "  esp="& BV2STR(esp_res)
        severity error;

      wait for 4 ns;                  -- if needed, increease waiting time

    end loop;

    assert FALSE
      report " --###--fim da simulacao--###-- "
      severity failure;

    end process;
   
end TB;

----------------------------------------------------------------
configuration CFG_TB of TB_CSA is
	for TB
        end for;
end CFG_TB;
----------------------------------------------------------------
