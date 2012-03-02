library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

entity sftAry is
generic (amt : integer := 1);
port (
	a   : in  std_logic_vector (64 downto 0); -- has cOut from prev
	cin : in  std_logic;
	mux : in  std_logic;
	c   : out std_logic_vector (65 downto 0) -- cout,64,cin
);
end;

architecture synth of sftAry is
	signal tmp : std_logic_vector(65 downto 0);
begin
	process (a, cin, mux, tmp)
	begin
		tmp(65 downto 0) <= a & cin;

		if (mux = '1') then
			c(65 downto amt) <= tmp(65-amt downto 0);
			c(amt-1 downto 0) <= (others => '0');
		else
			c(65 downto 0) <= tmp;
		end if;
	end process;
end;

architecture synth of sft64 is
	component sftAry
		generic (amt : integer := 1);
		port (
			a   : in  std_logic_vector (64 downto 0);
			cin : in  std_logic;
			mux : in  std_logic;
			c   : out std_logic_vector (65 downto 0)
		);
	end component;

	signal sIn   : std_logic_vector(64 downto 0);
	signal sO1   : std_logic_vector(65 downto 0);
	signal sO2   : std_logic_vector(65 downto 0);
	signal sO3   : std_logic_vector(65 downto 0);
	signal sO4   : std_logic_vector(65 downto 0);
	signal sO5   : std_logic_vector(65 downto 0);

	signal tmp   : std_logic_vector(65 downto 0);
	signal mulOut: std_logic_vector(127 downto 0);
	signal msb   : std_logic; -- most significant bit
	signal mp1sb : std_logic; -- msb plus 1

	signal zeroBuf : std_logic_vector(63 downto 0);

begin
	sIn <= '0' & a;

	sft_layer1 : sftAry generic map (amt => 1)
		port map(sIn, cin, b(0), sO1);
	sft_layer2 : sftAry generic map (amt => 2)
		port map(sO1(65 downto 1), sO1(0), b(1), sO2);
	sft_layer3 : sftAry generic map (amt => 4)
		port map(sO2(65 downto 1), sO2(0), b(2), sO3);
	sft_layer4 : sftAry generic map (amt => 8)
		port map(sO3(65 downto 1), sO3(0), b(3), sO4);
	sft_layer5 : sftAry generic map (amt => 16)
		port map(sO4(65 downto 1), sO4(0), b(4), sO5);
	sft_layer6 : sftAry generic map (amt => 32)
		port map(sO5(65 downto 1), sO5(0), b(5), tmp);

	process (clk)
	begin
		if (clk'event and clk = '1') then

			case sz is
				when "00" => -- byte
					msb   <= tmp(8);
					mp1sb <= tmp(9);

					zeroBuf(63 downto 8) <= (others => '0');
					zeroBuf(7 downto 0) <= tmp(8 downto 1);

				when "01" => -- word
					msb   <= tmp(16);
					mp1sb <= tmp(17);

					zeroBuf(63 downto 16) <= (others => '0');
					zeroBuf(15 downto 0) <= tmp(16 downto 1);

				when "10" => -- dword
					msb   <= tmp(32);
					mp1sb <= tmp(33);

					zeroBuf(63 downto 32) <= (others => '0');
					zeroBuf(31 downto 0) <= tmp(32 downto 1);

				when "11" => -- qword
					msb   <= tmp(64);
					mp1sb <= tmp(65);

					zeroBuf(63 downto 0) <= tmp(64 downto 1);

				when others =>
					msb <= '0';
					mp1sb <= '0';
					zeroBuf <= (others => '0');
			end case;

			c <= tmp(64 downto 1);

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
		end if;
	end process;

end;

