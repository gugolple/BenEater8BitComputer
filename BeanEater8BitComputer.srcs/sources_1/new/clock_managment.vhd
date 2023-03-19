----------------------------------------------------------------------------------
-- Company: None
-- Engineer: Gugolple
-- 
-- Create Date: 03/19/2023 10:53:15 AM
-- Module Name: clock_managment - Behavioral
-- Description: This is a clock managment module, intended to handle all clock
--     related functionality.
--
--     The clock will halt until a reset signal is asserted. That will override
--     the halt signal for the clock and allow the sistem to reset.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity clock_managment is
  Port (
    -- clk is the crystal oscillator
    clk : in std_logic;
    -- reset
    reset : in std_logic;
    -- halt signal, to stop the clock
    halt : in std_logic;
    -- clk output from the control unit
    clk_out : out std_logic
   );
end clock_managment;

architecture Behavioral of clock_managment is
begin
    clk_out <= '1' when reset='0' and (halt='1' and halt /= 'U') else
        clk;
end Behavioral;

