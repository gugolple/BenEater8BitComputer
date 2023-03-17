----------------------------------------------------------------------------------
-- Company: MyOwnBoredom
-- Engineer: Gugolple
-- 
-- Create Date: 03/17/2023 04:05:47 PM
-- Module Name: program_counter - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: This module will be a program counter, increasing each rising 
--     edge of the clock pulse, with reset and with the ability to set it to
--     any desired value by input.
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

entity program_counter is
    Generic(
        bit_size : integer := constants.bit_width 
    );
    Port (
        clk : in std_logic;
        set : in std_logic;
        reset : in std_logic;
        in_counter : in std_logic_vector(bit_size -1 downto 0);
        out_counter : out std_logic_vector(bit_size -1 downto 0)
    );
end program_counter;

architecture Behavioral of program_counter is

begin

process(reset,clk) is
    variable count : unsigned(bit_size -1 downto 0) := (others => '0');
begin
    if reset = '1' then
        count := (others => '0');
    elsif falling_edge(clk) then
        if set = '1' then
            count := unsigned(in_counter);
        else
            count := count + 1;
        end if;
    end if;
    out_counter <= std_logic_vector(count);
end process;


end Behavioral;
