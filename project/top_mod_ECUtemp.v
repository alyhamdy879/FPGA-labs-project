module top_mod_ECU (
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst_n,  // Asynchronous reset active low
	output reg led_green,
    output reg led_yellow,
    output reg led_red,
    output reg buzzer_out
);


Advanced_Parking_System p1 (
        .clk       (clk),
        .rst       (rst),
        .echo_pulse(echo_pulse),
        .led_green (led_green),
        .led_yellow(led_yellow),
        .led_red   (led_red),
        .buzzer_out(buzzer_out)
    );

endmodule 