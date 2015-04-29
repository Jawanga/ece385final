library verilog;
use verilog.vl_types.all;
entity usb_system_cpu_nios2_oci_fifo_cnt_inc is
    port(
        empty           : in     vl_logic;
        ge2_free        : in     vl_logic;
        ge3_free        : in     vl_logic;
        input_tm_cnt    : in     vl_logic_vector(1 downto 0);
        fifo_cnt_inc    : out    vl_logic_vector(4 downto 0)
    );
end usb_system_cpu_nios2_oci_fifo_cnt_inc;
