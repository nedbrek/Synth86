library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- just make it work
-- only handle 1 prefix byte, else shift and stall
-- only intended for 1 macro per cycle
-- trick: treat 0F as prefix
architecture synthSimple of decode is

signal is0F : std_logic; -- is prefix for 2B

begin
	-- start decode
	process (ibytes)
	begin
	if ibytes(7 downto 0) = x"0F" then
		is0F <= '1';
	else
		is0F <= '0';
	end if;
	end process;
end;

