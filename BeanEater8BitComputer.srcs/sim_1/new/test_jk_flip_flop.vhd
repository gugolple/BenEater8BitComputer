----------------------------------------------------------------------------------
-- Company: None
-- Engineer: Gugolple
-- 
-- Create Date: 03/17/2023 09:38:03 AM
-- Design Name: 
-- Module Name: test_jk_flip_flop - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: This module will test all operations of the JK flip flop.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.jk_flip_flop;


entity test_jk_flip_flop is
--  Port ( );
end test_jk_flip_flop;

architecture Behavioral of test_jk_flip_flop is
signal j,k,clk,q,nq : std_logic;

component jk_flip_flop is
    Port (
        j : in std_logic;
        k : in std_logic;
        clk : in std_logic;
        q : out std_logic;
        nq : out std_logic
    );
end component;
begin
jk_instance : jk_flip_flop port map (
        j => j,
        k => k,
        clk => clk,
        q => q,
        nq => nq
);

tb1 : process
    use work.constants;
begin
    -- Initialization all inputs clock cycle
    j <= '0';
    k <= '0';
    clk <= '0';
    wait for constants.period;
    clk <= '1';
    wait for constants.period;
    clk <= '0';
    wait for constants.period;
    
    
    
    -- Set jk to q=1 and nq=0
    j <= '1';
    k <= '0';
    -- Do the clock cycle
    clk <= '1';
    wait for constants.period;
    clk <= '0';
    wait for constants.period;
    -- Check results
    assert (q = '1') report "Set of jk incorrect q" severity error;
    assert (nq = '0') report "Set of jk incorrect nq" severity error;
    
    
    -- Reset jk to q=0 and nq=1
    j <= '0';
    k <= '1';
    wait for constants.period;
    -- Do the clock cycle
    clk <= '1';
    wait for constants.period;
    clk <= '0';
    wait for constants.period;
    -- Check results
    assert (q = '0') report "Reset of jk incorrect q" severity error;
    assert (nq = '1') report "Reset of jk incorrect nq" severity error;
    
    
    -- Toggle jk to q=1 and nq=0
    j <= '1';
    k <= '1';
    wait for constants.period;
    -- Do the clock cycle
    clk <= '1';
    wait for constants.period;
    clk <= '0';
    wait for constants.period;
    -- Check results
    assert (q = '1') report "Toggle of jk incorrect q" severity error;
    assert (nq = '0') report "Toggle of jk incorrect nq" severity error;
    
    
    -- Keep jk to q=1 and nq=0
    j <= '0';
    k <= '0';
    wait for constants.period;
    -- Do the clock cycle
    clk <= '1';
    wait for constants.period;
    clk <= '0';
    wait for constants.period;
    -- Check results
    assert (q = '1') report "Keep of jk incorrect q" severity error;
    assert (nq = '0') report "Keep of jk incorrect nq" severity error;
    
    wait;
end process;

end Behavioral;
