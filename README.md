# RISC V CPU

This project implements a single cycle RISC V processor using Verilog HDL. The processor contains a datapath and control unit for instruction execution, along with separate instruction and data memories.

The CPU supports arithmetic, logical, memory access, branch, jump, and immediate instructions. The processor uses a memory controller to distinguish between normal data memory and memory mapped hardware addresses.

The hardware memory interface provides a way for the processor to communicate with external hardware through memory mapped addresses. The project also includes a UART transmitter for sending data from the processor to an external serial interface.

## Architecture

The RISC V CPU fetches instructions from instruction memory and processes them through the controller and datapath. The controller generates the required control signals based on the instruction, while the datapath performs register operations, immediate generation, ALU operations, and program counter updates.

Load and store instructions access memory through the memory controller. The controller maps different address ranges to data memory or hardware memory, allowing the processor to interact with both internal memory and external peripherals.

The hardware memory supports byte, halfword, and word accesses and provides the interface required for memory mapped hardware operations.

UART transmission is included to allow processor generated data to be transmitted serially.

## Main Components

riscv_cpu.v

Top level single cycle RISC V processor that connects the controller and datapath.

data_mem.v

Provides storage for processor data and handles data memory operations.

instr_mem.v

Stores and provides instructions to the processor based on the program counter.

memory_controller.v

Routes memory accesses between data memory and hardware memory based on the address range.

hw_memory.v

Implements memory mapped hardware storage with support for byte, halfword, and word accesses.

uart_tx.v

Implements UART transmission for sending processor data over a serial interface.

components

Contains the processor datapath and control logic used by the main RISC V CPU.

## Memory Mapping

The processor uses separate address ranges for data memory and hardware memory.

Data memory is mapped from 0x00001000 to 0x00001FFF.

Hardware memory is mapped from 0x20000000 to 0x20000FFF.

The memory controller uses these address ranges to determine where a load or store operation should be directed.

## Implementation

The processor is implemented entirely in Verilog HDL and is designed around a single cycle execution model. Each instruction passes through instruction fetch, decode, execution, memory access, and write back within a single clock cycle.

The design can be simulated to verify instruction execution, memory operations, branching, and hardware communication.

## Technologies

Verilog HDL

RISC V ISA

Digital logic design


UART communication
