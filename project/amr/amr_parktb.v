module tb_Advanced_Parking;

    // --- Inputs to DUT ---
    reg clk;
    reg rst;
    reg echo_pulse;

    // --- Outputs from DUT ---
    wire led_green;
    wire led_yellow;
    wire led_red;
    wire buzzer_out;

    // --- Clock Generation (100 MHz clock -> 10ns period) ---
    always #5 clk = ~clk;

    // --- Instantiate DUT ---
    Advanced_Parking uut (
        .clk(clk),
        .rst(rst),
        .echo_pulse(echo_pulse),
        .led_green(led_green),
        .led_yellow(led_yellow),
        .led_red(led_red),
        .buzzer_out(buzzer_out)
    );

    // --- Task to simulate an ultrasonic echo pulse ---
    task send_echo;
        input integer cycles;
        begin
            $display("[Time %0t ns] Sending echo pulse of length %0d clock cycles...", $time, cycles);
            echo_pulse = 1;
            repeat (cycles) @(posedge clk);
            echo_pulse = 0;
            // Wait one extra cycle to allow falling edge detection & zone evaluation
            @(posedge clk); 
        end
    endtask

    // --- Test Sequence ---
    initial begin
        // Initialize Signals
        clk = 0;
        rst = 1;
        echo_pulse = 0;

        // Apply Reset
        #20;
        rst = 0;
        @(posedge clk);
        $display("\n--- Reset Deasserted ---");

        // -------------------------------------------------------------
        // TEST 1: Far Zone (> 10000 cycles -> distance_zone = 0)
        // All LEDs should remain OFF, Buzzer OFF.
        // -------------------------------------------------------------
        send_echo(12000);
        repeat(50) @(posedge clk);
        $display("Zone 0 (Far): Green=%b, Yellow=%b, Red=%b, Buzzer=%b", 
                  led_green, led_yellow, led_red, buzzer_out);

        // -------------------------------------------------------------
        // TEST 2: Mid Zone (5000 to 9999 cycles -> distance_zone = 1)
        // Green LED should turn ON, slow buzzer toggle.
        // -------------------------------------------------------------
        send_echo(7500);
        repeat(3500) @(posedge clk); // Observe buzzer toggles (~1500 cycles)
        $display("Zone 1 (Mid): Green=%b, Yellow=%b, Red=%b", 
                  led_green, led_yellow, led_red);

        // -------------------------------------------------------------
        // TEST 3: Close Zone (2000 to 4999 cycles -> distance_zone = 2)
        // Yellow LED should turn ON, medium buzzer toggle.
        // -------------------------------------------------------------
        send_echo(3500);
        repeat(2500) @(posedge clk); // Observe buzzer toggles (~1000 cycles)
        $display("Zone 2 (Close): Green=%b, Yellow=%b, Red=%b", 
                  led_green, led_yellow, led_red);

        // -------------------------------------------------------------
        // TEST 4: Danger Zone (< 2000 cycles -> distance_zone = 3)
        // Red LED should turn ON, fast buzzer toggle.
        // -------------------------------------------------------------
        send_echo(1000);
        repeat(1500) @(posedge clk); // Observe buzzer toggles (~500 cycles)
        $display("Zone 3 (Danger): Green=%b, Yellow=%b, Red=%b", 
                  led_green, led_yellow, led_red);

        // -------------------------------------------------------------
        // TEST 5: Reset Mid-Operation
        // -------------------------------------------------------------
        $display("\nApplying Reset...");
        rst = 1;
        #20;
        rst = 0;
        @(posedge clk);
        $display("Post-Reset: Green=%b, Yellow=%b, Red=%b, Buzzer=%b", 
                  led_green, led_yellow, led_red, buzzer_out);

        $display("\n--- Simulation Completed Successfully ---");
        $finish;
    end

endmodule