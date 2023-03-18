----------------------------------------------------------------------------------
-- Company: None
-- Engineer: Gugolple
-- 
-- Create Date: 03/15/2023 04:55:16 PM
-- Module Name: register_unit - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: This module will be an aproximation of the register from the
--     video https://www.youtube.com/watch?v=-arYx_oVIj8 intended as a building
--     block for the rest of the system.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.constants;

entity register_unit is
  Generic(
    bit_size : integer := constants.bit_width 
  );
  Port (
    clk : in std_logic;
    load : in std_logic;
    data_in : in std_logic_vector(bit_size -1 downto 0);
    data_out : out std_logic_vector(bit_size -1 downto 0)
  );
end register_unit;

architecture Behavioral of register_unit is
signal data_stored : std_logic_vector(bit_size -1 downto 0);
begin
data_out <= data_stored;

data_input_process : process(clk, load)
begin
    if falling_edge(clk)
    then
        data_stored <= data_in when load;
    end if;
end process;

end Behavioral;
