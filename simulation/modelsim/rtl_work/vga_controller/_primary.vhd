library verilog;
use verilog.vl_types.all;
entity vga_controller is
    generic(
        hpixels         : vl_logic_vector(9 downto 0) := (Hi1, Hi1, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1, Hi1);
        vlines          : vl_logic_vector(9 downto 0) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0)
    );
    port(
        Clk             : in     vl_logic;
        Reset           : in     vl_logic;
        hs              : out    vl_logic;
        vs              : out    vl_logic;
        pixel_clk       : out    vl_logic;
        blank           : out    vl_logic;
        sync            : out    vl_logic;
        DrawX           : out    vl_logic_vector(9 downto 0);
        DrawY           : out    vl_logic_vector(9 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of hpixels : constant is 2;
    attribute mti_svvh_generic_type of vlines : constant is 2;
end vga_controller;
