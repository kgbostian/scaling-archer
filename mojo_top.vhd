----------------------------------------------------------------------------------
-- Mojo_top VHDL
-- Translated from Mojo-base Verilog project @ http://embeddedmicro.com/frontend/files/userfiles/files/Mojo-Base.zip
-- by Xark
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity mojo_top is
	port (
		clk					: in  std_logic;		-- 50Mhz clock
		rst_n					: in  std_logic;		-- "reset" button input (negative logic)
		cclk					: in  std_logic;		-- configuration clock (?) from AVR (to detect when AVR ready)
		--led					: out std_logic_vector(7 downto 0);	 -- 8 LEDs on Mojo board
		--Anode Mux
		data_in  			: in std_logic_vector(3 downto 0);
		data_out_mux 		: out std_logic_vector(15 downto 0);
		--Decoder
		data_out_decoder	: out std_logic_vector(3 downto 0);
		--Counter "Clock" signal
		counter_clock		: in std_logic
		
	);
end mojo_top;

architecture RTL of mojo_top is

signal rst	: std_logic;		-- reset signal (rst_n inverted for postive logic)
--Mux selector pins (bit 0,1), Decoder selector pins (bit 2,3)
signal sel  : std_logic_vector(3 downto 0);



begin
--rst <= not rst_n;
--led <= "10000000" when sel = "00" else
--		 "01000000" when sel = "01" else
--		 "00100000" when sel = "10" else
--		 "00010000" when sel = "11" else
--		 "00000000";


-- Bus multiplexer (anode side)
data_out_mux <= data_in & "000000000000" when sel(1 downto 0) = "00" else
				"0000" & data_in & "00000000" when sel(1 downto 0) = "01" else
				"00000000" & data_in & "0000" when sel(1 downto 0) = "10" else
				"000000000000" & data_in when sel(1 downto 0) = "11" else
				(others => '0');

--inv_out <= not inv_in; --Invertor

--Counter
process (counter_clock, rst_n) --Counter clock and reset button sensitivity list
begin

--reset
if(rst_n = '0') then 
	sel <= "0000";
--counter inc
elsif(counter_clock'event and counter_clock = '1') then
	sel <= sel + 1;
end if;
end process;


--Decoder
--sel(3 downto 2)
data_out_decoder <= "0001" when sel(3 downto 2) = "00" else
						  "0010" when sel(3 downto 2) = "01" else
						  "0100" when sel(3 downto 2) = "10" else
						  "1000" when sel(3 downto 2) = "11";

end RTL;
