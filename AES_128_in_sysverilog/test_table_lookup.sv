



`timescale 1ns / 1ps



module test_table_lookup;
    // Inputs
    logic clk; 
    logic [31:0] state;

    // Outputs
    logic [31:0] p0; 
    logic [31:0] p1; 
    logic [31:0] p2; 
    logic [31:0] p3; 
    
    // Instantiate the Unit Under Test (UUT)
    table_lookup uut (
        .clk(clk), 
        .state(state), 
        .p0(p0), 
        .p1(p1), 
        .p2(p2), 
        .p3(p3)
    );

    initial begin
        clk = 0;
        state = 0;
        #100;
        state = 32'h193de3be; // corrected from 31'h193de3be to 32'h193de3be
        #10;
        if (p0 !== 32'hb3_d4_d4_67) begin $display("E"); $finish; end
        if (p1 !== 32'h69_4e_27_27) begin $display("E"); $finish; end
        if (p2 !== 32'h11_33_22_11) begin $display("E"); $finish; end
        if (p3 !== 32'hae_ae_e9_47) begin $display("E"); $finish; end
        $display("Good.");
        $finish;
    end
    
    always #5 clk = ~clk; //dhmiourgia rologiou

endmodule


