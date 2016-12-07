library ieee;
--library ieee_proposed;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee_proposed.math_utility_pkg.all;
--use ieee_proposed.fixed_pkg.all;

entity top is
 port( clk           : in std_logic;
       clk_enable    : in std_logic;
       reset         : in std_logic;
      -- filter_in     : in sfixed(1 downto -14);
       filter_out     : out std_logic_vector(7 downto 0);
       filter_out_770     : out std_logic_vector(15 downto 0);
       filter_out_941     : out std_logic_vector(15 downto 0);
       filter_out_852     : out std_logic_vector(15 downto 0);
       filter_out_1209     : out std_logic_vector(15 downto 0);
       filter_out_1633     : out std_logic_vector(15 downto 0);
       filter_out_1477     : out std_logic_vector(15 downto 0);
       filter_out_1336     : out std_logic_vector(15 downto 0);
        test1         : out std_logic_vector(31 downto 0);
        test_delay1   : out std_logic_vector(15 downto 0);
        test_f        : out std_logic_vector(16 downto 0); 
       -- test_f2       : out std_logic_vector(15 downto 0)
        test_rem      : out std_logic_vector(8 downto 0) 
     );
end top;

architecture top_a of top is 

component filter
   port( clk_gate              : in std_logic;
        clk_enable    : in std_logic;
        reset         : in std_logic;
        filter_in        : in std_logic_vector(15 downto 0);
        filter_out    : out std_logic_vector(15 downto 0);
        test1         : out std_logic_vector(31 downto 0);
        test_delay1   : out std_logic_vector(15 downto 0);
        test_f        : out std_logic_vector(16 downto 0) 
       -- test_f2       : out std_logic_vector(15 downto 0) 
       );
end component;



component filter_770
   port( clk_gate              : in std_logic;
        clk_enable    : in std_logic;
        reset         : in std_logic;
        filter_in        : in std_logic_vector(15 downto 0);
        filter_out    : out std_logic_vector(15 downto 0);
        test1         : out std_logic_vector(31 downto 0);
        test_delay1   : out std_logic_vector(15 downto 0);
        test_f        : out std_logic_vector(16 downto 0) 
       -- test_f2       : out std_logic_vector(15 downto 0) 
       );
end component;

component filter_941
   port( clk_gate              : in std_logic;
        clk_enable    : in std_logic;
        reset         : in std_logic;
        filter_in        : in std_logic_vector(15 downto 0);
        filter_out    : out std_logic_vector(15 downto 0);
        test1         : out std_logic_vector(31 downto 0);
        test_delay1   : out std_logic_vector(15 downto 0);
        test_f        : out std_logic_vector(16 downto 0) 
       -- test_f2       : out std_logic_vector(15 downto 0) 
       );
end component;

component filter_852
   port( clk_gate              : in std_logic;
        clk_enable    : in std_logic;
        reset         : in std_logic;
        filter_in        : in std_logic_vector(15 downto 0);
        filter_out    : out std_logic_vector(15 downto 0);
        test1         : out std_logic_vector(31 downto 0);
        test_delay1   : out std_logic_vector(15 downto 0);
        test_f        : out std_logic_vector(16 downto 0) 
       -- test_f2       : out std_logic_vector(15 downto 0) 
       );
end component;

component filter_1209
   port( clk_gate              : in std_logic;
        clk_enable    : in std_logic;
        reset         : in std_logic;
        filter_in        : in std_logic_vector(15 downto 0);
        filter_out    : out std_logic_vector(15 downto 0);
        test1         : out std_logic_vector(31 downto 0);
        test_delay1   : out std_logic_vector(15 downto 0);
        test_f        : out std_logic_vector(16 downto 0) 
       -- test_f2       : out std_logic_vector(15 downto 0) 
       );
end component;

component filter_1633
   port( clk_gate              : in std_logic;
        clk_enable    : in std_logic;
        reset         : in std_logic;
        filter_in        : in std_logic_vector(15 downto 0);
        filter_out    : out std_logic_vector(15 downto 0);
        test1         : out std_logic_vector(31 downto 0);
        test_delay1   : out std_logic_vector(15 downto 0);
        test_f        : out std_logic_vector(16 downto 0) 
       -- test_f2       : out std_logic_vector(15 downto 0) 
       );
end component;

