-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UFPR, BCC, ci210                        autor: Roberto Hexsel, 10set2014
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- contador assincrono de 4 bits
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity contAssincrono4 is
  port(rel, rst : in bit;
       Q : out bit_vector(3 downto 0));
end contAssincrono4;

architecture estrutural of contAssincrono4 is
  component FFT
    generic (prop : time);
    port(rel, rst, set : in bit;
        D : in  bit;
        Q,Qn : out bit);
  end component FFT;

  signal val : bit_vector(3 downto 0);

begin
  
  U0: FFT generic map (t_FFT) port map (rel,    rst,'1','1', val(0),open);
  U1: FFT generic map (t_FFT) port map (val(0), rst,'1','1', val(1),open);
  U2: FFT generic map (t_FFT) port map (val(1), rst,'1','1', val(2),open);
  U3: FFT generic map (t_FFT) port map (val(2), rst,'1','1', val(3),open);
 
  Q <= val;

end estrutural;
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- contador sincrono de 4 bits
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity contSincrono4 is
  port(rel, rst : in bit;
       Q : out bit_vector(3 downto 0));
end contSincrono4;

architecture estrutural of contSincrono4 is
  component FFT
    generic (prop : time);
    port(rel, rst, set : in bit;
        D : in  bit;
        Q,Qn : out bit);
  end component FFT;

  component and2
    generic (prop : time);
    port (a, b : in  bit;
          s    : out bit);
  end component and2;

  signal val : bit_vector(3 downto 0);
  signal a1,a2 : bit;

begin

  U0: FFT generic map (t_FFT)   port map (rel, rst, '1', '1'   , val(0),open);

  U1: FFT generic map (t_FFT)   port map (rel, rst, '1', val(0), val(1),open);

  G1: and2 generic map (t_and2) port map (val(0),val(1),a1);
  U2: FFT  generic map (t_FFT)  port map (rel, rst, '1',     a1, val(2),open);

  G2: and2 generic map (t_and2) port map (a1,val(2),a2 );
  U3: FFT  generic map (t_FFT)  port map (rel, rst, '1',     a2, val(3),open);
 
  Q <= val;

end estrutural;
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- contador sincrono em anel de 4 bits
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity contAnel4 is
  port(rel, rst : in bit;
       Q : out bit_vector(3 downto 0));
end contAnel4;

architecture estrutural of contAnel4 is
  component FFD
    generic (prop : time);
    port(rel, rst, set : in bit;
        D : in  bit;
        Q : out bit);
  end component FFD;

  signal val : bit_vector(3 downto 0) := "0000";

begin

  -- projeto incompleto; acrescente o que for necessario
  U0: FFD generic map (t_FFD) port map (rel, '1', rst, val(3), val(0));
  U1: FFD generic map (t_FFD) port map (rel, rst, '1', val(0), val(1));
  U2: FFD generic map (t_FFD) port map (rel, rst, '1', val(1), val(2));
  U3: FFD generic map (t_FFD) port map (rel, rst, '1', val(2), val(3));

  Q <= val;

end estrutural;
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- registrador de deslocamento de 4 bits com carga paralela sincrona
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use work.p_wires.all;

entity regDesloc4 is
  port(rel, rst, car : in bit;
        D : in  bit_vector(3 downto 0);
        Q : out bit_vector(3 downto 0));
end regDesloc4;

architecture estrutural of regDesloc4 is
  component FFD
    generic (prop : time);
    port(rel, rst, set : in bit;
        D : in  bit;
        Q : out bit);
  end component FFD;

  component mux2
    port (a, b, s : in  bit;    -- sel=0: z <= a
          z       : out bit);
  end component mux2;

  signal est, inp : bit_vector(3 downto 0) := "0000";

begin

  -- sinal carga ativo em '1'

  M0: mux2 port map ( D(3), D(3), car, inp(3));
  U0: FFD generic map (t_FFD) port map (rel, rst, '1', inp(3), est(3));

  M1: mux2 port map ( est(3), D(2), car, inp(2));
  U1: FFD generic map (t_FFD) port map (rel, rst, '1', inp(2), est(2));

  M2: mux2 port map ( est(2), D(1), car, inp(1));
  U2: FFD generic map (t_FFD) port map (rel, rst, '1', inp(1), est(1));

  M3: mux2 port map ( est(1), D(0), car, inp(0));
  U3: FFD generic map (t_FFD) port map (rel, rst, '1', inp(0), est(0));
    
  Q <= est;

end estrutural;
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
