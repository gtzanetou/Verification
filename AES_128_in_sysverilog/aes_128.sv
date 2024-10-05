

module aes_128(
    input  logic         clk,
    input  logic [127:0] state, key,
    output logic [127:0] out
);
    logic [127:0] s0, k0;
    logic [127:0] s1, s2, s3, s4, s5, s6, s7, s8, s9;
    logic [127:0] k1, k2, k3, k4, k5, k6, k7, k8, k9;
    logic [127:0] k0b, k1b, k2b, k3b, k4b, k5b, k6b, k7b, k8b, k9b;
    
    always_ff @(posedge clk) begin
        s0 <= state ^ key;
        k0 <= key;
    end
    /*  always_ff @(posedge clk) begin
        assert (state != 128'h0) else $fatal("Error: State is all zeros.");
        assert (key != 128'h0) else $fatal("Error: Key is all zeros.");
    end */
    
    expand_key_128
        a1 (.clk(clk), .in(k0), .out_1(k1), .out_2(k0b), .rcon(8'h1)),
        a2 (.clk(clk), .in(k1), .out_1(k2), .out_2(k1b), .rcon(8'h2)),
        a3 (.clk(clk), .in(k2), .out_1(k3), .out_2(k2b), .rcon(8'h4)),
        a4 (.clk(clk), .in(k3), .out_1(k4), .out_2(k3b), .rcon(8'h8)),
        a5 (.clk(clk), .in(k4), .out_1(k5), .out_2(k4b), .rcon(8'h10)),
        a6 (.clk(clk), .in(k5), .out_1(k6), .out_2(k5b), .rcon(8'h20)),
        a7 (.clk(clk), .in(k6), .out_1(k7), .out_2(k6b), .rcon(8'h40)),
        a8 (.clk(clk), .in(k7), .out_1(k8), .out_2(k7b), .rcon(8'h80)),
        a9 (.clk(clk), .in(k8), .out_1(k9), .out_2(k8b), .rcon(8'h1b)),
       a10 (.clk(clk), .in(k9), .out_1(), .out_2(k9b), .rcon(8'h36));

    one_round
        r1 (.clk(clk), .state_in(s0), .key(k0b), .state_out(s1)),
        r2 (.clk(clk), .state_in(s1), .key(k1b), .state_out(s2)),
        r3 (.clk(clk), .state_in(s2), .key(k2b), .state_out(s3)),
        r4 (.clk(clk), .state_in(s3), .key(k3b), .state_out(s4)),
        r5 (.clk(clk), .state_in(s4), .key(k4b), .state_out(s5)),
        r6 (.clk(clk), .state_in(s5), .key(k5b), .state_out(s6)),
        r7 (.clk(clk), .state_in(s6), .key(k6b), .state_out(s7)),
        r8 (.clk(clk), .state_in(s7), .key(k7b), .state_out(s8)),
        r9 (.clk(clk), .state_in(s8), .key(k8b), .state_out(s9));

    final_round
        rf (.clk(clk), .state_in(s9), .key_in(k9b), .state_out(out));
endmodule





module expand_key_128 (
    input  logic         clk,
    input  logic [127:0] in,
    input  logic [7:0]   rcon,
    output logic [127:0] out_1,
    output logic [127:0] out_2
);
    logic [31:0] k0, k1, k2, k3;
    logic [31:0] v0, v1, v2, v3;
    logic [31:0] k0a, k1a, k2a, k3a;
    logic [31:0] k0b, k1b, k2b, k3b, k4a;

    assign {k0, k1, k2, k3} = in;

    assign v0 = {k0[31:24] ^ rcon, k0[23:0]};
    assign v1 = v0 ^ k1;
    assign v2 = v1 ^ k2;
    assign v3 = v2 ^ k3;

    always_ff @(posedge clk)
        {k0a, k1a, k2a, k3a} <= {v0, v1, v2, v3};

    S4
        S4_0 (.clk(clk), .in({k3[23:0], k3[31:24]}), .out(k4a));

    assign k0b = k0a ^ k4a;
    assign k1b = k1a ^ k4a;
    assign k2b = k2a ^ k4a;
    assign k3b = k3a ^ k4a;

    always_ff @(posedge clk)
        out_1 <= {k0b, k1b, k2b, k3b};

    assign out_2 = {k0b, k1b, k2b, k3b};
endmodule

