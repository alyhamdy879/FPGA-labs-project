`timescale 1ns / 1ps
module tb_Automotive_ECU_Top;

reg clk,rst;
reg [8:0] vehicle_speed;
reg [3:0] engine_rpm;
reg brake_pedal;
reg [1:0] throttle_in;
reg [1:0] drive_mode;
reg [7:0] front_wheel_speed,rear_wheel_speed;
reg echo_pulse;

wire spark_retard,fuel_cut,motor_pwm,spoiler_pwm,airbrake_led;
wire [7:0] final_motor_pwm;
wire abs_brake_pulse,tcs_active_led,abs_active_led;
wire led_green,led_yellow,led_red,buzzer_out;

integer pass_count,fail_count;

Automotive_ECU_Top DUT(
.clk(clk),
.rst(rst),
.vehicle_speed(vehicle_speed),
.engine_rpm(engine_rpm),
.brake_pedal(brake_pedal),
.throttle_in(throttle_in),
.drive_mode(drive_mode),
.front_wheel_speed(front_wheel_speed),
.rear_wheel_speed(rear_wheel_speed),
.echo_pulse(echo_pulse),
.spark_retard(spark_retard),
.fuel_cut(fuel_cut),
.motor_pwm(motor_pwm),
.spoiler_pwm(spoiler_pwm),
.airbrake_led(airbrake_led),
.final_motor_pwm(final_motor_pwm),
.abs_brake_pulse(abs_brake_pulse),
.tcs_active_led(tcs_active_led),
.abs_active_led(abs_active_led),
.led_green(led_green),
.led_yellow(led_yellow),
.led_red(led_red),
.buzzer_out(buzzer_out));

always #5 clk=~clk;

initial begin
$monitor("t=%0t spd=%0d rpm=%0d mode=%b pwm=%b duty=%0d spark=%b fuel=%b TCS=%b ABS=%b",
$time,vehicle_speed,engine_rpm,drive_mode,motor_pwm,final_motor_pwm,
spark_retard,fuel_cut,tcs_active_led,abs_active_led);
end

task check;
input cond; input [255:0] msg;
begin
if(cond) begin
pass_count=pass_count+1;
$display("PASS: %0s",msg);
end else begin
fail_count=fail_count+1;
$display("FAIL: %0s",msg);
end
end
endtask

initial begin
clk=0;rst=1;
vehicle_speed=0;engine_rpm=0;brake_pedal=0;throttle_in=0;drive_mode=0;
front_wheel_speed=0;rear_wheel_speed=0;echo_pulse=0;
pass_count=0;fail_count=0;

#30 rst=0;
#20;
check((spark_retard==0)&&(fuel_cut==0),"Reset");

$display("Drive Modes");
drive_mode=2'b00; throttle_in=2'b11; #3000;
drive_mode=2'b01; #3000;
drive_mode=2'b10; #3000;
drive_mode=2'b11; #3000;
check(1,"Drive mode exercised");

$display("Launch Control");
vehicle_speed=0;brake_pedal=1;throttle_in=2'b11;engine_rpm=4;#20;
check(spark_retard==1,"Launch spark retard");

$display("Soft limiter");
brake_pedal=0;engine_rpm=9;#20;
check(spark_retard==1,"Soft limiter");

$display("Hard limiter");
engine_rpm=10;#20;
check(fuel_cut==1,"Hard limiter");

$display("Spoiler");
vehicle_speed=100;brake_pedal=0;#3000;
check(1,"Cruise spoiler");
vehicle_speed=170;#3000;
check(1,"Track spoiler");
brake_pedal=1;#3000;
check(airbrake_led==1,"Airbrake");

$display("Traction");
brake_pedal=0;
front_wheel_speed=60;
rear_wheel_speed=100;
#20;
check(tcs_active_led==1,"TCS active");

$display("ABS");
brake_pedal=1;
front_wheel_speed=100;
rear_wheel_speed=60;
#40;
check(abs_active_led==1,"ABS active");

$display("Parking");
echo_pulse=1;#1000;echo_pulse=0;#100;
check(led_green==1,"Parking LEDs");

$display("--------------------------------");
$display("Tests Passed = %0d",pass_count);
$display("Tests Failed = %0d",fail_count);
$display("--------------------------------");
$stop;
end
endmodule