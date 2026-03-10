`timescale 1ns/1ps

module tb_dmem;

    // Parameters
    parameter int mdepth = 64;

    // Testbench signals
    logic clk_i;
    logic [31:0] addr_i;
    logic wrEn_i;
    logic rdEn_i;
    logic [31:0] instr_i;
    logic [63:0] data_i;
    logic [63:0] data_o;

    // Clock generation
    initial clk_i = 0;
    always #5 clk_i = ~clk_i;  // 10ns clock period

    // Instantiate the Device Under Test (DUT)
    dmem #(mdepth) dut (
        .clk_i(clk_i),
        .addr_i(addr_i),
        .wrEn_i(wrEn_i),
        .rdEn_i(rdEn_i),
        .instr_i(instr_i),
        .data_i(data_i),
        .data_o(data_o)
    );

    // Test sequence
    initial begin
        // Initialize inputs
        addr_i = 0;
        wrEn_i = 0;
        rdEn_i = 0;
        instr_i = 0;
        data_i = 0;

        // Wait for the reset to stabilize
        #10;

        // Test 1: Write a double word to memory
        addr_i = 32'h00000008;  // Address
        data_i = 64'hDEADBEEFCAFEBABE;  // Data to write
        instr_i = 32'h00000023;  // Store double word (SD) instruction (opcode 7'b0100011)
        wrEn_i = 1;  // Enable write
        rdEn_i = 0;  // Disable read
        #10;

        wrEn_i = 0;  // Disable write
        #10;

        // Test 2: Read back the double word
        addr_i = 32'h00000008;  // Address
        instr_i = 32'h00000003;  // Load double word (LD) instruction (opcode 7'b0000011)
        rdEn_i = 1;  // Enable read
        #10;

        rdEn_i = 0;  // Disable read
        #10;

        // Test 3: Write a word to memory (SW)
        addr_i = 32'h0000000C;  // Address
        data_i = 64'h12345678;  // Data to write (lower 32 bits will be used)
        instr_i = 32'h00000023;  // Store word (SW) instruction (opcode 7'b0100011, func3 3'b010)
        wrEn_i = 1;  // Enable write
        rdEn_i = 0;  // Disable read
        #10;

        wrEn_i = 0;  // Disable write
        #10;

        // Test 4: Read back the word
        addr_i = 32'h0000000C;  // Address
        instr_i = 32'h00000003;  // Load word (LW) instruction (opcode 7'b0000011, func3 3'b010)
        rdEn_i = 1;  // Enable read
        #10;

        rdEn_i = 0;  // Disable read
        #10;

        // Test 5: Write and read a byte (SB and LB)
        addr_i = 32'h00000010;  // Address
        data_i = 64'hAB;  // Data to write (only 8 bits will be used)
        instr_i = 32'h00000023;  // Store byte (SB) instruction (opcode 7'b0100011, func3 3'b000)
        wrEn_i = 1;  // Enable write
        rdEn_i = 0;  // Disable read
        #10;

        wrEn_i = 0;  // Disable write
        #10;

        addr_i = 32'h00000010;  // Address
        instr_i = 32'h00000003;  // Load byte (LB) instruction (opcode 7'b0000011, func3 3'b000)
        rdEn_i = 1;  // Enable read
        #10;

        rdEn_i = 0;  // Disable read
        #10;

        // End simulation
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0dns, addr_i: %h, wrEn_i: %b, rdEn_i: %b, instr_i: %h, data_i: %h, data_o: %h", 
                 $time, addr_i, wrEn_i, rdEn_i, instr_i, data_i, data_o);
    end

endmodule
