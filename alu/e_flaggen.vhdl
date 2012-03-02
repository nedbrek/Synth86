library IEEE;
use IEEE.std_logic_1164.all;

entity flagGen is
port (
	sz    : in  std_logic_vector (1 downto 0);
	c     : in  std_logic_vector (64 downto 0);
	flags : out std_logic_vector (5 downto 0)
);
end;

