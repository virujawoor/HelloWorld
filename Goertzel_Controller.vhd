----------------------------------------------------------------------------------
-- Company:     CEM SOLUTIONS
-- Engineer:     Viru Jawoor
-- 
-- Create Date:    14:40:44 05/27/2015 
-- Design Name: 
-- Module Name:    Goertzel_Controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Goertzel_Controller is
    Port ( clk 					: in  STD_LOGIC;
           Fsync 				: in  STD_LOGIC;
           wb_rst 				: in  STD_LOGIC;
           q_rst 				: out STD_LOGIC;
           o_en 				: out STD_LOGIC;
           midmul_en 			: out STD_LOGIC;
           postmul_en 			: out STD_LOGIC;
           decode_en 			: out STD_LOGIC);
end Goertzel_Controller;

architecture Behavioral of Goertzel_Controller is
component Goertzel_timing
    Port ( clk 		: in  STD_LOGIC;
           wb_rst 	: in  STD_LOGIC;
           q_rst 	: out STD_LOGIC;
           o_en 	: out STD_LOGIC);
end component;
component wb_sync 
    Port ( wb_clk : in  STD_LOGIC;
           wb_rst : in  STD_LOGIC;
           asyncI : in  STD_LOGIC;
           syncO : out  STD_LOGIC);
end component;

signal q_rst1 : std_logic;
signal wb_Fsync : std_logic;
signal wb_Fsync1 : std_logic_vector(4 downto 0);
begin

TIMING:Goertzel_timing
    Port Map ( 
		clk 	=> Fsync,
        wb_rst 	=> wb_rst,
        q_rst 	=> q_rst1,  -- Every Cycle resets Q1 and Q2 value to Zero 
        o_en 	=> o_en);  -- Goertzel output valid enable 		
q_rst<=q_rst1;
		
SYNC : wb_sync 
    Port Map( 
		wb_clk => clk,
        wb_rst => wb_rst,
        asyncI => Fsync,
        syncO  => wb_Fsync);
		
--2 cly dly  		
process(clk,wb_rst)
begin
    if wb_rst = '1' then
		wb_Fsync1 <= (others=>'0');
	elsif clk'event and clk = '1' then	
		wb_Fsync1 <= wb_Fsync1(3 downto 0)&wb_Fsync;
	end if;
end process;		
midmul_en<=wb_Fsync1(0);		
postmul_en<=wb_Fsync1(2);		
decode_en<=wb_Fsync1(4) and q_rst1;		

end Behavioral;

