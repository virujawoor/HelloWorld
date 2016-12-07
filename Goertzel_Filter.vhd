library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;


entity Goertzel_Filter is
generic(coeff 			:  std_logic_vector(15 downto 0));  
  port( clk_gate      	: in std_logic;
        wb_clk      	: in std_logic;
        clk_enable    	: in std_logic;
        reset         	: in std_logic;
		q_rst         	: in std_logic;
		mid_mul_en     	: in std_logic;
        filter_in     	: in std_logic_vector(15 downto 0);        
		Q1_out    		: out std_logic_vector(15 downto 0);
		Q2_out    		: out std_logic_vector(15 downto 0);
		mid_out    		: out std_logic_vector(15 downto 0));
end Goertzel_Filter;

architecture Behavioral of Goertzel_Filter is 

signal product1 : std_logic_vector(31 downto 0) := (others=>'0') ;
signal product2 : std_logic_vector(31 downto 0) := (others=>'0') ;
signal product4 : std_logic_vector(31 downto 0) := (others=>'0') ;



signal Q1 : std_logic_vector(23 downto 0):=(others=>'0');
signal Q2 : std_logic_vector(23 downto 0):=(others=>'0');
signal delay_fil : std_logic_vector(24 downto 0) := (others=>'0');
signal mid 	: std_logic_vector(25 downto 0) := (others=>'0');

begin
process(filter_in,Q2)
 begin				
		delay_fil <= conv_std_logic_vector(signed(filter_in) - signed(Q2),25);    
end process;

process(clk_gate,reset,clk_enable,q_rst)
begin
    if reset = '1' then         
         Q1 <= (others=>'0');
         Q2 <= (others=>'0');			
    elsif clk_gate'event and clk_gate = '1' then
        if (clk_enable = '1') then                		   
            if(q_rst = '1') then              
               Q1 <= (others=>'0');
               Q2 <= (others=>'0');					
            else   
			   Q1 <=  conv_std_logic_vector(signed(delay_fil) + signed(mid),27)(23 downto 0);
               Q2 <= Q1;             
            end if;          
        end if;
    end if;
end process; 
  
Q1_out<=Q1(23 downto 8);
Q2_out<=Q2(23 downto 8);
mid_out<=mid(25 downto 10);


process(wb_clk,reset,mid_mul_en) 
begin
	if (reset='1') then
			mid <= (others=>'0');	
	elsif wb_clk'event and wb_clk ='1' then
        if (mid_mul_en='1') then					
			mid <= conv_std_logic_vector((signed(coeff)*signed(Q1(23 downto 8))),32)(31 downto 6); 
        end if;  						
	end if;			
end process;
 
end Behavioral; 