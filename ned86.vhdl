library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ned86 is
port (
	clk : in  std_logic;
	dUop: in  std_logic_vector(18 downto 0);
	dIn : in  std_logic_vector(63 downto 0);
	dbg : out std_logic_vector(63 downto 0);
	dFl : out std_logic_vector(5 downto 0);
	dIt : out std_logic_vector(7 downto 0)
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

component sft64 is
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

component icache is
generic (dataWidth : integer := 8);
port (
	vip   : in  std_logic_vector(63 downto 0);
	ibyte : out unsigned(dataWidth-1 downto 0)
);
end component;

component decode is
port (
   ibytes : in unsigned(127 downto 0); -- 16B from icache
   bytesValid : in std_logic_vector(15 downto 0); -- 1 bit per byte
   uop : out std_logic_vector(18 downto 0);
   jmp : out std_logic;
   imm : out std_logic_vector(63 downto 0)
);
end component;

component rfile16r2w1 is
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
end component;

signal sz    : std_logic_vector (1 downto 0);
signal a, b  : std_logic_vector (63 downto 0);
signal cin   : std_logic;
signal c     : std_logic_vector (63 downto 0);
signal aluOut: std_logic_vector (63 downto 0);
signal sftOut: std_logic_vector (63 downto 0);
signal flags : std_logic_vector (5 downto 0);
signal aFlags: std_logic_vector (5 downto 0);
signal sFlags: std_logic_vector (5 downto 0);
signal instBytes : unsigned(127 downto 0);
signal we : std_logic;
signal aIdx : std_logic_vector(3 downto 0);
signal bIdx : std_logic_vector(3 downto 0);
signal dIdx : std_logic_vector(3 downto 0);
signal op   : std_logic_vector(2 downto 0);
signal opSel: std_logic;
signal uop  : std_logic_vector(18 downto 0);
signal decJmp : std_logic;
signal decImm : std_logic_vector(63 downto 0);

begin
	alu1 : alu64 port map(clk, sz, a, b, cin, op, aluOut, aFlags);
	sft1 : sft64 port map(clk, sz, a, b, cin, op, sftOut, sFlags);
	ic : icache
	   generic map (dataWidth => 128)
	   port map(b, instBytes);
	rf : rfile16r2w1 port map(clk, aIdx, bIdx, dIdx, sz, we, dIn, a, b);
	dec : decode port map(instBytes, x"ffff", uop, decJmp, decImm);

	-- uop decoding
	opSel<= dUop(18);
	op   <= dUop(17 downto 15);
	sz   <= dUop(14 downto 13);
	aIdx <= dUop(12 downto 9);
	bIdx <= dUop(8 downto 5);
	we   <= dUop(4);
	dIdx <= dUop(3 downto 0);

	cin <= flags(0);

	dbg <= c;
	dFl <= flags;
	dIt <= std_logic_vector(instBytes(7 downto 0));

	process (opSel, aluOut, sftOut, aFlags, sFlags)
	begin
		if (opSel = '1') then
			c <= aluOut;
			flags <= aFlags;
		else
			c <= sftOut;
			flags <= sFlags;
		end if;
	end process;
end;

