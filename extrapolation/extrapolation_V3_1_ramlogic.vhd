library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library work;
--use work.package_params_top.all;

entity  extrapolation_1 is
port    (
         rstn_i             :   in  std_logic
;        clk_i              :   in  std_logic

;        ang_vld_i          :   in  std_logic
;        ang_i              :   in  std_logic_vector(31 downto 0)

;        calc_done_o        :   out std_logic
;        calc_angl_o        :   out std_logic_vector(31 downto 0)
);
end     extrapolation_1;

architecture rtl of extrapolation_1 is
    constant    LC_VLD_CNT_WID  :   natural := 8;
-- ###    constant    LC_VLD_CNT_250  :   std_logic_vector(LC_VLD_CNT_WID-1  downto 0) := conv_std_logic_vector( 250-1, LC_VLD_CNT_WID);
    constant    c_position_nr   :   natural := 186;   

    constant    c_c1            :   signed(9 downto 0) := "0101010101";  
    constant    c_c2            :   signed(9 downto 0) := "0110101011";   
    
    type        t_shift_reg    is array(c_position_nr downto 0)   of std_logic_vector(31 downto 0);
    signal      s_shift_reg      :   t_shift_reg;

--    signal      s_vld_cnt       :   std_logic_vector(LC_VLD_CNT_WID-1  downto 0);
    signal      s_bypass_cnt    :   integer range 0 to (c_position_nr + 1); 
	 signal      counter			  :   integer range 0 to (c_position_nr + 1);
	 signal 		 counter_93		  :   integer range 0 to (c_position_nr + 1);
	 signal      counter_186	  :   integer range 0 to (c_position_nr + 1);
	 signal      c					  :   integer range 0 to 6;
	 signal      ang_r           :   std_logic_vector (31 downto 0);
	 signal      ra              :   std_logic_vector (7 downto 0);
	 signal      wa              :   std_logic_vector (7 downto 0);
    signal      s_bypass        :   std_logic;
    signal      s_vld_400K      :   std_logic;
	 signal      v               :   std_logic;
    signal      s_vld_400K_1d   :   std_logic;
    signal      s_vld_400K_2d   :   std_logic;
    signal      s_vld_400K_3d   :   std_logic;
    signal      s_vld_400K_4d   :   std_logic;
    signal      s_vld_400K_5d   :   std_logic;
    signal      s_vld_400K_6d   :   std_logic;
    
    signal      s_ang_0         :   signed(31 downto 0);
    signal      s_ang_93        :   signed(31 downto 0);
    signal      s_ang_186       :   signed(31 downto 0);    
    
    signal      s_ang_0d93        :   signed(31 downto 0);
    signal      s_ang_0d186       :   signed(31 downto 0);   

    signal      s_ang_c1x0d93     :   signed(41 downto 0);
    signal      s_ang_c2x0d186    :   signed(41 downto 0);     
    
    signal      s_ang_diff1       :   signed(41 downto 0);
    signal      s_ang_c2x0d186_d  :   signed(41 downto 0);           

    signal      s_ang_sum1        :   signed(41 downto 0);      
    signal      s_ang_extra       :   signed(31 downto 0);
	 
	 component shift_ram IS
 	 PORT
	 (
		clock		: IN std_logic  := '1';
		data		: IN std_logic_vector (31 DOWNTO 0);
		rdaddress		: IN std_logic_vector (7 DOWNTO 0);
		wraddress		: IN std_logic_vector (7 DOWNTO 0);
		wren		: IN std_logic  := '0';
		q		: OUT std_logic_vector (31 DOWNTO 0)
	 );
    END component shift_ram;

begin
------------
---- bypass cnt 
-- after reset the counter counts valid input data until the shift register is full
-- in this time the extrapolated data output are replaced through input data  
-- when the shift register contains completely valid data, then the extrapolated data are enabled to the output 
-- 
------------
process(clk_i, rstn_i)
begin                 
    if  rstn_i = '0'        then
        s_bypass_cnt   <=  0;
        s_bypass       <=  '1';
    elsif(rising_edge(clk_i))   then
        if  (ang_vld_i = '1' and s_bypass_cnt < c_position_nr + 1) then
            s_bypass_cnt   <=  s_bypass_cnt + 1;
        end if;
        if (s_bypass_cnt = (c_position_nr + 1)) then
            s_bypass       <=  '0';
        end if;
	
    end if;
