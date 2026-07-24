module Vehicle_Control_Unit_Top (
   input wire clk,
    input wire rst,

    // Shared Vehicle Sensors
    input wire [8:0] vehicle_speed,
    input wire [3:0] engine_rpm,
    input wire brake_pedal,
    input wire [1:0] throttle_in,

    // Drive Mode & Traction Sensors
    input wire [1:0] drive_mode,
    input wire [7:0] front_wheel_speed,
    input wire [7:0] rear_wheel_speed,

    // Parking System Sensors
    input wire echo_pulse,

    // 1. RPM Limiter Outputs
    output wire spark_retard,
    output wire fuel_cut,
    
    // 2. Drive Mode Outputs
    output wire motor_pwm,
    
    // 3. Active Spoiler Outputs
    output wire spoiler_pwm,
    output wire airbrake_led,
    
    // 4. Traction & ABS Outputs
    output wire [7:0] final_motor_pwm,
    output wire abs_brake_pulse,
    output wire tcs_active_led,
    output wire abs_active_led,
    
    // 5. Parking System Outputs
    output wire led_green,
    output wire led_yellow,
    output wire led_red,
    output wire buzzer_out
);

    
    wire [7:0] cr_motor_pwm;

 
    // 1. Advanced Parking Subsystem
    Advanced_Parking_System u_parking (
        .clk(clk),
        .rst(rst),
        .echo_pulse(echo_pulse),
        .led_green(led_green),
        .led_yellow(led_yellow),
        .led_red(led_red),
        .buzzer_out(buzzer_out)
    );

    // 2. Drive Mode Controller Subsystem
    Drive_Mode_Controller u_drive_mode (
        .clk(clk),
        .rst(rst),
        .throttle_in(throttle_in),
        .drive_mode(drive_mode),
        .motor_pwm(motor_pwm)
    );

    // 3. Active Spoiler & Airbrake Subsystem
    Active_Spoiler_System u_spoiler (
        .clk(clk),
        .rst(rst),
        .vehicle_speed(vehicle_speed),
        .brake_pedal(brake_pedal),
        .spoiler_pwm(spoiler_pwm),
        .airbrake_led(airbrake_led)
    );

    
    // 4. Smart RPM Limiter & Launch Control Subsystem
    
    Smart_RPM_Limiter u_rpm_limiter (
        .clk(clk),
        .rst(rst),
        .engine_rpm(engine_rpm),
        .vehicle_speed(vehicle_speed),
        .brake_pedal(brake_pedal),
        .throttle_in(throttle_in),
        .spark_retard(spark_retard),
        .fuel_cut(fuel_cut)
    );

    
    // 5. Traction Control & ABS Safety Subsystem
   
    Traction_ABS_System u_traction_abs (
        .clk(clk),
        .rst(rst),
        .front_wheel_speed(front_wheel_speed),
        .rear_wheel_speed(rear_wheel_speed),
        .brake_pedal(brake_pedal),
        .ecu_motor_pwm_in(internal_motor_pwm_8bit),
        .final_motor_pwm(final_motor_pwm),
        .abs_brake_pulse(abs_brake_pulse),
        .tcs_active_led(tcs_active_led),
        .abs_active_led(abs_active_led)
    );

endmodule


