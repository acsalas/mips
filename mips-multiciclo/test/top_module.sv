module top_module(
    input clk, rst, debug,
    input [9:0] switches,
    input [3:0] buttons,
    output [9:0] leds,
    output [6:0] disp0,
    output [6:0] disp1,
    output [6:0] disp2,
    output [6:0] disp3,
    output [6:0] disp4,
    output [6:0] disp5 
);
wire [31:0] data;
bcd2seven D0(.bcd(data[3:0]),.segs(disp0));
bcd2seven D1(.bcd(data[7:4]),.segs(disp1));
bcd2seven D2(.bcd(data[11:8]),.segs(disp2));
bcd2seven D3(.bcd(data[15:12]),.segs(disp3));
bcd2seven D4(.bcd(data[21:18]),.segs(disp4));
bcd2seven D5(.bcd(data[25:22]),.segs(disp5));

MIPS DUT(.clk(buttons[0]),.rst(~buttons[1]), .debug(switches[9]),
        .sw_addr(switches[9:0]), .debug_inst(switches[8:0]), .state(leds), .pc(), .data(data));

  endmodule 