end process;


s_vld_400K  <=  ang_vld_i;

------------
---- capture
------------
process(clk_i, rstn_i)
begin                 
    if      rstn_i = '0'        then
        s_vld_400K_1d   <=  '0';
        s_vld_400K_2d   <=  '0';
        s_vld_400K_3d   <=  '0';
        s_vld_400K_4d   <=  '0';
        s_vld_400K_5d   <=  '0';
        s_vld_400K_6d   <=  '0';
		  s_shift_reg(0)  <=  (others=>'0');
		  
		  counter <= 0;
		  counter_93 <= 93;
		  counter_186 <= 186;
		  
    elsif(rising_edge(clk_i))   then
		  
        s_vld_400K_1d   <=  s_vld_400K;
        s_vld_400K_2d   <=  s_vld_400K_1d;
        s_vld_400K_3d   <=  s_vld_400K_2d;  
        s_vld_400K_4d   <=  s_vld_400K_3d;
        s_vld_400K_5d   <=  s_vld_400K_4d;  
        s_vld_400K_6d   <=  s_vld_400K_5d;    
        if  (s_vld_400K = '1') then
				
            
				
				if(counter = 0) then
					counter_93 <= 93;
					counter_186 <=186;
					s_shift_reg(c_position_nr) <= ang_i;
					counter <= c_position_nr;
				else
					s_shift_reg(counter-1)  <=  ang_i;
					counter <= counter - 1;
				end if;
				
				
				if(counter = 94) then
					counter_93 <= c_position_nr;
				else
					counter_93 <= counter_93 - 1;
				end if;
				
				
				if(counter = 1) then
					counter_186 <= c_position_nr;
				else
					counter_186 <= counter_186 - 1;
				end if;

				
        end if;
    end if;
end process;
------------
---- extrapolation
------------
s_ang_0            <=  signed(s_shift_reg(counter));
s_ang_93           <=  signed(s_shift_reg(counter_93));
s_ang_186          <=  signed(s_shift_reg(counter_186)); 
   
process(clk_i, rstn_i)
begin                 
    if      rstn_i = '0'        then
        s_ang_0d93      <=  (others=> '0');
        s_ang_0d186     <=  (others=> '0');
        s_ang_c1x0d93   <=  (others=> '0');
        s_ang_c2x0d186  <=  (others=> '0');
        s_ang_diff1     <=  (others=> '0');
        s_ang_c2x0d186_d  <=  (others=> '0');
        s_ang_sum1      <=  (others=> '0');
        s_ang_extra     <=  (others=> '0');
    elsif(rising_edge(clk_i))   then
        if  (s_vld_400K_1d='1') then
            s_ang_0d93  <=  s_ang_0 - s_ang_93;
            s_ang_0d186 <=  s_ang_0 - s_ang_186;
        end if;
        if  (s_vld_400K_2d='1') then
            s_ang_c1x0d93  <=  c_c1 * s_ang_0d93;
            s_ang_c2x0d186 <=  c_c2 * s_ang_0d186;
        end if;
        if  (s_vld_400K_3d='1') then
            s_ang_diff1      <=  (s_ang_0 & "0000000000") - s_ang_c1x0d93;
            s_ang_c2x0d186_d <=  s_ang_c2x0d186;
        end if;
        if  (s_vld_400K_4d='1') then
            s_ang_sum1 <= s_ang_diff1 + s_ang_c2x0d186_d;
        end if;
         -- truncation with rounding
        if  (s_vld_400K_5d='1') then
             s_ang_extra <= s_ang_sum1(41 downto 10) + (("0000000000000000000000000000000") & s_ang_sum1(9));
        end if;         
        
    end if;
end process;

shift_ram_inst : shift_ram PORT MAP (
		clock	 => clk_i,
		data	 => ang_i,
		rdaddress	 => ra,
		wraddress	 => wa,
		wren	 => ang_vld_i,
		q	 => ang_r
);
	

calc_done_o <=  s_vld_400K_6d;
calc_angl_o <= ang_i when s_bypass = '1' else
               std_logic_vector(s_ang_extra);

end rtl;
