----------------------------------------------------------------------------------
-- Company: None
-- Engineer: Gugolple
-- 
-- Create Date: 03/17/2023 04:55:16 PM
-- Module Name: jk_flip_flop - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: This module will be a JK flip flop as described in literature.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity jk_flip_flop is
    Port (
        j : in std_logic;
        k : in std_logic;
        clk : in std_logic;
        q : out std_logic;
        nq : out std_logic
    );
end jk_flip_flop;

architecture Behavioral of jk_flip_flop is
begin


process(clk)
variable state : std_logic := '0';
begin
-- Different states
if rising_edge(clk) then    
    -- Reset
    if j = '0' and k = '1' then
        state := '0';
    -- Set
    elsif j = '1' and k = '0' then
        state := '1';
    -- Toggle
    elsif j = '1' and k = '1' then
        state := not(state);
    end if;
    -- Maintain does not need because does not icurr in change.
    q <= state;
    nq <= not(state);
end if;
end process;
end Behavioral;
