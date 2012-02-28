library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity icache is
generic (dataWidth : integer := 8);
port (
	vip   : in  std_logic_vector(63 downto 0);
	ibyte : out unsigned(dataWidth-1 downto 0)
);
end;

