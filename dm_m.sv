module dmem (
    input  logic                   clk_i,
    input  logic [31:0]            addr_i,    // 32-bit address input
    input  logic                   wrEn_i,
    input  logic                   rdEn_i,
    input  logic [31:0]            instr_i,   // 32-bit instruction input
    input  logic [63:0]            data_i,    // 64-bit data input
    output logic [63:0]            data_o     // 64-bit data output
);

    // Memory depth
    parameter int mdepth = 64;  // Memory depth in 64-bit words

    // Memory array (64-bit word width)
    logic [63:0] ram_s[mdepth-1:0];

    // Internal signals
    logic [63:0] dataw_s, dataRd_s, dataWr_s; // 64-bit signals for data handling
    logic [31:0] addr_s;                      // 32-bit address signal
    logic [31:0] instr_s;                     // 32-bit instruction signal
    logic        we_s;                        // Write enable
    logic [6:0]  opcode_s;                    // Opcode (7 bits)
    logic [2:0]  func3_s;                     // Function code 3 (3 bits)
    logic        unused_signal;               // Dummy wire for unused addr_i[30]

    // Tie unused addr_i[30] to a dummy wire
    assign unused_signal = addr_i[30];

    // Registers for outputs
    logic [63:0] data_o_reg;

    // Sequential logic block
    always_ff @(posedge clk_i) begin
        // Capture inputs
        if (wrEn_i || rdEn_i) begin
            dataw_s <= data_i;
            addr_s  <= addr_i;
            instr_s <= instr_i;
        end

        // Instruction decoding
        opcode_s <= instr_s[6:0];
        func3_s  <= instr_s[14:12];

        // Default dataWr_s
        dataWr_s <= dataw_s;

        // Write Data Logic (Store Instructions)
        if (wrEn_i) begin
            case (opcode_s)
                7'b0100011:  // Store instructions
                    case (func3_s)
                        3'b000:  // Store byte (SB)
                            case (addr_s[2:0])  // Byte offset
                                3'd0: dataWr_s[7:0]   <= dataw_s[7:0];
                                3'd1: dataWr_s[15:8]  <= dataw_s[7:0];
                                3'd2: dataWr_s[23:16] <= dataw_s[7:0];
                                3'd3: dataWr_s[31:24] <= dataw_s[7:0];
                                3'd4: dataWr_s[39:32] <= dataw_s[7:0];
                                3'd5: dataWr_s[47:40] <= dataw_s[7:0];
                                3'd6: dataWr_s[55:48] <= dataw_s[7:0];
                                3'd7: dataWr_s[63:56] <= dataw_s[7:0];
                            endcase
                        3'b001:  // Store half-word (SH)
                            case (addr_s[2:1])  // Half-word offset
                                2'd0: dataWr_s[15:0]   <= dataw_s[15:0];
                                2'd1: dataWr_s[31:16]  <= dataw_s[15:0];
                                2'd2: dataWr_s[47:32]  <= dataw_s[15:0];
                                2'd3: dataWr_s[63:48]  <= dataw_s[15:0];
                            endcase
                        3'b010:  // Store word (SW)
                            if (addr_s[2] == 0)
                                dataWr_s[31:0] <= dataw_s[31:0];
                            else
                                dataWr_s[63:32] <= dataw_s[31:0];
                        3'b011:  // Store double word (SD)
                            dataWr_s <= dataw_s;
                    endcase
            endcase
        end

        // Write RAM
        if (wrEn_i) begin
            ram_s[addr_s[31:3]] <= dataWr_s;  // Address word-aligned
        end

        // Read Data Logic (Load Instructions)
        dataRd_s <= ram_s[addr_s[31:3]];  // Access memory
        data_o_reg <= 64'b0;              // Default output

        if (rdEn_i) begin
            case (opcode_s)
                7'b0000011:  // Load instructions
                    case (func3_s)
                        3'b000:  // Load byte (LB)
                            case (addr_s[2:0])  // Byte offset
                                3'd0: data_o_reg <= {{56{dataRd_s[7]}}, dataRd_s[7:0]};
                                3'd1: data_o_reg <= {{56{dataRd_s[15]}}, dataRd_s[15:8]};
                                3'd2: data_o_reg <= {{56{dataRd_s[23]}}, dataRd_s[23:16]};
                                3'd3: data_o_reg <= {{56{dataRd_s[31]}}, dataRd_s[31:24]};
                                3'd4: data_o_reg <= {{56{dataRd_s[39]}}, dataRd_s[39:32]};
                                3'd5: data_o_reg <= {{56{dataRd_s[47]}}, dataRd_s[47:40]};
                                3'd6: data_o_reg <= {{56{dataRd_s[55]}}, dataRd_s[55:48]};
                                3'd7: data_o_reg <= {{56{dataRd_s[63]}}, dataRd_s[63:56]};
                            endcase
                        3'b001:  // Load half-word (LH)
                            case (addr_s[2:1])  // Half-word offset
                                2'd0: data_o_reg <= {{48{dataRd_s[15]}}, dataRd_s[15:0]};
                                2'd1: data_o_reg <= {{48{dataRd_s[31]}}, dataRd_s[31:16]};
                                2'd2: data_o_reg <= {{48{dataRd_s[47]}}, dataRd_s[47:32]};
                                2'd3: data_o_reg <= {{48{dataRd_s[63]}}, dataRd_s[63:48]};
                            endcase
                        3'b010:  // Load word (LW)
                            if (addr_s[2] == 0)
                                data_o_reg <= {{32{dataRd_s[31]}}, dataRd_s[31:0]};
                            else
                                data_o_reg <= {{32{dataRd_s[63]}}, dataRd_s[63:32]};
                        3'b011:  // Load double word (LD)
                            data_o_reg <= dataRd_s;
                        3'b100:  // Load byte unsigned (LBU)
                            case (addr_s[2:0])
                                3'd0: data_o_reg <= {56'b0, dataRd_s[7:0]};
                                3'd1: data_o_reg <= {56'b0, dataRd_s[15:8]};
                                3'd2: data_o_reg <= {56'b0, dataRd_s[23:16]};
                                3'd3: data_o_reg <= {56'b0, dataRd_s[31:24]};
                                3'd4: data_o_reg <= {56'b0, dataRd_s[39:32]};
                                3'd5: data_o_reg <= {56'b0, dataRd_s[47:40]};
                                3'd6: data_o_reg <= {56'b0, dataRd_s[55:48]};
                                3'd7: data_o_reg <= {56'b0, dataRd_s[63:56]};
                            endcase
                        3'b101:  // Load half-word unsigned (LHU)
                            case (addr_s[2:1])
                                2'd0: data_o_reg <= {48'b0, dataRd_s[15:0]};
                                2'd1: data_o_reg <= {48'b0, dataRd_s[31:16]};
                                2'd2: data_o_reg <= {48'b0, dataRd_s[47:32]};
                                2'd3: data_o_reg <= {48'b0, dataRd_s[63:48]};
                            endcase
                        3'b110:  // Load word unsigned (LWU)
                            if (addr_s[2] == 0)
                                data_o_reg <= {32'b0, dataRd_s[31:0]};
                            else
                                data_o_reg <= {32'b0, dataRd_s[63:32]};
                    endcase
            endcase
        end
    end

    // Assign the output
    assign data_o = data_o_reg;

endmodule
