----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2023 10:17:00 AM
-- Design Name: 
-- Module Name: test_counter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_counter is
end test_counter;

architecture Behavioral of test_counter is
component counter is
    Generic(
        bit_size : integer
    );
    Port (
        clk : in std_logic;
        reset : in std_logic;
        out_counter : out std_logic_vector(bit_size -1 downto 0)
    );
end component;
    constant bit_size : integer := 4;
    constant max_val : integer := 2 ** bit_size;
    constant iterations : integer := 5;
    signal clk, reset : std_logic;
    signal out_counter : std_logic_vector(bit_size -1 downto 0);
begin
-- The counter
counter_instance : counter 
    Generic map (bit_size => bit_size)
    Port map(
        clk => clk,
        reset => reset,
        out_counter => out_counter
    );
    
process is
    use work.constants;
    use IEEE.numeric_std.all;
begin
    -- Loop a couple of iterations
    for num_loop_count in 0 to iterations loop
        -- Initialize element by pulsing a clock.
        reset <= '1';
        clk <= '0';
        wait for constants.period;
        clk <= '1';
        wait for constants.period;
        reset <= '0';
        clk <= '0';
        wait for constants.period;
        
        -- Test full loop of element
        for i in 0 to max_val -1 loop
            assert (std_logic_vector(to_unsigned(i,bit_size)) = out_counter) 
                report "Error in counter at cycle " 
                & integer'image(i) & " value read "
                & integer'image(to_integer(signed(out_counter)))
                severity error;
            clk <= '1';
            wait for constants.period;
            clk <= '0';
            wait for constants.period;
        end loop;
        assert (std_logic_vector(to_unsigned(0,bit_size)) = out_counter) 
            report "Error in counter at rollover value read "
            & integer'image(to_integer(signed(out_counter)))
            severity error;
            
            
        -- Test in part loop of element
        for i in 0 to (max_val/2) -1 loop
            assert (std_logic_vector(to_unsigned(i,bit_size)) = out_counter) 
                report "Error in counter at cycle " 
                & integer'image(i) & " value read "
                & integer'image(to_integer(signed(out_counter)))
                severity error;
            clk <= '1';
            wait for constants.period;
            clk <= '0';
            wait for constants.period;
        end loop;
    end loop;
    wait;
end process;

end Behavioral;
