library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

architecture synth of icache is
	type Ram is array(0 to 32768/dataWidth-1) of unsigned(dataWidth-1 downto 0);
	shared variable data : Ram := (
		0 => x"55aa40e9f8005a65742070726f636573",
		1 => x"736f7220616e6420536f432c00004942",
		2 => x"4d002076657273696f6e200076312e32",
		3 => x"2e302d382d67346263326462620a0d00",
		4 => x"436f7079726967687420284329203230",
		5 => x"30382d323031302c205a65757320476f",
		6 => x"6d657a204d61726d6f6c656a6f203c7a",
		7 => x"65757340616c757a696e612e6f72673e",
		others => x"00000000000000000000000000000000"
	);
begin
	ibyte <= data(to_integer(unsigned(vip(11 downto 0))));
end;

