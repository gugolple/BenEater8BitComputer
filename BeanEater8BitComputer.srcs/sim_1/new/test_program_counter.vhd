----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2023 04:13:52 PM
-- Design Name: 
-- Module Name: test_program_counter - Behavioral
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

use work.constants;
use work.test_counter;

entity test_program_counter is
    Generic(
        bit_size : integer := 4;
        iterations : integer := 2
    );
end test_program_counter;

architecture Behavioral of test_program_counter is
component program_counter is
    Generic(
        bit_size : integer := constants.bit_width 
    );
    Port (
        clk : in std_logic;
        set : in std_logic;
        reset : in std_logic;
        in_counter : in std_logic_vector(bit_size -1 downto 0);
        out_counter : out std_logic_vector(bit_size -1 downto 0)
    );
end component;
    constant max_val : integer := 2 ** bit_size;
    signal clk, set, reset : std_logic;
    signal in_counter : std_logic_vector(bit_size -1 downto 0);
    signal out_counter : std_logic_vector(bit_size -1 downto 0);
begin
-- The counter
program_counter_instance : program_counter 
    Generic map (bit_size => bit_size)
    Port map(
        clk => clk,
        set => set,
        reset => reset,
        in_counter => in_counter,
        out_counter => out_counter
    );
    
process is
    use work.constants;
    use IEEE.numeric_std.all;
begin
    -- Loop a couple of iterations
    for num_loop_count in 0 to iterations loop
        -- Initialize program counter specifics
        set <= '0';
        in_counter <= (others => '0');
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
        
        set <= '1';
        -- Test full loop manual set
        for i in 0 to max_val -1 loop
            in_counter <= std_logic_vector(to_unsigned(i,bit_size));
            clk <= '1';
            wait for constants.period;
            clk <= '0';
            wait for constants.period;
            assert (std_logic_vector(to_unsigned(i,bit_size)) = out_counter) 
                report "Error in counter at cycle " 
                & integer'image(i) & " value read "
                & integer'image(to_integer(signed(out_counter)))
                severity error;
        end loop;
    end loop;
    wait;
end process;
end Behavioral;
