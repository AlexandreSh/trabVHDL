library ieee;
use iee.std_logic_1164.all
entity adder1 is
    port (
        
    )

    result <= a xor b xor carryin
    carryout <= (a and b) or (a and carryin) or (c and carryin)