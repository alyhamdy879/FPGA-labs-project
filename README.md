# FPGA & Digital Systems Design Lab Collection

[![Language: Verilog](https://img.shields.io/badge/Language-Verilog%20%2F%20SystemVerilog-blue.svg)](https://en.wikipedia.org/wiki/Verilog)
[![Toolchain: EDA/FPGA](https://img.shields.io/badge/Tools-Questasim%20%7C%20Vivado-orange.svg)]()
[![Status: Complete](https://img.shields.io/badge/Status-Labs%20Completed-brightgreen.svg)]()

This repository contains the complete collection of RTL models, Finite State Machines (FSMs), memory architectures, and testbenches developed throughout the FPGA Course. The labs are organized chronologically by module complexity and topic domain.

---

## 📅 Lab Modules by Date & Sequence

### 🧪 Lab 1: Basic Combinational & Sequential Elements
*Focus: Fundamental flip-flops, tristate buffers, and parameterized registers.*
* **`my_dff.v` & `top_module.v`**: Basic D Flip-Flop instantiation and structural cascade[cite: 3].
* **`driver.v` & `driver_test.v`**: Parameterized tri-state bus driver with output enable control (`data_en`)[cite: 1, 8].
* **`register.v` & `register_test.v`**: Synchronous load register with asynchronous active-high reset[cite: 2, 6].
* **`multiplexor_test.v`**: Verification testbench for parameterized 2-to-1 data multiplexers[cite: 7].

---

### 🧪 Lab 2: Arithmetic Units & Wildcard Comparisons
*Focus: Arithmetic logic design and simulation behaviors of Verilog wildcard matching.*
* **`alu.v` & `alu_test.v`**: Parameterized 8-bit Arithmetic Logic Unit (ADD, AND, XOR, Pass-Through, and `a_is_zero` flag)[cite: 9, 10].
* **`casez_example.v`**: Priority encoder modeling using `casez` (high-impedance `z` wildcards)[cite: 17].
* **`casex_example.v`**: Priority encoder modeling using `casex` (`x`/`z` wildcards)[cite: 20].
* **`XZ_test.v`**: Testbench demonstrating hardware synthesis risks and simulation differences between `casex` and `casez`[cite: 18].

---

### 🧪 Lab 3: Memory Subsystems & Bus Operations
*Focus: RAM design, bidirectional tri-state buses, and self-checking testbenches.*
* **`memory.sv`**: Parameterized RAM module (default 32x8) with a bidirectional `inout data` bus driven by `rd`/`wr` signals[cite: 12].
* **`memory_test.v` / `memory_test_edit.v` / `memory_test_taskedit.v`**: Automated testbenches validating memory write and read tasks across ascending and descending address spaces[cite: 13, 14, 31].

---

### 🧪 Lab 4: Multi-Style Counter Design & Functional Encapsulation
*Focus: Structural vs. Behavioral vs. Gate-Level modeling paradigms.*
* **`counter.v` & `counter_test.v`**: Parameterized up-counter with synchronous load and enable controls[cite: 16, 19].
* **`counter_func.v`**: Up-counter utilizing Verilog `function` encapsulation for next-state logic[cite: 15].
* **`counter_Behavioral.v`**: High-level behavioral modeling of a 2-bit Up/Down counter[cite: 23].
* **`counter_Structural.v`**: Structural 2-bit Up/Down counter using instantiated D-FFs and next-state equations[cite: 26].
* **`counter_gate_level.v`**: Boolean logic gate-level representation of a 2-bit Up/Down counter[cite: 27].

---

### 🧪 Lab 5: Finite State Machines & Microcode Controllers
*Focus: Multi-phase instruction decoders, Moore vs. Mealy machines, and segment coding styles.*
* **`controller.v` & `controller_test.v`**: CPU Control Unit FSM decoding 8 instructions (`HLT`, `SKZ`, `ADD`, `AND`, `XOR`, `LDA`, `STO`, `JMP`) over 8 phase steps[cite: 4, 5].
* **`fsm.v`, `fsm_multi.sv` & `fsm_red.sv`**: FSM implementations comparing 2-segment vs. 3-segment SystemVerilog architectures[cite: 24, 28, 29].
* **`fsm_test.v`**: Verification environment for multi-segment FSM logic[cite: 25].
* **`rising_edge_moore.v`**: Single-cycle tick edge detector implemented using Moore state logic[cite: 21].
* **`rising_edge_mealy.v`**: Edge detector implemented using Mealy state logic[cite: 22].
* **`rising_edge_test.v`**: Testbench comparing Moore vs. Mealy response timing and glitch behavior[cite: 35].

---

### 🧪 Lab 6: Sequence Detection & Pattern Recognition
*Focus: FSM pattern matching algorithms.*
* **`seq_det.v` (`seq_det_non` & `seq_det_over`)**: Sequence detectors identifying the bit pattern `110101` in non-overlapping and overlapping modes[cite: 32].

---

### 🧪 Lab 7: Digital Signal Processing & Hardware Interfaces
*Focus: Mechanical switch debouncing, streaming parity, and generate loops.*
* **`debouncer.v` & `debouncer_tb.v`**: Mechanical button debouncer filtering input contact bounce using an internal tick counter[cite: 33, 34].
* **`stream_parity_gen.v` / `stream_parity_gen_ddd.v`**: Streaming serial-in parity generators using reduction XOR functions[cite: 11, 30].
* **`stream_parity_gen_gernate.v`**: Parameterized parity generator constructed via Verilog `generate` loops[cite: 30].
* **`parity_test.v`**: Comprehensive automated testbench validating parity output across 255 data values[cite: 36].

---

## 📂 Repository Directory Structure

```text
.
├── alu.v                       # Lab 2: Arithmetic Logic Unit
├── alu_test.v                  # Lab 2: ALU Testbench
├── casez_example.v             # Lab 2: Casez Wildcard Encoder
├── casex_example.v             # Lab 2: Casex Wildcard Encoder
├── controller.v                # Lab 5: Microcode CPU Controller
├── controller_test.v           # Lab 5: Controller Phase Testbench
├── counter.v                   # Lab 4: Parameterized Up-Counter
├── counter_Behavioral.v        # Lab 4: Behavioral 2-bit Up/Down Counter
├── counter_func.v              # Lab 4: Function-based Counter
├── counter_gate_level.v        # Lab 4: Gate-Level Up/Down Counter
├── counter_Structural.v        # Lab 4: Structural D-FF Up/Down Counter
├── counter_test.v              # Lab 4: Counter Testbench
├── debouncer.v                 # Lab 7: Hardware Debouncer Circuit
├── debouncer_tb.v              # Lab 7: Debouncer Noise Testbench
├── driver.v                    # Lab 1: Tri-State Bus Driver
├── driver_test.v               # Lab 1: Bus Driver Testbench
├── fsm.v                       # Lab 5: 2-Segment FSM
├── fsm_multi.sv                # Lab 5: 3-Segment SystemVerilog FSM
├── fsm_red.sv                  # Lab 5: Reduced FSM
├── fsm_test.v                  # Lab 5: FSM Testbench
├── memory.sv                   # Lab 3: RAM with Bidirectional Inout Bus
├── memory_test.v               # Lab 3: Memory Verification Testbench
├── multiplexor_test.v          # Lab 1: Mux Testbench
├── my_dff.v                    # Lab 1: D Flip-Flop Component
├── register.v                  # Lab 1: Load Register
├── register_test.v             # Lab 1: Register Testbench
├── rising_edge_mealy.v         # Lab 5: Mealy Edge Detector
├── rising_edge_moore.v         # Lab 5: Moore Edge Detector
├── rising_edge_test.v          # Lab 5: Edge Detector Comparative Testbench
├── seq_det.v                   # Lab 6: Overlapping & Non-Overlapping Sequence Detectors
├── stream_parity_gen.v         # Lab 7: Serial Stream Parity Generator
├── stream_parity_gen_ddd.v     # Lab 7: Shift-Register Parity Generator
├── stream_parity_gen_gernate.v # Lab 7: Generate Loop Parity Generator
├── parity_test.v               # Lab 7: Parity Testbench
├── top_module.v                # Lab 1: Structural D-FF Shift Register
└── XZ_test.v                   # Lab 2: Casez vs Casex Simulation Testbench
├── stream_parity_gen_gernate.v# Parameterized parity generator
├── parity_test.v             # Parity generator testbench
├── top_module.v              # Structural D-FF shift register top
└── XZ_test.v                 # Casez vs Casex simulation comparison
