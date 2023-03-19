----------------------------------------------------------------------------------
-- Company: None
-- Engineer: Gugolple
-- 
-- Create Date: 03/15/2023 04:55:16 PM
-- Module Name: constants - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: This module will publish all constants used through the project.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

package constants is
    constant bit_width : integer := 8;
    constant instruction_width : integer := 4;
    constant instruction_count : integer := 2 ** constants.instruction_width;
    constant period: time := 20 ns;
end constants;
