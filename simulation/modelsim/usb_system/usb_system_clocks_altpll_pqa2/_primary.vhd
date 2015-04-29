library verilog;
use verilog.vl_types.all;
entity usb_system_clocks_altpll_pqa2 is
    port(
        areset          : in     vl_logic;
        clk             : out    vl_logic_vector(4 downto 0);
        inclk           : in     vl_logic_vector(1 downto 0);
        locked          : out    vl_logic
    );
end usb_system_clocks_altpll_pqa2;
