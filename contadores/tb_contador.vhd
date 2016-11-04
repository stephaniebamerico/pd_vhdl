-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, BCC, ci210                       autor: Roberto Hexsel, 07nov2012
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- testbench para contadores
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity tb_contador is
end tb_contador;

architecture TB of tb_contador is

  component contAssincrono4 is
    port(rel, rst : in bit;
         Q : out bit_vector);
  end component contAssincrono4;

  component contSincrono4 is
    port(rel, rst : in bit;
         Q : out bit_vector);
  end component contSincrono4;

  component contAnel4 is
    port(rel, rst : in bit;
         Q : out bit_vector);
  end component contAnel4;

  component regDesloc4 is
    port(rel, rst, car : in bit;
         D : in  bit_vector;
         Q : out bit_vector);
  end component regDesloc4;

  type test_record is record
                        e : reg4;       -- entrada por carregar
                        s : reg4;       -- saida esperada
                        c : bit;        -- carrega registrador
  end record;
  type test_array is array(positive range <>) of test_record;
    
  constant test_vectors : test_array := (
    -- entr, saida, carga=0
   (b"1111",b"0000",'1'),
	(b"0000",b"1111",'0'),
	(b"0000",b"0111",'0'),
	(b"0000",b"0011",'0'),
	(b"0000",b"0001",'0'),
	(b"1110",b"0000",'1'),
 	(b"0000",b"1110",'0'),
 	(b"0000",b"0111",'1'),
 	(b"0000",b"0000",'1'),
 	(b"1111",b"0000",'1'),
	(b"0000",b"1111",'0'),
	(b"0000",b"0111",'0'),
	(b"0000",b"0011",'0'),
	(b"0000",b"0001",'0'),
	(b"0000",b"0000",'1'),
	(b"0100",b"0000",'1'),
	(b"0111",b"0100",'1'),
	(b"0000",b"0111",'1'),
	(b"1000",b"0000",'1'),
	(b"0011",b"1000",'1'),
	(b"0000",b"0011",'1'),
	(b"0000",b"0000",'1'));

  
  signal rAssi,rSinc,rAnel,rDesl : reg4;
  signal tb_rel,tb_rst : bit;
  signal tb_car : bit;
  signal tb_inp : reg4;
  signal esperada : reg4;

begin  -- TB

  U_assi: contAssincrono4 port map (tb_rel, tb_rst, rAssi);
  U_sinc: contSincrono4   port map (tb_rel, tb_rst, rSinc);
  U_anel: contAnel4       port map (tb_rel, tb_rst, rAnel);
  U_desl: regDesloc4      port map (tb_rel, tb_rst, tb_car, tb_inp, rDesl);
  
  U_testValues: process -- test the circuit
    variable v : test_record;
  begin

    esperada <= b"0000";
    tb_inp   <= b"0000";
    tb_car   <= '1';

    wait until tb_rst = '1';
    
    for i in test_vectors'range loop
      wait until rising_edge(tb_rel);
      v := test_vectors(i);
      tb_inp   <= v.e;
      esperada <= v.s;
      tb_car   <= v.c;

      -- descomente para testar o registrador de deslocamento
       assert rDesl = esperada
         report LF & LF & "regDesloc: saida errada" &
         LF & " saida = " & BV2STR(rDesl) & " esp = " & BV2STR(esperada) & LF
         severity error;

    end loop;

    wait;                               -- fim da simulacao
    
  end process;


  U_clock: process      -- concurrent process of clock, clock runs free
  begin
    tb_rel <= '0';
    wait for t_clock_period / 2;
    tb_rel <= '1';
    wait for t_clock_period / 2;
  end process;

  U_reset: process      -- inicializa contadores
  begin
    tb_rst <= '0';
    wait for t_reset;
    tb_rst <= '1';	-- end reset
    wait;
  end process;
  
end TB;

----------------------------------------------------------------
configuration CFG_TB of TB_CONTADOR is
	for TB
        end for;
end CFG_TB;
----------------------------------------------------------------
