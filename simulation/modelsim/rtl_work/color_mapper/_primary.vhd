library verilog;
use verilog.vl_types.all;
entity color_mapper is
    port(
        BallX           : in     vl_logic;
        BallY           : in     vl_logic;
        Ball_size       : in     vl_logic;
        BlockX          : in     vl_logic;
        BlockY          : in     vl_logic;
        Block_size      : in     vl_logic;
        DrawX           : in     vl_logic_vector(9 downto 0);
        DrawY           : in     vl_logic_vector(9 downto 0);
        block_ready     : in     vl_logic_vector(2 downto 0);
        Red             : out    vl_logic_vector(7 downto 0);
        Green           : out    vl_logic_vector(7 downto 0);
        Blue            : out    vl_logic_vector(7 downto 0)
    );
end color_mapper;
