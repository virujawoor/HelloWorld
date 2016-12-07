----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:45:10 12/27/2011 
-- Design Name: 
-- Module Name:    wb_sync - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity wb_sync is
    Port ( wb_clk : in  STD_LOGIC;
           wb_rst : in  STD_LOGIC;
           asyncI : in  STD_LOGIC;
           syncO : out  STD_LOGIC);
end wb_sync;

architecture Behavioral of wb_sync is
signal Q1: std_logic:='0';
signal Q2: std_logic:='1';
begin

P1:process (asyncI,wb_clk,wb_rst)
begin
	  if ( wb_rst = '1') then
	      Q1 <= '1'; 
	  elsif wb_clk'event and wb_clk = '1' then
	   		 Q1 <=  asyncI;
	  end if;
end process P1;
	  
P2:Process (Q1,wb_clk,wb_rst)
	begin
	    if ( wb_rst = '1') then
				Q2 <='0';
	   ELSIF wb_clk'event and wb_clk ='1' then		
				Q2 <= not Q1;
	 end if;
end process P2;

syncO<=Q1 and Q2;
end Behavioral;

