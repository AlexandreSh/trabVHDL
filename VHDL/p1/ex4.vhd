library ieee;
use ieee.std_logic_1164.all;


architecture structural of addern is 
    signal carryin : std_logic_vector(n down to 0) := '0';
    signal muxout : std_logic_vector(n down to 0) := '0';
    signal not_b : std_logic_vector(n down to 0) := not b;
begin
    carryin(0) <= op;
    not_b = not b;
    carryout <= carryin(n);
    addern_slice: for i in 0 to n-1 generate
        mux: entity work.mux21(dataflow)
            port map (input(0) => b(i), input(1) => not_b(i), sel => op, output => muxout(i));

        adder: entity work.adder1(dataflow)
            port map (a(i), muxout(i), carryin(i), result(i), carryin(i+1));
    end generate
end architecture 