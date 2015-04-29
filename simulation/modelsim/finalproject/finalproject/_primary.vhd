library verilog;
use verilog.vl_types.all;
entity finalproject is
    port(
        clk_clk         : in     vl_logic;
        keycode_export  : out    vl_logic_vector(7 downto 0);
        reset_reset_n   : in     vl_logic;
        sdram_out_clk_clk: out    vl_logic;
        sdram_wire_addr : out    vl_logic_vector(12 downto 0);
        sdram_wire_ba   : out    vl_logic_vector(1 downto 0);
        sdram_wire_cas_n: out    vl_logic;
        sdram_wire_cke  : out    vl_logic;
        sdram_wire_cs_n : out    vl_logic;
        sdram_wire_dq   : inout  vl_logic_vector(31 downto 0);
        sdram_wire_dqm  : out    vl_logic_vector(3 downto 0);
        sdram_wire_ras_n: out    vl_logic;
        sdram_wire_we_n : out    vl_logic;
        usb_DATA        : inout  vl_logic_vector(15 downto 0);
        usb_ADDR        : out    vl_logic_vector(1 downto 0);
        usb_RD_N        : out    vl_logic;
        usb_WR_N        : out    vl_logic;
        usb_CS_N        : out    vl_logic;
        usb_RST_N       : out    vl_logic;
        usb_INT         : in     vl_logic;
        usb_out_clk_clk : out    vl_logic
    );
end finalproject;
