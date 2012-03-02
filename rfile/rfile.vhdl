library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture synth of rfile16r2w1 is
	type Storage is array(0 to 15) of std_logic_vector(63 downto 0);
	shared variable rfile : Storage;
begin
	process (clk)
	begin
		if (clk'event and clk = '1') then
			a <= rfile(to_integer(unsigned(aIdx)));
			b <= rfile(to_integer(unsigned(bIdx)));

			if (we = '1') then
				rfile(to_integer(unsigned(dIdx))) := data;
			end if;
		end if;
	end process;
end;

