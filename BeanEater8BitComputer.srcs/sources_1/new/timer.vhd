----------------------------------------------------------------------------------
-- Company: None
-- Engineer: Gugolple
-- 
-- Create Date: 03/15/2023 04:55:16 PM
-- Module Name: timer - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: This is a timer control module, intended to handle all clock
--     related functionality.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity timer is
  Port (
    -- clk is the crystal oscillator
    clk : in std_logic;
    -- enable signal to stop the clock
    enable: in std_logic;
    -- clk output from the control unit
    clk_out : out std_logic
   );
end timer;

architecture Behavioral of timer is
    signal local_clk : std_logic := '0';
begin
    clk_out <= clk and enable;
end Behavioral;
