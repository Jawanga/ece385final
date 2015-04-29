library verilog;
use verilog.vl_types.all;
entity usb_system_mm_interconnect_1 is
    port(
        clocks_c1_clk   : in     vl_logic;
        clock_crossing_io_m0_reset_reset_bridge_in_reset_reset: in     vl_logic;
        clock_crossing_io_m0_address: in     vl_logic_vector(21 downto 0);
        clock_crossing_io_m0_waitrequest: out    vl_logic;
        clock_crossing_io_m0_burstcount: in     vl_logic_vector(0 downto 0);
        clock_crossing_io_m0_byteenable: in     vl_logic_vector(3 downto 0);
        clock_crossing_io_m0_read: in     vl_logic;
        clock_crossing_io_m0_readdata: out    vl_logic_vector(31 downto 0);
        clock_crossing_io_m0_readdatavalid: out    vl_logic;
        clock_crossing_io_m0_write: in     vl_logic;
        clock_crossing_io_m0_writedata: in     vl_logic_vector(31 downto 0);
        clock_crossing_io_m0_debugaccess: in     vl_logic;
        CY7C67200_IF_0_hpi_address: out    vl_logic_vector(1 downto 0);
        CY7C67200_IF_0_hpi_write: out    vl_logic;
        CY7C67200_IF_0_hpi_read: out    vl_logic;
        CY7C67200_IF_0_hpi_readdata: in     vl_logic_vector(31 downto 0);
        CY7C67200_IF_0_hpi_writedata: out    vl_logic_vector(31 downto 0);
        CY7C67200_IF_0_hpi_chipselect: out    vl_logic
    );
end usb_system_mm_interconnect_1;
