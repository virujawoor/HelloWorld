----------------------------------------------------------------------------------
-- Company:         CEM Solutions
-- Engineer:        viru jawoor
-- 
-- Create Date:    20:20:52 10/25/2008 
-- Design Name:    Tone Generation
-- Module Name:    samples - Behavioral 
-- Project Name:   nano_pbx
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

entity samples is
    Port (    clk_in	: in  STD_LOGIC;
	          rst_in	: in  STD_LOGIC;            
			  tone_out 	: out std_logic_vector(15 downto 0));
end samples;

architecture Behavioral of samples is 

signal addr_cnt :	std_logic_vector(7 downto 0):=(others=>'0');
signal umf_cnt 	:	std_logic_vector(8 downto 0):=(others=>'0');
signal Addr 	: 	std_logic_vector(7 downto 0):=(others=>'0');
signal en1 		: 	std_logic :='0'; 

component iram_LUT is
   port(clk_5mhz  	: in  std_logic;
        rst 		: in  std_logic;
        en 			: in  std_logic;
		addr 		: in  std_logic_vector(7 downto 0);
        ram_out   	: out std_logic_vector(15 downto 0));
end component;

begin
  
u1: iram_LUT 
	port map(	
		clk_5mhz 	=> clk_in, 
		rst 		=> rst_in, 
		en 			=> en1,--'1', 
		addr 		=> Addr, 
		ram_out 	=> tone_out); 
		
process(clk_in,rst_in)
begin		
	if(clk_in'event and clk_in = '1')  then
		if rst_in = '1' or addr_cnt="11001100" then 
			addr_cnt <=(others=>'0');
			en1<=not(en1);
		else
		  addr_cnt <=addr_cnt+1;
	    end if;
   end if;	
end process;
addr<=addr_cnt;


end Behavioral;
