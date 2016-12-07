----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:26:04 06/25/2009 
-- Design Name: 
-- Module Name:    post_processing - Behavioral 
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

entity post_processing is
    Port ( 
           wb_clk 		: in  STD_LOGIC;
           wb_rst 		: in  STD_LOGIC;
           clk_ce 		: in  STD_LOGIC;
		   stm2mult_en 	: in  STD_LOGIC;
		   Q1 			: in  STD_LOGIC_VECTOR (15 downto 0);
           Q2 			: in  STD_LOGIC_VECTOR (15 downto 0);
           mid 			: in  STD_LOGIC_VECTOR (15 downto 0);
           geortzel_out : out  STD_LOGIC_VECTOR (15 downto 0));
end post_processing;

architecture Behavioral of post_processing is
signal final_product : std_logic_vector(16 downto 0) := (others=>'0');
signal product1 	 : std_logic_vector(31 downto 0) := (others=>'0');
signal product2 	 : std_logic_vector(31 downto 0) := (others=>'0');
signal product4 	 : std_logic_vector(31 downto 0) := (others=>'0');
signal mult2sub_en   : std_logic;


-- component mult
	-- port (
	-- clk: IN std_logic;
	-- a: IN std_logic_VECTOR(15 downto 0);
	-- b: IN std_logic_VECTOR(15 downto 0);
	-- ce: IN std_logic;
	-- sclr: IN std_logic;
	-- p: OUT std_logic_VECTOR(31 downto 0));
-- end component;


begin

 process(wb_clk,wb_rst,clk_ce,stm2mult_en)
   begin
     if wb_rst = '1' then
       product1 <= (others=>'0');
       product2 <= (others=>'0');
       product4 <= (others=>'0');
     elsif wb_clk'event and wb_clk = '1' then
       if (clk_ce = '1' and stm2mult_en='1') then   	  
             product1 <= conv_std_logic_vector(signed(Q2) * signed(Q2),32);          
             product2 <= conv_std_logic_vector(signed(Q1) * signed(Q1),32);           
             product4 <= conv_std_logic_vector(signed( mid) * signed(Q2),32); 
       end if;
     end if;        
   end process;
	
--ins_mult1:	mult
--	port map (
--	clk=>wb_clk,
--	a	=>Q2,
--	b	=>Q2,
--	ce	=>stm2mult_en,
--	sclr=>wb_rst,
--	p	=>product1);
--	
--ins_mult2:	mult
--	port map (
--	clk=>wb_clk,
--	a	=>Q1,
--	b	=>Q1,
--	ce	=>stm2mult_en,
--	sclr=>wb_rst,
--	p	=>product2);
--
--ins_mult4:	mult
--	port map (
--	clk=>wb_clk,
--	a	=>mid,
--	b	=>Q2,
--	ce	=>stm2mult_en,
--	sclr=>wb_rst,
--	p	=>product4);	

process(product1,product2)
  begin
		final_product <= conv_std_logic_vector(signed(product1(31 downto 16)) + signed(product2(31 downto 16)),17);
end process;	

process(wb_clk,wb_rst)
begin
    if wb_rst = '1' then
		mult2sub_en <= '0';
	elsif wb_clk'event and wb_clk = '1' then	
		mult2sub_en <= stm2mult_en;
	end if;
end process;	


process(wb_clk,wb_rst,clk_ce,mult2sub_en)
begin
    if wb_rst = '1' then
       geortzel_out <=  (others=>'0');
    elsif wb_clk'event and wb_clk = '1' then
       if (clk_ce= '1' and mult2sub_en = '1') then 
            geortzel_out <=conv_std_logic_vector(signed(final_product) - signed(product4(31 downto 16)),17)(16 downto 1);
		 else
			geortzel_out <= (others=>'0');
       end if;
    end if;
end process; 
end Behavioral;

