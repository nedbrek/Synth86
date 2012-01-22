library IEEE;
use IEEE.std_logic_1164.all;

entity ned86 is
port (
	clk : in  std_logic;
	dbg : out std_logic_vector(63 downto 0)
);
end;

architecture synth of ned86 is
component alu64
port (
	clk   : in  std_logic;
	sz    : in  std_logic_vector (1 downto 0);
	a, b  : in  std_logic_vector (63 downto 0);
	cin   : in  std_logic;
	op    : in  std_logic_vector (2 downto 0);
	c     : out std_logic_vector (63 downto 0);
	flags : out std_logic_vector (5 downto 0)
);
end component;

signal sz    : std_logic_vector (1 downto 0);
signal a, b  : std_logic_vector (63 downto 0);
signal cin   : std_logic;
signal op    : std_logic_vector (2 downto 0);
signal c     : std_logic_vector (63 downto 0);
signal flags : std_logic_vector (5 downto 0);

begin
	alu1 : alu64 port map(clk, sz, a, b, cin, op, c, flags);

	sz <= "01";
	a <= c;
	b(63 downto 1) <= (others => '0');
	b(0) <= '1';
	cin <= '0';
	op <= "000";
	dbg <= c;
end;

