# FPGA & Digital Systems Design Lab Collection

[![Language: Verilog](https://img.shields.io/badge/Language-Verilog%20%2F%20SystemVerilog-blue.svg)](https://en.wikipedia.org/wiki/Verilog)
[![Toolchain: EDA/FPGA](https://img.shields.io/badge/Tools-Questasim%20%7C%20Vivado-orange.svg)]()
[![Status: Complete](https://img.shields.io/badge/Status-Labs%20Completed-brightgreen.svg)]()

This repository contains a comprehensive suite of hardware design modules, Finite State Machines (FSMs), memory systems, processor components, and self-checking testbenches implemented in Verilog and SystemVerilog.

---

## 📌 Repository Overview

The modules in this repository represent key architectural building blocks of digital logic and computer systems, categorized into five core domains:

1. **CPU & Processing Unit Building Blocks** (ALU, Controller/FSM, Registers, Drivers)
2. **Memory Architectures & Interfaces** (RAM with Tri-State Busses)
3. **Finite State Machines & Edge Detectors** (Moore & Mealy State Machines, Sequence Detectors)
4. **Data Stream Controllers & Signal Conditioners** (Parity Generators, Switch Debouncers)
5. **Sequential Modeling Approaches** (Behavioral, Structural, Gate-Level)

---

## 🛠️ Lab & Module Breakdown

### 1. CPU & Central Processing Components
* **`alu.v` & `alu_test.v`**: Parameterized 8-bit Arithmetic Logic Unit supporting addition, bitwise AND/XOR, and zero-detection (`a_is_zero`).
* **`controller.v` & `controller_test.v`**: Control unit FSM executing 8 instructions (`HLT`, `SKZ`, `ADD`, `AND`, `XOR`, `LDA`, `STO`, `JMP`) across multi-phase microcode timing steps.
* **`register.v` & `register_test.v`**: Parameterized data register featuring synchronous load, clocking, and asynchronous active-high reset.
* **`driver.v` & `driver_test.v`**: Active-high enabled tri-state bus driver for shared data line management.
* **`multiplexor_test.v`**: Parameterized 2-to-1 data multiplexer verification suite.

### 2. Memory Architectures
* **`memory.sv`**: Parameterized RAM module (default 32x8) featuring a bi-directional `inout` data bus and tri-state output control.
* **`memory_test_edit.v`, `memory_test_taskedit.v` & `memory_test.v`**: Self-checking testbenches validating memory writes and reads over descending and ascending address ranges.

### 3. State Machines & Edge Detection
* **`seq_det_non` & `seq_det_over` (`seq_det.v`)**: Sequence detectors identifying fixed bit patterns (`110101`) in both non-overlapping and overlapping modes.
* **`rising_edge_moore.v` & `rising_edge_mealy.v`**: Edge detector circuits comparing Moore output (state-dependent) vs. Mealy output (input-dependent asynchronous response).
* **`rising_edge_test.v`**: Testbench providing stimulus and glitch detection for edge detector circuits.
* **`fsm.v`, `fsm_multi.sv`, `fsm_red.sv` & `fsm_test.v`**: Multi-style FSM implementations demonstrating 2-segment and 3-segment coding standards.

### 4. Hardware Signal Conditioning & Stream Processing
* **`debouncer.v` & `debouncer_tb.v`**: Mechanical switch debouncer filtering physical bounce noise using a timing counter before updating clean output state.
* **`stream_parity_gen.v`, `stream_parity_gen_ddd.v` & `parity_test.v`**: Dynamic stream parity generators utilizing shift registers, reduction operators, and Verilog `generate` loops.

### 5. Multi-Style Modeling Techniques
* **Up/Down Counters**:
  * **`counter_Behavioral.v`**: High-level behavioral modeling (`+` / `-`).
  * **`counter_Structural.v`**: Interconnected D Flip-Flops and logic blocks.
  * **`counter_gate_level.v`**: Direct boolean primitive logic representations.
  * **`counter_func.v` & `counter.v`**: Function-driven logic encapsulation and parameterized counter designs.
* **Wildcard & Tristate Operators**:
  * **`casez_example.v`**: Priority encoder logic handling high-impedance (`z`) conditions.
  * **`casex_example.v`**: Priority encoder handling don't-care (`x`/`z`) conditions.
  * **`XZ_test.v`**: Comparative analysis testbench evaluating simulation behavior between `casez` and `casex`.

---

## 📂 File Directory Structure

```text
.
├── alu.v                     # Arithmetic Logic Unit RTL
├── alu_test.v                # ALU self-checking testbench
├── casez_example.v           # Casez wildcard demonstration module
├── casex_example.v           # Casex wildcard demonstration module
├── controller.v              # Microcode CPU Controller FSM
├── controller_test.v         # Controller timing & instruction testbench
├── counter.v                 # Parameterized up-counter
├── counter_Behavioral.v      # Behavioral 2-bit Up/Down counter
├── counter_func.v            # Function-based up-counter
├── counter_gate_level.v      # Gate-level up/down counter
├── counter_Structural.v      # Structural D-FF up/down counter
├── counter_test.v            # Counter verification environment
├── debouncer.v               # Hardware button debouncer circuit
├── debouncer_tb.v            # Debouncer noise injection testbench
├── driver.v                  # Tri-state bus driver module
├── driver_test.v             # Tri-state driver testbench
├── fsm.v                     # 2-segment FSM
├── fsm_multi.sv              # 3-segment SystemVerilog FSM
├── fsm_red.sv                # Reduced logic FSM
├── fsm_test.v                # FSM testbench
├── memory.sv                 # RAM with bidirectional inout bus
├── memory_test.v             # Memory testbench suite
├── multiplexor_test.v        # Mux testbench
├── my_dff.v                  # Basic D Flip-Flop module
├── register.v                # Standard load-enable register
├── register_test.v           # Register testbench
├── rising_edge_mealy.v       # Mealy edge detector FSM
├── rising_edge_moore.v       # Moore edge detector FSM
├── rising_edge_test.v        # Edge detector testbench
├── seq_det.v                 # Overlapping & Non-overlapping sequence detectors
├── stream_parity_gen.v       # Generate loop based stream parity calculator
├── stream_parity_gen_ddd.v   # Shift register based stream parity calculator
├── stream_parity_gen_gernate.v# Parameterized parity generator
├── parity_test.v             # Parity generator testbench
├── top_module.v              # Structural D-FF shift register top
└── XZ_test.v                 # Casez vs Casex simulation comparison
