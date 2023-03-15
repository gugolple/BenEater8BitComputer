----------------------------------------------------------------------------------
-- Company: None
-- Engineer: Gugolple
-- 
-- Create Date: 03/15/2023 04:55:16 PM
-- Module Name: alu - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: This module will be a full 1 bit adder.
--     Based on: https://en.wikipedia.org/wiki/Adder_(electronics)
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is 
    Port (
        bit_a : in std_logic;
        bit_b : in std_logic;
        bit_carry : in std_logic;
        output_bit : out std_logic;
        output_carry : out std_logic
    );
end full_adder;

architecture Behavioral of full_adder is
signal intermediate : std_logic;
begin

intermediate <= bit_a xor bit_b;

output_bit <= intermediate xor bit_carry;

output_carry <= (bit_a and bit_b) or (intermediate and bit_carry);

end Behavioral;
