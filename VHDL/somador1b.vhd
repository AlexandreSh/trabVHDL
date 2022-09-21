library ieee;
use ieee.std_logic_1164.all;

entity somador1b is
    port(
        a, b, cin :in std_ulogic;
        s, cout :out std_ulogic
    );
    end somador1b;

architecture behavioural of somador1b is begin
    s <= a xor b xor cin;
    cout <=(a and b) or (a and cin) or (b and cin);
end behavioural;