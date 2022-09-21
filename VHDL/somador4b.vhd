library ieee;
use ieee.std_logic_1164.all;

entity somador4b is
    port(
        A, B: in std_logic_vector(3 downto 0);
        CIN: in std_logic;
        S: out std_logic_vector(3 downto 0);
        COUT: out std_logic
    );
end entity;

architecture structural of somador4b is

    signal carry: std_logic_vector(2 downto 0);

    
begin
    s1b0: entity work.somador1b(behavioural)
        port map (a => a(0), b => b(0), cin => cin, s => s(0), cout => carry(0));
    s1b1: entity work.somador1b(behavioural)
        port map (a => a(1), b => b(1), cin => carry(0), s => s(1), cout => carry(1));
    s1b2: entity work.somador1b(behavioural)
        port map (a => a(2), b => b(2), cin => carry(1), s => s(2), cout => carry(2));
    s1b3: entity work.somador1b(behavioural)
        port map (a => a(3), b => b(3), cin => carry(2), s => s(3), cout => cout);
    

end architecture;