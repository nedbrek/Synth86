Synth86 - a synthesizable x86 (intended for FPGA uarch studies)
   There is another FPGA x86: http://zet.aluzina.org/index.php/Zet_processor
	Zet is starting from the 8086 and working up (it is single-cycle IIRC).
	It boots DOS.

	My goal here is to go straight for pipelined 64-bit, and boot Linux, so I
	can run gcc and gather uarch data (for uarch research).  Potentially,
	modifying the ISA and combining it with NedOS or a modified Linux build.

	The heart of the machine will be dataflow, so parts might be useful for any
	high performance uarch.

To build:
	Put all the vhdl into your project and synthesize "synth86" as the toplevel.
	There are currently two shifter impls (one barrel, one using multipliers)

boards.txt: a list of some candidate boards (with prices)
	Once I buy a board, there will be board-specific code

