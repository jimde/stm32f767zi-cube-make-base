# Base/Minimal Makefile Project for STM32F767ZI

Makefile-based project utilizing STMicroelectronics' STM32CubeF7 MCU firmware package (HAL, LL drivers, CMSIS, BSPs, etc.).

This was made to avoid using an IDE and to act as a base starting point for any personal STM32 projects.

## Prerequisites

- GNU ARM embedded toolchain (9-2019-q4-major)
    - https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads
- make
- git
- Segger J-Link software package
    - https://www.segger.com/products/debug-probes/j-link/tools/j-link-software/
- Segger Ozone
    - https://www.segger.com/products/development-tools/ozone-j-link-debugger/
- Flash STM32F767ZI board with J-Link firmware
    - https://www.segger.com/products/debug-probes/j-link/models/other-j-links/st-link-on-board/

## Setup

Run `setup.sh` to clone the STM32CubeF7 MCU firmware package and verify prerequisites

## Usage

- `make`
- `make install`