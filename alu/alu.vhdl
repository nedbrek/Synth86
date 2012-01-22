library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

architecture ialu64 of alu64 is
	signal tmp   : std_logic_vector(64 downto 0);
	signal msb   : std_logic; -- most significant bit
	signal mp1sb : std_logic; -- msb plus 1

	signal zeroBuf : std_logic_vector(63 downto 0);

begin
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

			case sz is
				when "00" => -- byte
					msb   <= tmp(7);
					mp1sb <= tmp(8);

					zeroBuf(63 downto 8) <= (others => '0');
					zeroBuf(7 downto 0) <= tmp(7 downto 0);

				when "01" => -- word
					msb   <= tmp(15);
					mp1sb <= tmp(16);

					zeroBuf(63 downto 16) <= (others => '0');
					zeroBuf(15 downto 0) <= tmp(15 downto 0);

				when "10" => -- dword
					msb   <= tmp(31);
					mp1sb <= tmp(32);

					zeroBuf(63 downto 32) <= (others => '0');
					zeroBuf(31 downto 0) <= tmp(31 downto 0);

				when "11" => -- qword
					msb   <= tmp(63);
					mp1sb <= tmp(64);

					zeroBuf(63 downto 0) <= tmp(63 downto 0);

				when others =>
					msb <= '0';
					mp1sb <= '0';
					zeroBuf <= (others => '0');
			end case;

			c <= tmp(63 downto 0);

			flags(0) <= mp1sb; -- CF
			flags(1) <= '1'; -- PF
			flags(2) <= '1'; -- AF

			if (zeroBuf = "0") then
				flags(3) <= '1'; -- ZF
			else
				flags(3) <= '0';
			end if;

			flags(4) <= msb; -- SF
			flags(5) <= '0'; -- OF (SF^CF?)
		end if;
	end process;

end;

