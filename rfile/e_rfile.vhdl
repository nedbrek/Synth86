library IEEE;
use IEEE.std_logic_1164.all;

-- two read, one write, 16 regs (supports masked writes)
entity rfile16r2w1 is
port (
	clk  : in std_logic;
	aIdx : in std_logic_vector(3 downto 0);
	bIdx : in std_logic_vector(3 downto 0);
	dIdx : in std_logic_vector(3 downto 0);
	sz   : in std_logic_vector(1 downto 0);
	we   : in std_logic;
	data : in std_logic_vector(63 downto 0);
	a : out std_logic_vector(63 downto 0);
	b : out std_logic_vector(63 downto 0)
);
end;

