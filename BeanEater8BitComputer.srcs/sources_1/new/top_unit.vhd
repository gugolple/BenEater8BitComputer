----------------------------------------------------------------------------------
-- Company: MyOwnBoredom
-- Engineer: Gugolple
-- 
-- Create Date: 03/19/2023 11:18:06 AM
-- Design Name: 
-- Module Name: top_unit - Behavioral
-- Description: This module will connect the IO from the FPGA to out system
--     module.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.constants;

entity top_unit is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (1 downto 0);
           led : out STD_LOGIC_VECTOR (3 downto 0));
end top_unit;

architecture Behavioral of top_unit is
use work.clock_divider;
component clock_divider is 
    Generic (count : integer := 12_500_000);
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end component;
signal clk_divided: std_logic;

use work.interconection_bus;
component interconection_bus is 
    Generic(
        bit_size : integer := constants.bit_width 
    );
    Port (
        external_clk : in std_logic;
        reset : in std_logic;
        output : out std_logic_vector(bit_size -1 downto 0)
    );
end component;
signal reset : std_logic;

signal data_out : std_logic_vector(constants.bit_width -1 downto 0);
begin

clock_divider_instance : clock_divider 
    generic map (count => 1_250_000)
    port map(
        clk_in => clk,
        clk_out => clk_divided
    );

interconect_bus_instance : interconection_bus
    generic map( bit_size => constants.bit_width)
    port map(
        external_clk => clk_divided,
        reset => reset,
        output => data_out
    );

process(clk_divided) is
    variable last_btn_status : std_logic;
begin
    if rising_edge(clk_divided) then
        last_btn_status := btn(0);
    end if;
    reset <= last_btn_status;
end process; 

led <= data_out(3 downto 0);

end Behavioral;
