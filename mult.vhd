library IEEE;
use IEEE.numeric_bit.all;

entity mux is
	port (Q0, Q1, Q2, Q3, S0, S1: in bit; Y: out bit);
end mux;

architecture arch of mux is
begin
process (Q0,Q1,Q2,Q3,S0,S1) is
begin
  if (S0 ='0' and S1 = '0') then
      Y <= Q0;
  elsif (S0 ='1' and S1 = '0') then
      Y <= Q1;
  elsif (S0 ='0' and S1 = '1') then
      Y <= Q2;
  else
      Y <= Q3;
  end if;
end process;
end arch;

library IEEE;
use IEEE.numeric_bit.all;

entity bin_bcd is
    Port (X: in unsigned(8 downto 0); W0, W1, W2: out unsigned(7 downto 0));
end bin_bcd;

architecture Behavioral of bin_bcd is 
signal Y: unsigned(10 downto 0);
begin
process(X)
variable Z: unsigned(19 downto 0);
begin 
	Z := (others => '0');
   Z(11 downto 3) := X;
   for i in 0 to 5 loop
		if Z(12 downto 9) > 4 then
			Z(12 downto 9) := Z(12 downto 9) + 3;
      end if;
      if Z(16 downto 13) > 4 then
         Z(16 downto 13) := Z(16 downto 13) + 3;
      end if;
      if Z(19 downto 17) > 4 then
         Z(19 downto 17) := Z(19 downto 17) + 3;
      end if;
         Z(19 downto 1) := Z(18 downto 0);
    end loop;
    Y <= Z(19 downto 9);
end process;

process(Y(3 downto 0)) 
begin
	 case Y(3 downto 0) is 
		when "0000" => W0 <= "11000000";
		when "0001" => W0 <= "11111001";
		when "0010" => W0 <= "10100100";
		when "0011" => W0 <= "10110000";
		when "0100" => W0 <= "10011001";
		when "0101" => W0 <= "10010010";
		when "0110" => W0 <= "10000010";
		when "0111" => W0 <= "11111000";
		when "1000" => W0 <= "10000000";
		when "1001" => W0 <= "10010000";
		when others => W0 <= "11111111";
		end case;
end process;

process(Y(7 downto 4))
begin
	case Y(7 downto 4) is 
		when "0000" => W1 <= "11000000";
		when "0001" => W1 <= "11111001";
		when "0010" => W1 <= "10100100";
		when "0011" => W1 <= "10110000";
		when "0100" => W1 <= "10011001";
		when "0101" => W1 <= "10010010";
		when "0110" => W1 <= "10000010";
		when "0111" => W1 <= "11111000";
		when "1000" => W1 <= "10000000";
		when "1001" => W1 <= "10010000";
		when others => W1 <= "11111111";
		end case;
end process;

process(Y(10 downto 8))
begin
	case Y(10 downto 8) is 
		when "000" => W2 <= "11000000";
		when "001" => W2 <= "11111001";
		when "010" => W2 <= "10100100";
		when "011" => W2 <= "10110000";
		when "100" => W2 <= "10011001";
		when "101" => W2 <= "10010010";
		when "110" => W2 <= "10000010";
		when "111" => W2 <= "11111000";
		end case;		
end process;
end Behavioral;

library IEEE;
use IEEE.numeric_bit.all;

entity mult is
	port (A, B: in unsigned(3 downto 0); C: out unsigned(7 downto 0));
end mult;

architecture Behavioral of mult is

component mux
	port (Q0, Q1, Q2, Q3, S0, S1: in bit; Y: out bit);
end component;

component bin_bcd
    Port (X: in unsigned(8 downto 0); W0, W1, W2: out unsigned(7 downto 0));
end component;

signal M0, M1, M2, M3, M4, M5, M6, M7, M8, M9: bit;
signal L0, L1, L2, L3, L4, L5, L6, L7: bit;
signal D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14: bit;

begin
D0 <= A(1) and B(0);
D1 <= A(2) and B(0);
D2 <= A(3) nand B(0);
D3 <= A(0) and B(1);
D4 <= A(1) and B(1);
D5 <= A(2) and B(1);
D6 <= A(3) nand B(1);
D7 <= A(0) and B(2);
D8 <= A(1) and B(2);
D9 <= A(2) and B(2);
D10<= A(3) nand B(2);
D11<= A(0) nand B(3);
D12<= A(1) nand B(3);
D13<= A(2) nand B(3);
D14<= A(3) and B(3);
C(0) <= A(0) and B(0);
F0: mux port map('0', '1', '1', '0', D3, D0, C(1));
F1: mux port map('0', '0', '0', '1', D3, D0, M0);
F2: mux port map(M0, not M0, not M0, M0, D4, D1, L0);
F3: mux port map('0', M0, M0, '1', D4, D1, M1);
F4: mux port map(M1, not M1, not M1, M1, D5, D2, L1);
F5: mux port map('0', M1, M1, '1', D5, D2, M2);
F6: mux port map(M2, not M2, not M2, M2, D6, '1', L2);
F7: mux port map('0', M2, M2, '1', D6, '1', L3);
F8: mux port map('0', '1', '1', '0', D7, L0, C(2));
F9: mux port map('0', '0', '0', '1', D7, L0, M3);
F10:mux port map(M3, not M3, not M3, M3, D8, L1, L4);
F11:mux port map('0', M3, M3, '1', D8, L1, M4);
F12:mux port map(M4, not M4, not M4, M4, D9, L2, L5);
F13:mux port map('0', M4, M4, '1', D9, L2, M5);
F14:mux port map(M5, not M5, not M5, M5, D10, L3, L6);
F15:mux port map('0', M5, M5, '1', D10, L3, L7);
F16:mux port map('0', '1', '1', '0', D11, L4, C(3));
F17:mux port map('0', '0', '0', '1', D11, L4, M6);
F18:mux port map(M6, not M6, not M6, M6, D12, L5, C(4));
F19:mux port map('0', M6, M6, '1', D12, L5, M7);
F20:mux port map(M7, not M7, not M7, M7, D13, L6, C(5));
F21:mux port map('0', M7, M7, '1', D13, L6, M8);
F22:mux port map(M8, not M8, not M8, M8, D14, L7, C(6));
F23:mux port map('0', M8, M8, '1', D14, L7, M9);
F24:mux port map(M9, not M9, not M9, M9, '1', '0', C(7));

end Behavioral;

