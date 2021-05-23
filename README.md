# ebaz4205_qemu

The EBAZ4205 was originally developed as cryptomining control board.
Due to it's low price on the marked it is also perfect to learn
the Zynq platform. This repository hosts a documentation and
makefile in order to run QEMU for the platform.

## Maintainer

	Lukas Lichtl (admin@embed-me.com)

## Hardware Support

Currently QEMU emulates the following hardware of the board

* Zynq-7000
* 256MB Memory
* Network Interface Card
* Serial Console
* SD-Card

## Dependencies

Xilinx Fork of QEMU:

	URI: https://github.com/Xilinx/qemu

It is recommended to build QEMU from source according to
the requirements in UG1169 (Xilinx).

The makefile requires `qemu-system-aarch64` to be in the PATH!

## Running QEMU

First, within the makefile adjust IMG_DIR and HOST_ADAPTER_TO_BRIDGE.

Generate the bridge and tap interfaces in the host by running.

	make net_prep

After that start your emulation.

	make run

When done, the following command cleans up the previously
generated network interfaces.

	make net_unprep