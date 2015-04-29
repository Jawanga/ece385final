library verilog;
use verilog.vl_types.all;
entity altera_irq_clock_crosser is
    generic(
        IRQ_WIDTH       : integer := 31;
        SYNCHRONIZER_DEPTH: integer := 3
    );
    port(
        receiver_clk    : in     vl_logic;
        receiver_reset  : in     vl_logic;
        sender_clk      : in     vl_logic;
        sender_reset    : in     vl_logic;
        receiver_irq    : in     vl_logic_vector;
        sender_irq      : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IRQ_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SYNCHRONIZER_DEPTH : constant is 1;
end altera_irq_clock_crosser;