component filter_1477
   port( clk_gate              : in std_logic;
        clk_enable    : in std_logic;
        reset         : in std_logic;
        filter_in        : in std_logic_vector(15 downto 0);
        filter_out    : out std_logic_vector(15 downto 0);
        test1         : out std_logic_vector(31 downto 0);
        test_delay1   : out std_logic_vector(15 downto 0);
        test_f        : out std_logic_vector(16 downto 0) 
       -- test_f2       : out std_logic_vector(15 downto 0) 
       );
end component;

component filter_1336
   port( clk_gate              : in std_logic;
        clk_enable    : in std_logic;
        reset         : in std_logic;
        filter_in        : in std_logic_vector(15 downto 0);
        filter_out    : out std_logic_vector(15 downto 0);
        test1         : out std_logic_vector(31 downto 0);
        test_delay1   : out std_logic_vector(15 downto 0);
        test_f        : out std_logic_vector(16 downto 0) 
       -- test_f2       : out std_logic_vector(15 downto 0) 
       );
end component;

component Addr
   port(clk_in: in  STD_LOGIC;
	    rst_in: in  STD_LOGIC;           
             --Addr  : out  STD_LOGIC_VECTOR(7 downto 0);
			  --  addr_umf  : out  STD_LOGIC_VECTOR(8 downto 0);
			 --   en:out  STD_LOGIC);
		tone_out : out std_logic_vector(15 downto 0));
end component;

component sqrtnew
  PORT
	(
		radical		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		remainder		: OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
	);
end component;	
		
--component ncor
--   port(
--		phi_inc_i	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
--		clk	: IN STD_LOGIC;
--		reset_n	: IN STD_LOGIC;
--		clken	: IN STD_LOGIC;
--		fsin_o	: OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
--		fcos_o	: OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
--		out_valid	: OUT STD_LOGIC
--	   );  
--end component;

signal fsin,fcos : std_logic_vector(17 downto 0):= "000000000000000000";
signal outv : std_logic;	
signal tone_sig : std_logic_vector(15 downto 0):= "0000000000000000";
signal filter_out_sig : std_logic_vector(15 downto 0):= "0000000000000000";
--signal filter_out_sig1 : std_logic_vector(15 downto 0):= "0000000000000000";
--signal filter_out_sig2 : std_logic_vector(15 downto 0):= "0000000000000000";
--signal filter_out_sig3 : std_logic_vector(15 downto 0):= "0000000000000000";
--signal tone_sf : sfixed(1 downto -14) := "0000000000000000";
begin
 -- tone_sf <= to_sfixed(tone_sig,tone_sf);
  u1: filter port map(clk_gate => clk, clk_enable => clk_enable, reset => reset, filter_in => tone_sig , filter_out => filter_out_sig , test1 => test1, test_delay1 => test_delay1, test_f => test_f); --, test_delay2 => test_delay2);
  u3: sqrtnew port map(radical => filter_out_sig, q => filter_out, remainder => test_rem);   
  u4: filter_770 port map(clk_gate => clk, clk_enable => clk_enable, reset => reset, filter_in => tone_sig , filter_out => filter_out_770 ); --, test1 => test1, test_delay1 => test_delay1, test_f => test_f); --, test_delay2 => test_delay2);
  u5: filter_941 port map(clk_gate => clk, clk_enable => clk_enable, reset => reset, filter_in => tone_sig , filter_out => filter_out_941); -- , test1 => test1, test_delay1 => test_delay1, test_f => test_f); --, test_delay2 => test_delay2); 
  u6: filter_852 port map(clk_gate => clk, clk_enable => clk_enable, reset => reset, filter_in => tone_sig , filter_out => filter_out_852); -- , test1 => test1, test_delay1 => test_delay1, test_f => test_f); --, test_delay2 => test_delay2); 
  u7: filter_1209 port map(clk_gate => clk, clk_enable => clk_enable, reset => reset, filter_in => tone_sig , filter_out => filter_out_1209);
  u8: filter_1633 port map(clk_gate => clk, clk_enable => clk_enable, reset => reset, filter_in => tone_sig , filter_out => filter_out_1633);
  u9: filter_1477 port map(clk_gate => clk, clk_enable => clk_enable, reset => reset, filter_in => tone_sig , filter_out => filter_out_1477);
  u10: filter_1336 port map(clk_gate => clk, clk_enable => clk_enable, reset => reset, filter_in => tone_sig , filter_out => filter_out_1336);
    
--  u2: ncor port map(phi_inc_i => "00000000001011011010110110111000", clk => clk, reset_n => reset,clken => clk_enable, fsin_o => fsin, fcos_o => fcos, out_valid => outv);
  u2: Addr port map(clk_in => clk, rst_in => reset, tone_out => tone_sig);
end top_a;  