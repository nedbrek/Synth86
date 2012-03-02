library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

architecture ialu64 of alu64 is
component flagGen
port (
	sz    : in  std_logic_vector (1 downto 0);
	c     : in  std_logic_vector (64 downto 0);
	flags : out std_logic_vector (5 downto 0)
);
end component;

	signal tmp   : std_logic_vector(64 downto 0);
	signal msb   : std_logic; -- most significant bit
	signal mp1sb : std_logic; -- msb plus 1

	signal zeroBuf : std_logic_vector(63 downto 0);

begin
	fg : flagGen port map(sz, tmp, flags);

	process (clk)
	begin
		if (clk'event and clk = '1') then

			case op is
				when "000" => tmp <= ('0' & a) + ('0' & b);
				when "001" => tmp <= '0' & (a or b);
				when "010" => tmp <= ('0' & a) + ('0' & b) + cin;
				when "011" => tmp <= ('0' & a) - ('0' & b) - cin;
				when "100" => tmp <= '0' & (a and b);
				when "101" => tmp <= ('0' & a) - ('0' & b);
				when "110" => tmp <= '0' & (a xor b);
				when "111" => tmp <= ('0' & a) - ('0' & b);
				when others => tmp <= (others => '0');
			end case;

			c <= tmp(63 downto 0);
		end if;
	end process;

end;

