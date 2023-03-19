----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2023 08:19:26 AM
-- Design Name: 
-- Module Name: main_cpu_simulation - Behavioral
-- Description: This module will test the top component of the sistem,
--     simulating a simple program loaded in ram.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.all;

entity main_cpu_simulation is
end main_cpu_simulation;

architecture Behavioral of main_cpu_simulation is
component interconection_bus is
    Generic(
        bit_size : integer := constants.bit_width 
    );
    Port (
        external_clk : in std_logic;
        reset : in std_logic
    );
end component;
    signal clk, reset : std_logic;
begin

program_interconection_bus : interconection_bus 
    Generic map (bit_size => constants.bit_width )
    Port map(
        external_clk => clk,
        reset => reset
    );
    
process is
    constant reset_iteration_count : integer := 10;
    constant iteration_count : integer := 100;
begin
    reset <= '1';
    for i in 0 to reset_iteration_count -1 loop
        clk <= '1';
        wait for constants.period;
        clk <= '0';
        wait for constants.period;
    end loop;
    reset <= '0';
    wait for constants.period;
    for i in 0 to iteration_count -1 loop
        clk <= '1';
        wait for constants.period;
        clk <= '0';
        wait for constants.period;
    end loop;
    wait;
end process;
    
end Behavioral;
