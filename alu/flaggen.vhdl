library IEEE;
use IEEE.std_logic_1164.all;

architecture synth of flagGen is
	signal msb   : std_logic; -- most significant bit
	signal mp1sb : std_logic; -- msb plus 1

	signal zeroBuf : std_logic_vector(63 downto 0);

begin
	process (sz, c)
	begin
		case sz is
			when "00" => -- byte
				msb   <= c(7);
				mp1sb <= c(8);

				zeroBuf(63 downto 8) <= (others => '0');
				zeroBuf(7 downto 0) <= c(7 downto 0);

			when "01" => -- word
				msb   <= c(15);
				mp1sb <= c(16);

				zeroBuf(63 downto 16) <= (others => '0');
				zeroBuf(15 downto 0) <= c(15 downto 0);

			when "10" => -- dword
				msb   <= c(31);
				mp1sb <= c(32);

				zeroBuf(63 downto 32) <= (others => '0');
				zeroBuf(31 downto 0) <= c(31 downto 0);

			when "11" => -- qword
				msb   <= c(63);
				mp1sb <= c(64);

				zeroBuf(63 downto 0) <= c(63 downto 0);

			when others =>
				msb <= '0';
				mp1sb <= '0';
				zeroBuf <= (others => '0');
		end case;

		flags(0) <= mp1sb; -- CF
		flags(1) <= '1'; -- PF
		flags(2) <= '1'; -- AF

		if (zeroBuf = x"0000000000000000") then
			flags(3) <= '1'; -- ZF
		else
			flags(3) <= '0';
		end if;

		flags(4) <= msb; -- SF
		flags(5) <= '0'; -- OF (SF^CF?)
	end process;
end;

