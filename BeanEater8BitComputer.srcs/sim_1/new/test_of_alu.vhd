----------------------------------------------------------------------------------
-- Company: None
-- Engineer: Gugolple
-- 
-- Create Date: 03/15/2023 04:55:16 PM
-- Module Name: test_of_alu - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: This module will test all operations of the ALU.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.constants;
use work.alu;

entity test_of_alu is
end test_of_alu;

architecture Behavioral of test_of_alu is
        signal substraction : std_logic;
        signal register_a_in : std_logic_vector(constants.bit_width -1 downto 0);
        signal register_b_in : std_logic_vector(constants.bit_width -1 downto 0);
        signal flag_zero : std_logic;
        signal flag_carry : std_logic;
        signal output :  std_logic_vector(constants.bit_width -1 downto 0);
        
component alu is
    Port (
        substraction : in std_logic;
        register_a_in : in std_logic_vector(constants.bit_width -1 downto 0);
        register_b_in : in std_logic_vector(constants.bit_width -1 downto 0);
        flag_zero : out std_logic;
        flag_carry : out std_logic;
        output : inout std_logic_vector(constants.bit_width -1 downto 0)
    );
end component;
begin
alu_instance : alu port map (
        substraction => substraction,
        register_a_in => register_a_in,
        register_b_in => register_b_in,
        flag_zero => flag_zero,
        flag_carry => flag_carry,
        output => output
);
substraction  <= '0';
register_a_in <= "01010101";
register_b_in <= "01010101";
end Behavioral;
