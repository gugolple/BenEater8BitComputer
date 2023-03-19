----------------------------------------------------------------------------------
-- Company: None
-- Engineer: Gugolple
-- 
-- Create Date: 03/17/2023 10:06:47 AM
-- Module Name: counter - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: This module will be a counter, increasing each rising edge of the
--     clock pulse, with reset.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.constants;

entity counter is
    Generic(
        bit_size : integer := constants.bit_width 
    );
    Port (
        clk : in std_logic;
        reset : in std_logic;
        out_counter : out std_logic_vector(bit_size -1 downto 0)
    );
end counter;

architecture Behavioral of counter is
begin

process(reset,clk) is
    variable count : unsigned(bit_size -1 downto 0) := (others => '0');
begin
    if reset = '1' then
        count := (others => '0');
    elsif rising_edge(clk) then
        count := count + 1;
    end if;
    out_counter <= std_logic_vector(count);
end process;

end Behavioral;
