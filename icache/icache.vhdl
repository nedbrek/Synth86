library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

architecture synth of icache is
	type Ram is array(0 to 32768/dataWidth-1) of std_logic_vector(dataWidth-1 downto 0);
	shared variable data : Ram := (
		0 => x"ef",
		1 => x"be",
		2 => x"ad",
		3 => x"de",
		4 => x"0d",
		5 => x"f0",
		6 => x"ad",
		7 => x"ba",
		others => x"00"
	);
begin
	ibyte <= data(to_integer(unsigned(vip(11 downto 0))));
end;

