# SPI Core Verification

This repository contains the **verification environment** and **testbench** for the **OpenCores Simple SPI Core**.  
The project focuses on verifying **functional correctness, protocol compliance, and corner cases** of the SPI core using a structured verification plan.

---

## 📖 Overview
- **DUT**: OpenCores Simple SPI Core (Wishbone-compatible, FIFO-based design)
- **Verification Language**: SystemVerilog
- **Verification Approach**: Directed and randomized test cases
- **Focus Areas**:
  - Reset behavior
  - FIFO handling
  - Interrupt logic
  - Wishbone interface compliance
  - SPI protocol correctness (modes, clock division, boundary cases)

---

## ⚙️ Features Verified
1. **Reset Test** – Verify core initializes correctly on reset.  
2. **FIFO Tests** – Validate write FIFO (WFFULL, WCOL) and read FIFO (RFEMPTY, RFFULL).  
3. **SPI Master Transmit Test** – Confirm correct SPI signaling (`sck_o`, `mosi_o`).  
4. **Interrupt Handling** – Check interrupt generation after configurable transfer counts.  
5. **Clock Polarity & Phase** – Validate all four SPI modes (CPOL/CPHA).  
6. **FIFO Overrun & Recovery** – Test handling of overrun and recovery via control register.  
7. **Wishbone Interface** – Validate read/write cycles and acknowledge (`ack_o`) behavior.  
8. **Concurrent Access** – Simultaneous read/write FIFO operations without data corruption.  
9. **Clock Division** – Verify programmable SPI clock division ratios.  
10. **Boundary Cases** – Stress test with extreme configurations (SPR, ICNT, FIFO depth).

---

## 🖥️ DUT Specifications (SPI Core)
- Based on **Motorola M68HC11 SPI**  
- Features:
  - **Wishbone RevB.3 Classic interface** (8-bit)
  - **4-deep read and write FIFOs**
  - **Programmable SPI clock division**
  - **Interrupt generation after 1–4 transfers**
  - **Supports all CPOL/CPHA modes**
- Reference: [OpenCores SPI Core Datasheet](https://opencores.org/projects/spi)