// SUBMODULE 1: Advanced Parking System
module Advanced_Parking_System (
    input wire clk,
    input wire rst, 
    input wire echo_pulse, 
    output reg led_green,
    output reg led_yellow,
    output reg led_red,
    output reg buzzer_out   
);

    localparam ZONE_MID    = 16'd10000;
    localparam ZONE_CLOSE  = 16'd5000;
    localparam ZONE_DANGER = 16'd2000;

    reg [15:0] pulse_arr_time;
    reg [1:0]  distance_zone;  
    reg [15:0] tone_timer;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pulse_arr_time <= 0;
            distance_zone  <= 0;
        end 
        else begin
            if (echo_pulse) begin 
                if (pulse_arr_time < 16'hFFFF) begin 
                    pulse_arr_time <= pulse_arr_time + 1;
                end
            end
            else if (pulse_arr_time > 0) begin 
                if      (pulse_arr_time < ZONE_DANGER) distance_zone <= 3;
                else if (pulse_arr_time < ZONE_CLOSE)  distance_zone <= 2;
                else if (pulse_arr_time < ZONE_MID)    distance_zone <= 1;
                else                                   distance_zone <= 0;
                
                pulse_arr_time <= 0;
            end
        end
    end

    always @(*) begin
        led_green  = (distance_zone >= 1);
        led_yellow = (distance_zone >= 2);
        led_red    = (distance_zone == 3);
    end

    always @(posedge clk or posedge rst) begin  
        if (rst || distance_zone == 0) begin
            tone_timer <= 0;
            buzzer_out <= 0;
        end 
        else begin
            tone_timer <= tone_timer + 1;
            case (distance_zone)
                1: begin 
                    if (tone_timer >= 500) begin 
                        tone_timer <= 0;
                        buzzer_out <= ~buzzer_out;
                    end
                end
                2: begin 
                    if (tone_timer >= 100) begin 
                        tone_timer <= 0;
                        buzzer_out <= ~buzzer_out;
                    end
                end
                3: begin 
                    if (tone_timer >= 30) begin 
                        tone_timer <= 0;
                        buzzer_out <= ~buzzer_out;
                    end 
                end
            endcase
        end
    end

endmodule


// SUBMODULE 2: Drive Mode Controller
module Drive_Mode_Controller (
    input wire clk,
    input wire rst,
    input wire [1:0] throttle_in,
    input wire [1:0] drive_mode,
    output reg [7:0] current_duty,
);

    reg [7:0] target_duty;
    
    reg [15:0] smooth_timer;

    always @(*) begin
        case (drive_mode)
            2'b01: begin // Normal 1:1
                case (throttle_in)
                    2'b00: target_duty = 8'd0;
                    2'b01: target_duty = 8'd64;
                    2'b10: target_duty = 8'd128;
                    2'b11: target_duty = 8'd255;
                endcase
            end
            
            2'b00: begin // Eco 1:2
                case (throttle_in)
                    2'b00: target_duty = 8'd0;
                    2'b01: target_duty = 8'd32;
                    2'b10: target_duty = 8'd64;
                    2'b11: target_duty = 8'd128;
                endcase
            end
            
            2'b10: begin // Sport 
                case (throttle_in)
                    2'b00: target_duty = 8'd0;
                    2'b01: target_duty = 8'd128;
                    2'b10: target_duty = 8'd192;
                    2'b11: target_duty = 8'd255;
                endcase
            end
            
            2'b11: begin // Track
                case (throttle_in)
                    2'b00: target_duty = 8'd0;
                    2'b01: target_duty = 8'd192;
                    2'b10: target_duty = 8'd255;
                    2'b11: target_duty = 8'd255;
                endcase
            end
            
            default: target_duty = 8'd0; 
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_duty <= 8'd0;
            smooth_timer <= 0;
        end 
        else begin
            if (smooth_timer >= 50) begin 
                smooth_timer <= 0;
                if (current_duty < target_duty)
                    current_duty <= current_duty + 1;
                else if (current_duty > target_duty)
                    current_duty <= current_duty - 1;
            end
            else begin
                smooth_timer <= smooth_timer + 1;
            end
        end
    end

    

endmodule


// SUBMODULE 3: Active Spoiler System
module Active_Spoiler_System (
    input wire clk,
    input wire rst,
    input wire [8:0] vehicle_speed,
    input wire brake_pedal,
    output reg spoiler_pwm,
    output reg airbrake_led
);

    localparam SPEED_CITY    = 9'd80;
    localparam SPEED_HIGHWAY = 9'd150;

    localparam ANGLE_CLOSED   = 8'd0;
    localparam ANGLE_CRUISE   = 8'd64;
    localparam ANGLE_TRACK    = 8'd128;
    localparam ANGLE_AIRBRAKE = 8'd255;

    reg [7:0] target_angle;
    reg [7:0] current_angle;
    reg [15:0] spoiler_timer;
    reg [7:0]  pwm_counter;

    always @(*) begin
        airbrake_led = 1'b0;
        
        if (brake_pedal == 1'b1 && vehicle_speed > SPEED_CITY) begin
            target_angle = ANGLE_AIRBRAKE;
            airbrake_led = 1'b1;
        end 
        else if (vehicle_speed > SPEED_HIGHWAY) begin
            target_angle = ANGLE_TRACK;
        end 
        else if (vehicle_speed > SPEED_CITY) begin
            target_angle = ANGLE_CRUISE;
        end 
        else begin
            target_angle = ANGLE_CLOSED;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_angle <= ANGLE_CLOSED;
            spoiler_timer <= 0;
        end 
        else begin
            if (spoiler_timer >= 40) begin 
                spoiler_timer <= 0;
                
                if (current_angle < target_angle)
                    current_angle <= current_angle + 1;
                else if (current_angle > target_angle)
                    current_angle <= current_angle - 1;
            end
            else begin
                spoiler_timer <= spoiler_timer + 1;
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pwm_counter <= 8'd0;
            spoiler_pwm <= 1'b0;
        end else begin
            pwm_counter <= pwm_counter + 1;
            if (pwm_counter < current_angle)
                spoiler_pwm <= 1'b1;
            else
                spoiler_pwm <= 1'b0;
        end
    end

endmodule


// SUBMODULE 4: Smart RPM Limiter
module Smart_RPM_Limiter (
    input wire clk,
    input wire rst,
    input wire [3:0] engine_rpm,
    input wire [8:0] vehicle_speed,
    input wire brake_pedal,
    input wire [1:0] throttle_in,
    output reg spark_retard,
    output reg fuel_cut
);

    localparam RPM_LAUNCH   = 4'd4;   // 4000 rpm
    localparam RPM_SOFT_MAX = 4'd9;   // 9000 rpm
    localparam RPM_HARD_MAX = 4'd10;  // 10000 rpm

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            spark_retard <= 1'b0; 
            fuel_cut     <= 1'b0;
        end 
        else begin
            if (vehicle_speed == 9'd0 && brake_pedal == 1'b1 && throttle_in == 2'b11) begin
                if (engine_rpm >= RPM_LAUNCH) begin 
                    spark_retard <= 1'b1;
                    fuel_cut     <= 1'b0;
                end 
                else begin
                    spark_retard <= 1'b0;
                    fuel_cut     <= 1'b0;
                end
            end
            else begin
                if (engine_rpm >= RPM_HARD_MAX) begin
                    fuel_cut     <= 1'b1;
                    spark_retard <= 1'b0;
                end 
                else if (engine_rpm >= RPM_SOFT_MAX) begin
                    fuel_cut     <= 1'b0;
                    spark_retard <= 1 me1;
                end 
                else begin
                    fuel_cut     <= 1'b0;
                    spark_retard <= 1'b0;
                end
            end
        end
    end

endmodule


// SUBMODULE 5: Traction Control & ABS System
module Traction_ABS_System (
    input wire clk,
    input wire rst,
    input wire [7:0] front_wheel_speed,
    input wire [7:0] rear_wheel_speed,
    input wire brake_pedal,
    input wire [7:0] ecu_motor_pwm_in,
    
    output reg motor_pwm,
    output reg abs_brake_pulse,
    output reg tcs_active_led,
    output reg abs_active_led
);

    localparam MAX_SLIP = 8'd15;

    reg [7:0] final_motor_pwm;
    reg [7:0] pwm_counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            final_motor_pwm <= 8'd0;
            abs_brake_pulse <= 1'b0;
            tcs_active_led  <= 1'b0;
            abs_active_led  <= 1'b0;
        end else begin
            if (brake_pedal == 1'b1) begin // ABS Mode
                final_motor_pwm <= 8'd0;
                tcs_active_led  <= 1'b0;

                if (front_wheel_speed > rear_wheel_speed && (front_wheel_speed - rear_wheel_speed) > MAX_SLIP) begin
                    abs_brake_pulse <= ~abs_brake_pulse;
                    abs_active_led  <= 1'b1;
                end else begin
                    abs_brake_pulse <= 1'b1;
                    abs_active_led  <= 1'b0;
                end
            end
            else begin // Traction Control Mode
                abs_brake_pulse <= 1'b0;
                abs_active_led  <= 1'b0;

                if (rear_wheel_speed > front_wheel_speed && (rear_wheel_speed - front_wheel_speed) > MAX_SLIP) begin
                    final_motor_pwm <= (ecu_motor_pwm_in >> 1); // 50% power cut on slip
                    tcs_active_led  <= 1'b1;
                end else begin
                    final_motor_pwm <= ecu_motor_pwm_in;
                    tcs_active_led  <= 1'b0;
                end
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pwm_counter <= 8'd0;
            motor_pwm   <= 1'b0;
        end 
        else begin
            pwm_counter <= pwm_counter + 1;
            if (pwm_counter < final_motor_pwm) 
                motor_pwm <= 1'b1;
            else
                motor_pwm <= 1'b0;
        end
    end


endmodule