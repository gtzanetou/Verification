

module one_round (
clk,
state_in,
key,
state_out
);

    input clk;
    input [127:0] state_in, key;
    output logic [127:0] state_out;
    
    logic [31:0] s0, s1, s2, s3;
    logic [31:0] z0, z1, z2, z3;
    logic [31:0] p00, p01, p02, p03;
    logic [31:0] p10, p11, p12, p13;
    logic [31:0] p20, p21, p22, p23;
    logic [31:0] p30, p31, p32, p33;
    logic [31:0] k0, k1, k2, k3;
    
    assign {k0, k1, k2, k3} = key;
    assign {s0, s1, s2, s3} = state_in;
    
    table_lookup 
        t0 (clk, s0, p00, p01, p02, p03),
        t1 (clk, s1, p10, p11, p12, p13),
        t2 (clk, s2, p20, p21, p22, p23),
        t3 (clk, s3, p30, p31, p32, p33);
        
    assign z0 = p00 ^ p11 ^ p22 ^ p33 ^ k0;
    assign z1 = p03 ^ p10 ^ p21 ^ p32 ^ k1;
    assign z2 = p02 ^ p13 ^ p20 ^ p31 ^ k2;
    assign z3 = p01 ^ p12 ^ p23 ^ p30 ^ k3;
    
    always_ff@(posedge clk) state_out <= {z0, z1, z2, z3};
endmodule


module final_round (
clk,
state_in,
key_in,
state_out
);

    input clk;
    input [127:0] state_in;
    input [127:0] key_in;
    output logic [127:0] state_out;
    
    logic [31:0] s0, s1, s2, s3;
    logic [31:0] z0, z1, z2, z3;
    logic [31:0] k0, k1, k2, k3;
    logic [7:0]  p00, p01, p02, p03;
    logic [7:0]  p10, p11, p12, p13;
    logic [7:0]  p20, p21, p22, p23;
    logic [7:0]  p30, p31, p32, p33;

    assign {k0, k1, k2, k3} = key_in;
    assign {s0, s1, s2, s3} = state_in;
    
    S4 
        S4_1 (clk, s0, {p00, p01, p02, p03}),
        S4_2 (clk, s1, {p10, p11, p12, p13}),
        S4_3 (clk, s2, {p20, p21, p22, p23}),
        S4_4 (clk, s3, {p30, p31, p32, p33});
        
    assign z0 = {p00, p11, p22, p33} ^ k0;
    assign z1 = {p10, p21, p32, p03} ^ k1;
    assign z2 = {p20, p31, p02, p13} ^ k2;
    assign z3 = {p30, p01, p12, p23} ^ k3;
    
    always_ff@(posedge clk) state_out <= {z0, z1, z2, z3};
endmodule

