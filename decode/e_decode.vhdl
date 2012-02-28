library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity decode is
port (
	ibytes : in unsigned(127 downto 0); -- 16B from icache
	bytesValid : in std_logic_vector(15 downto 0); -- 1 bit per byte
	uop : out std_logic_vector(18 downto 0);
	jmp : out std_logic;
	imm : out std_logic_vector(63 downto 0)
);
end;

