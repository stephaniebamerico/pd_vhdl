-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, BCC, ci210                        autor: Roberto Hexsel, 31ago2016
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para multiplicador combinacional
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE; use IEEE.std_logic_1164.all;
use work.p_wires.all;

entity tb_multiplicador is
end tb_multiplicador;

architecture TB of tb_multiplicador is

  component mult16x16 is port(A, B : in bit_vector;
                              prod : out bit_vector);
  end component mult16x16;
  
  signal inpA,inpB : reg16;             -- entradas de teste
  signal produto : reg32;               -- resultado
  signal esp_res : reg32;               -- produto esperado
  
  type test_record is record
                        a : reg16;      -- entrada
                        b : reg16;      -- entrada
                        c : reg32;      -- saida esperada
                      end record;
  type test_array is array(positive range <>) of test_record;
    
  constant test_vectors : test_array := (
    -- a,      b,      c
    (x"0000",x"0000",x"00000000"),
    -- acrescente novos valores aqui
    (x"0001",x"0001",x"00000001"),
    (x"0002",x"0002",x"00000004"),
    (x"0002",x"0001",x"00000002"),
    (x"0002",x"0002",x"00000004"),
    (x"0010",x"0010",x"00000100"),
    (x"0100",x"0100",x"00010000"),
    (x"0010",x"0FFF",x"0000FFF0"),
    (x"0002",x"5555",x"0000aaaa"),
    (x"5555",x"0002",x"0000aaaa"),
    (x"aaaa",x"0002",x"00015554"),
    (x"aaaa",x"8000",x"55550000"),
    (x"0000",x"0000",x"00000000"),
    (x"aaa1",x"0000",x"00000000"),
    (x"ffff",x"ffff",x"fffe0001"),
    (x"1111",x"1111",x"01234321"),
    (x"aaaa",x"aaaa",x"71C638E4"),
    (x"0101",x"1010",x"00102010"),
    -- nao altere estes dois ultimos --
    (x"0000",x"0000",x"00000000"),
    (x"0000",x"0000",x"00000000")
    );

begin  -- TB

  U_mult: mult16x16 port map(inpA, inpB, produto);

  U_testValues: process                -- test the circuit
    variable v : test_record;
  begin
    
    for i in test_vectors'range loop
      v := test_vectors(i);
      inpA <= v.a;
      inpB <= v.b;
      esp_res <= v.c;

      assert produto = esp_res
        report LF & LF & "mult16x16: saida errada" &
        LF & "   A = x" & BV2HEX(inpA) &
        LF & "   B = x" & BV2HEX(inpB) &
        LF & "prod = x" & BV2HEX(produto) &
        LF & " esp = x" & BV2HEX(esp_res) & LF
        severity error;

      wait for 10 ns;           -- se necessario, aumente este valor
    end loop;

    wait;                               -- fim da simulacao

  end process;
    
end TB;

----------------------------------------------------------------
configuration CFG_TB of TB_MULTIPLICADOR is
	for TB
        end for;
end CFG_TB;
----------------------------------------------------------------
