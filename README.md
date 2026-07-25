# FPGA & Digital Systems Design Lab Collection

[![Language: Verilog](https://img.shields.io/badge/Language-Verilog%20%2F%20SystemVerilog-blue.svg)](https://en.wikipedia.org/wiki/Verilog)
[![Toolchain: EDA/FPGA](https://img.shields.io/badge/Tools-Questasim%20%7C%20Vivado-orange.svg)]()
[![Status: Complete](https://img.shields.io/badge/Status-Labs%20Completed-brightgreen.svg)]()

This repository contains the complete collection of RTL models, Finite State Machines (FSMs), memory architectures, and testbenches developed throughout the FPGA Course. The labs are organized chronologically 

---

## 📅 Lab Modules by Date & Sequence & Daily Module Progression

### 🗓️ July 09, 2026 (lab 4)
* **`piso.v`**: Parallel-In Serial-Out shift register.
* **`shift_sipo+alu.v`**: Integrated serial shift register feeding arithmetic logic module.
* **`shift_sipo.v`**: Serial-In Parallel-Out shift register module.
* **`lab 4 (ram+piso+sipo+alu).sv`**: Combined sub-system integration incorporating RAM, shift registers, and ALU.
---

### 🗓️ July 11, 2026
* **`alu.v`**: Parameterized 8-bit Arithmetic Logic Unit with zero flag detection.
* **`alu_test.v`**: Testbench verifying arithmetic and bitwise logic operations.
* **`driver.v`**: Bus driver with tri-state output control (`data_en`).
* **`driver_test.v`**: Testbench for the tri-state bus driver.
* **`multiplexor_test.v`**: 2-to-1 data multiplexer.
* **`multiplexor_test.v`**: Verification suite for 2-to-1 data multiplexer.
---

### 🗓️ July 12, 2026
* **`controller.v`**: CPU controller FSM decoding 8 instruction phases.
* **`module shift.v`**: Structural D flip-flop cascade module.
* **`register_test.v`**: Testbench verifying synchronous register loading and resetting.
* **`controller_test.v`**: Microcode instruction CPU controller testbench.

---

### 🗓️ July 13, 2026
* **`casez_example.v`**: Priority encoder using `casez` high-impedance wildcard logic.
* **`register.v`**: Parameterized synchronous load register with asynchronous reset.
* **`casex_example.v`**: Priority encoder using `casex` wildcard states.
* **`XZ_test.v`**: Testbench comparing simulation differences between `casex` and `casez`.
---

### 🗓️ July 14, 2026
* **`counter_test.v`**: Up-counter testbench verifying load/enable sequence logic.
* **`counter.v`**: Parameterized up-counter with load and enable inputs.
* **`counter_func.v`**: Up-counter encapsulating next-state evaluation inside Verilog functions.
* **`memory_test_edit.v`**: Updated self-checking memory testbench.
* **`memory.sv`**: Parameterized RAM with bidirectional `inout` data bus.
* **`memory_test.v`**: Master verification environment for memory subsystems.
---

### 🗓️ July 15, 2026
* **`memory_test_taskedit.v`**: Modular memory testbench utilizing task abstractions.
* **`stream_parity_gen.v`**: Dynamic serial stream parity generator.
* **`stream_parity_gen_gernate.v`**: Parameterized stream parity generator utilizing `generate` loops.

---

### 🗓️ July 16, 2026
* **`fsm.v`**: Standard 2-segment Finite State Machine implementation.
* **`fsm_red.sv`**: Reduced-state SystemVerilog FSM.
* **`fsm_test.v`**: Testbench verifying FSM multi-segment transition outputs.
* **`fsm_multi.sv`**: 3-segment SystemVerilog FSM architecture.

---

### 🗓️ July 19, 2026
* **`counter_gate_level.v`**: Primitive gate-level implementation of 2-bit Up/Down counter.
* **`counter_Structural.v`**: Structural D Flip-Flop instantiation of Up/Down counter.
* **`counter_Behavioral.v`**: Behavioral high-level 2-bit Up/Down counter.
* **`rising_edge_mealy.v`**: Mealy-type rising edge detector FSM.
* **`rising_edge_moore.v`**: Moore-type rising edge detector FSM.
* **`parity_test.v`**: Dynamic verification environment for parity logic across 255 values.
* **`rising_edge_test.v`**: Comparative testbench for Moore vs. Mealy edge detectors.

---

### 🗓️ July 20, 2026
* **`debouncer.v`**: Mechanical switch debouncer using internal tick counters.
* **`debouncer_tb.v`**: Bounce injection testbench verifying debouncer noise rejection.
* **`seq_det.v`**: Overlapping & non-overlapping sequence detectors (`110101`).

---

### 🗓️ July 22, 2026
* **`timing_paths.v` & `timing_paths.xdc`**: Verilog module and Xilinx Design Constraints file for timing analysis.
---

## 🧠 Testbench Architecture & Verification Mindset

Every testbench in this repository was constructed using a structured hardware verification methodology. Below is the architectural thought process behind each testbench:

### 1. Direct Signal Driver & Tri-State Drivers (`driver_test.v`)
* **Thinking Process:** A tri-state bus driver must drive high-impedance (`Z`) when disabled and mirror inputs when enabled. I built an explicit `expect` task to assert high impedance (`8'hZZ`) on `data_en = 0` and verify zero bus contention when enabled.

### 2. Operational Logic & Edge Flags (`alu_test.v`)
* **Thinking Process:** I aimed to test both arithmetic accuracy and status flags simultaneously. The testbench steps through every opcode (`ADD`, `AND`, `XOR`, `PASS`) with edge-case vectors (e.g., `in_a = 0` to explicitly verify that the zero flag `a_is_zero` triggers reliably).

### 3. State & Phase Timing Decoders (`controller_test.v`)
* **Thinking Process:** Microcode execution spans multiple clock phases (`phase 0` to `7`). I designed the testbench to sweep phase states sequentially for each CPU instruction (`HLT`, `SKZ`, `ADD`, `LDA`, etc.), confirming that control bus signals (`sel`, `rd`, `ld_ir`, `wr`, `inc_pc`) match expected bitmasks at exact clock cycles.

### 4. Sequential Memory Elements (`register_test.v` & `counter_test.v`)
* **Thinking Process:** For sequential logic, timing relative to the clock edge is critical. I drove data changes at the negative clock edge (`@(negedge clk)`) to establish stable setup and hold times, ensuring synchronous loading (`load = 1`) and asynchronous override on reset (`rst = 1`).

### 5. Memory Bus & Bidirectional Testing (`memory_test.v`, `memory_test_edit.v`, `memory_test_taskedit.v`)
* **Thinking Process:** RAM verification requires preventing bus collisions on `inout` lines. I modularized the testbench using `write` and `read` tasks:
  * **Write Task:** Drive `rdata` onto the data bus and pulse `wr`.
  * **Read Task:** Release `rdata` to high-impedance (`'bz`), enable `rd`, and sample the data bus against expected memory contents over full ascending/descending memory address sweeps.

### 6. Wildcard Synthesis Risk Analysis (`XZ_test.v`)
* **Thinking Process:** `casex` treats unknown bits (`X`) as don't-cares, which can hide design flaws during simulation. I built a dual-instantiation testbench running the exact same inputs through both `casez_example` and `casex_example` to observe output discrepancies under `X` and `Z` injection.

### 7. Finite State Machine Transitions (`fsm_test.v`)
* **Thinking Process:** FSM verification requires checking valid transitions and illegal state recovery. The testbench systematically cycles inputs `a` and `b` through reset and active states to ensure outputs `y0` and `y1` comply with Moore/Mealy specifications without state locking.

### 8. Async Response & Glitch Immunity (`rising_edge_test.v`)
* **Thinking Process:** Mealy outputs respond asynchronously to input changes, whereas Moore outputs wait for the clock edge. I injected high-frequency glitches (narrow pulses under half a clock period) into `level` to compare glitch propagation in `rising_edge_mealy` versus `rising_edge_moore`.

### 9. Noise Filtering & Real-World Inputs (`debouncer_tb.v`)
* **Thinking Process:** Physical switches bounce back and forth before settling. I simulated contact bounce by toggling `sw` rapidly back and forth between `0` and `1` within a 30ns window. The testbench verifies that `db` remains stable until the input stays steady across the complete counter threshold (`m_tick`).

### 10. Automated Stream & Math Verification (`parity_test.v`)
* **Thinking Process:** Manually typing test vectors for streaming parity is inefficient. I built an automated loop (`all(255)`) that sends numbers 1 through 255 bit-by-bit serially using a helper `sen` task, automatically computing the expected parity via bitwise reduction (`^i`) and matching it against `parity_out`.

### 11. Automotive Subsystem Verification (`tb_Smart_RPM_Limiter.v`, `tb_Active_Spoiler_System.v`, `tb_Traction_ABS_System.v`, `tb_Drive_Mode_Controller.v`, `tb_parking_system.v`)
* **Thinking Process:** Automotive ECUs govern critical physical systems. Testbenches simulate physical vehicle states (e.g., wheel slip ratios, vehicle speeds, engine temperature thresholds, and ultrasonic sensor echo durations) to verify safety cutoffs, actuator outputs, and mode transitions under extreme conditions.

---

## 🏎️ Capstone Project: Advanced Automotive ECU

### Objective
This capstone project applies digital logic to modern vehicle engineering. It integrates four distinct vehicle subsystems into a single, non-blocking FPGA architecture to manage safety, fuel economy, and real-time performance tuning[cite: 57, 65].

### Subsystems Implemented

1. **Active Spoiler System (Aerodynamics)** 🪽
   * Continuously monitors vehicle speed and brake pedal status to adjust the rear spoiler via a generated PWM signal (`spoiler_pwm`)[cite: 54, 57].
   * Transitions between angles: `CLOSED` (Speed < 80), `CRUISE` (Speed > 80), `TRACK` (Speed > 150), and `AIRBRAKE` (Max angle when braking above city speeds)[cite: 54, 57].
   * Includes a sequential smoothing timer to model realistic mechanical actuator deployment without sudden jerks[cite: 54].

2. **Advanced Parking System (Proximity)** 🅿️
   * Analyzes an ultrasonic `echo_pulse` width to determine obstacle distance, categorizing it into predefined thresholds (`ZONE_MID`, `ZONE_CLOSE`, `ZONE_DANGER`)[cite: 55, 57].
   * Drives visual indicators (`led_green`, `led_yellow`, `led_red`) and modulates a `buzzer_out` frequency that toggles faster as the obstacle approaches[cite: 55].

3. **Drive Mode Controller (Performance)** ⚙️
   * Dynamically remaps throttle inputs to an electric motor's PWM duty cycle based on the active mode (`Eco`, `Normal`, `Sport`, `Track`)[cite: 56, 57].
   * Features a hardware rate-limiter (`smooth_timer`) that protects the 200V DC motor from violent current spikes during aggressive throttle changes[cite: 56, 65].

4. **Smart RPM Limiter (Engine Protection)** 🛑
   * Implements real-time hardware comparators against engine RPM thresholds[cite: 58, 65].
   * **Soft Cut (9,000 RPM):** Triggers a `spark_retard` warning signal[cite: 58].
   * **Hard Cut (10,000 RPM):** Immediately drops a `fuel_cut` signal to halt acceleration[cite: 58].
   * **Launch Control:** Detects when the vehicle is stationary (Speed=0), brakes are applied, and throttle is full, holding the RPM precisely at 4,000 via a controlled spark retard[cite: 58].

5. **Traction and ABS System (Safety)** 🛞
   * Compares `front_wheel_speed` and `rear_wheel_speed` to calculate mechanical slip[cite: 57, 63].
   * **ABS (Anti-lock Braking):** If braking is active and slip exceeds `MAX_SLIP` (15), it forces the motor PWM to 0 and rapidly pulses the `abs_brake_pulse` signal[cite: 63].
   * **TCS (Traction Control):** If accelerating and the rear wheels lose grip, it forcefully bit-shifts (`>> 1`) the motor's PWM input, instantly halving engine torque until traction is restored[cite: 63].

### Verification
Every subsystem is paired with an exhaustive Verilog Testbench (`tb_*.v`) injecting realistic edge cases—such as sudden traction loss, varied echo pulse widths, and shifting drive modes under heavy throttle—verified successfully in simulation[cite: 59, 60, 61, 62, 63, 65].

---

## 🚀 Running Simulations

Execute any testbench using **Icarus Verilog** or **ModelSim**:

```bash
# Example 1: Run Automotive Parking System Testbench
iverilog -o parking_sim.out Advanced_Parking_System.v tb_parking_system.v
vvp parking_sim.out

# Example 2: Run Debouncer Testbench and View Waveform
iverilog -o debouncer_sim.out debouncer.v debouncer_tb.v
vvp debouncer_sim.out
gtkwave debouncer_tb.vcd
├── stream_parity_gen_gernate.v# Parameterized parity generator
├── parity_test.v             # Parity generator testbench
├── top_module.v              # Structural D-FF shift register top
└── XZ_test.v                 # Casez vs Casex simulation comparison
