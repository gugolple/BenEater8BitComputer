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

library IEEE;

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

tb1 : process
    use IEEE.math_real.all;
    use IEEE.numeric_std.all;
    constant period: time := 20 ns;
    constant max_val : integer := 2 ** constants.bit_width;
    variable calculated_flag_zero : std_logic;
    variable resulting_flag_zero : std_logic;
    variable calculated_flag_carry : std_logic;
    variable resulting_flag_carry : std_logic;
begin
    for reg_a in 0 to max_val -1 loop
        for reg_b in 0 to max_val -1 loop
            -- Set register values
            register_a_in <= std_logic_vector(
                to_unsigned(reg_a, constants.bit_width));
            register_b_in <= std_logic_vector(
                to_unsigned(reg_b, constants.bit_width));
            
            -- Set to addition
            substraction  <= '0';
            
            -- Check correct results for addition
            wait for period;
            assert (output = std_logic_vector(to_unsigned(
                    ((reg_a + reg_b) mod max_val), constants.bit_width))
                )
                report "output test failed for addition " 
                    & integer'image(reg_a) & " + " & integer'image(reg_b)
                    severity error;
                
--            -- Check the zero flag
--            if (reg_a + reg_b) = 0 then
--                calculated_flag_zero := '1';
--            else
--                calculated_flag_zero := '0';
--            end if;
--            assert (To_bit(flag_zero) and To_bit(calculated_flag_zero))
--                report "flag zero test failed for addition " 
--                    & integer'image(reg_a)  & " + " 
--                    & integer'image(reg_b) & " value " 
--                    & boolean'image(flag_zero) & " gotten "
--                    & boolean'image(calculated_flag_zero)
--                    severity error;
                
--            -- Check the carry flag
--            if (reg_a + reg_b) >= max_val then
--                calculated_flag_carry := '1';
--            else
--                calculated_flag_carry := '0';
--            end if;
--            assert (To_bit(flag_carry) and To_bit(calculated_flag_carry))
--                report "flag carry test failed for addition " 
--                    & integer'image(reg_a)  & " + " 
--                    & integer'image(reg_b) & " value " 
--                    & boolean'image(flag_carry) & " gotten "
--                    & boolean'image(calculated_flag_carry)
--                    severity error;
            
            -- Set to substraction
            substraction  <= '1';
            
            -- Check correct results for substraction
            wait for period;
            assert (output = std_logic_vector(to_unsigned(
                ((reg_a - reg_b) mod max_val), constants.bit_width))
            )
                report "output test failed for substraction " 
                    & integer'image(reg_a)  & " - "
                    & integer'image(reg_b) 
                    severity error;
                
--            -- Check the zero flag
--            if (reg_a - reg_b) = 0 then
--                calculated_flag_zero := '1';
--            else
--                calculated_flag_zero := '0';
--            end if;
--            assert (To_bit(flag_zero) and To_bit(calculated_flag_zero))
--                report "flag zero test failed for substraction " 
--                    & integer'image(reg_a)  & " - " 
--                    & integer'image(reg_b) & " value " 
--                    & boolean'image(flag_zero) & " gotten "
--                    & boolean'image(calculated_flag_zero)
--                    severity error;
                
--            -- Check the carry flag
--            if (reg_a + reg_b + 1) >= max_val then
--                calculated_flag_carry := '1';
--            else
--                calculated_flag_carry := '0';
--            end if;
--            assert (To_bit(flag_carry) and To_bit(calculated_flag_carry))
--                report "flag carry test failed for substraction " 
--                    & integer'image(reg_a)  & " - " 
--                    & integer'image(reg_b) & " value " 
--                    & boolean'image(flag_carry) & " gotten "
--                    & boolean'image(calculated_flag_carry)
--                    severity error;
        end loop;
    end loop;
    wait; -- indefinitely suspend process
end process;
end Behavioral;
