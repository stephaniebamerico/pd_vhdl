-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, BCC, ci210                       autor: Roberto Hexsel, 27out2015
--                                               rev 12set2016
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- esqueleto do testbench para ME que detecta ...01111110...
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity tb_ME is
end tb_ME;


architecture TB of tb_ME is


  type test_record is record
                        e : bit;        -- entrada
                        s : bit;        -- saida esperada
  end record;
  type test_array is array(positive range <>) of test_record;
    
  constant test_vectors : test_array := (
    -- entr, saida
    ('0', '0'), --A > B
    ('1', '0'), --B > C
    ('1', '0'), --C > D
    ('1', '0'), --D > E
    ('1', '0'), --E > F
    ('1', '0'), --F > G
    ('1', '0'), --G > H
    ('0', '0'), --H > I
    ('0', '1'), --I > B 
    ('1', '0'), --B > C
    ('1', '0'), --C > D
    ('0', '0'), --D > B
    ('1', '0'), --B > C
    ('1', '0'), --C > D
    ('1', '0'), --D > E
    ('1', '0'), --E > F
    ('1', '0'), --F > G
    ('1', '0'), --G > H
    ('0', '0'), --H > I
    ('1', '1'), --I > A
    ('0', '0'), --A > B
    ('0', '0'), --B > B
    ('0', '0'), --B > B
    ('1', '0'), --B > C
    ('1', '0'), --C > D
    ('0', '0'), --D > B
    ('1', '0'), --B > C
    ('1', '0'), --C > D
    ('1', '0'), --D > E
    ('1', '0'), --E > F
    ('1', '0'), --F > G
    ('1', '0'), --G > H
    ('0', '0'), --H > I
    ('1', '1'), --I > A
    ('1', '0'), --A > A
    ('1', '0')  --A > A
    );


  -- tipo enumerado: A=0, B=1, C=2, ...
  type states is (A, B, C, D, E, F, G, H, I);

  signal curr_st, next_st : states;

  signal clk, reset, entr, found, esperada : bit;

  signal dbg_st : integer;
  
begin  -- TB

  dbg_st <= integer(states'pos(curr_st));  -- debugging only

  U_state_reg: process(reset, clk)
  begin
    if reset = '0' then
      curr_st <= A;
    elsif rising_edge(clk) then
      curr_st <= next_st;
    end if;
  end process U_state_reg;

  U_st_transitions: process(curr_st, entr)
  begin                  -- Máquina de Moore
    case curr_st is
      when A =>
        if entr = '0' then next_st <= B; 
        else next_st <= A;       end if;
        found <= '0';
      when B =>
        if entr = '1' then next_st <= C;
        else next_st <= B;       end if;
        found <= '0';
      when C =>
        if entr = '1' then next_st <= D;
        else next_st <= B;       end if;
        found <= '0';
      when D =>
        if entr = '1' then next_st <= E;
        else next_st <= B;       end if;
        found <= '0';
      when E =>
        if entr = '1' then next_st <= F;
        else next_st <= B;       end if;
        found <= '0';
      when F =>
        if entr = '1' then next_st <= G;
        else next_st <= B;       end if;
        found <= '0';
      when G =>
        if entr = '1' then next_st <= H;
        else next_st <= B;       end if;
        found <= '0';
      when H =>
        if entr = '1' then next_st <= A;
        else next_st <= I;       end if;
        found <= '0';
      when I =>
        if entr = '1' then next_st <= A;
        else next_st <= B;       end if;
        found <= '1';
    -- ...
    end case;
  end process U_st_transitions;
  -- ----------------------------------------------------------------
  

  -- ----------------------------------------------------------------
  U_testValues: process -- test the circuit
    variable v : test_record;
  begin

    esperada <= '0';
    entr     <= '0';
    
    for i in test_vectors'range loop

      wait until rising_edge(clk);

      v := test_vectors(i);
      entr     <= v.e;
      esperada <= v.s;

      assert FALSE
        report "entr="& B2STR(entr) & " esp=" & B2STR(esperada) &
               " found=" & B2STR(found)
        severity note;
      
    end loop;

    wait; -- -------------- end the simulation ------------------------
    
  end process;

  
  U_clock: process      -- concurrent process for clock, clock runs free
  begin
    clk <= '0';
    wait for t_clock_period / 2;
    clk <= '1';
    wait for t_clock_period / 2;
  end process;

  U_reset: process      -- reset initializes all
  begin
    reset <= '0';
    wait for t_reset;
    reset <= '1';	-- end of reset pulse
    wait;               -- this process stops here
  end process;
  
end TB;

----------------------------------------------------------------
configuration CFG_TB of TB_ME is
	for TB
        end for;
end CFG_TB;
----------------------------------------------------------------
