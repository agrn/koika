// DFFs
module DFF_X1(D, CK, Q, QN);
output Q, QN;
input D, CK;
reg Q;
always @(posedge(CK)) Q = D;
assign QN = ~Q;
endmodule

module DFF_X2(D, CK, Q, QN);
output Q, QN;
input D, CK;
reg Q;
always @(posedge(CK)) Q = D;
assign QN = ~Q;
endmodule

// Large inverters and buffers
module BUF_X8(A, Z);
input A;
output Z;
assign Z = A;
endmodule

module INV_X8(A, ZN);
input A;
output ZN;
assign ZN = ~A;
endmodule

module BUF_X16(A, Z);
input A;
output Z;
assign Z = A;
endmodule

module INV_X16(A, ZN);
input A;
output ZN;
assign ZN = ~A;
endmodule

module BUF_X32(A, Z);
input A;
output Z;
assign Z = A;
endmodule

module INV_X32(A, ZN);
input A;
output ZN;
assign ZN = ~A;
endmodule


// Autogenerated set with suffix _X1
module BUF_X1(A, Z);
input A;
output Z;
assign Z = A;
endmodule

module INV_X1(A, ZN);
input A;
output ZN;
assign ZN = ~A;
endmodule

module NAND2_X1(A1, A2, ZN);
input A1, A2;
output ZN;
assign ZN = ~(A1 & A2);
endmodule

module NOR2_X1(A1, A2, ZN);
input A1, A2;
output ZN;
assign ZN = ~(A1 | A2);
endmodule

module XNOR2_X1(A, B, ZN);
input A, B;
output ZN;
assign ZN = ~(A ^ B);
endmodule

module NAND3_X1(A1, A2, A3, ZN);
input A1, A2, A3;
output ZN;
assign ZN = ~(A1 & A2 & A3);
endmodule

module NOR3_X1(A1, A2, A3, ZN);
input A1, A2, A3;
output ZN;
assign ZN = ~(A1 | A2 | A3);
endmodule

module NAND4_X1(A1, A2, A3, A4, ZN);
input A1, A2, A3, A4;
output ZN;
assign ZN = ~(A1 & A2 & A3 & A4);
endmodule

module NOR4_X1(A1, A2, A3, A4, ZN);
input A1, A2, A3, A4;
output ZN;
assign ZN = ~(A1 | A2 | A3 | A4);
endmodule

// Non-invering variants
module AND2_X1(A1, A2, ZN);
input A1, A2;
output ZN;
assign ZN = (A1 & A2);
endmodule

module OR2_X1(A1, A2, ZN);
input A1, A2;
output ZN;
assign ZN = (A1 | A2);
endmodule

module XOR2_X1(A, B, Z);
input A, B;
output Z;
assign Z = (A ^ B);
endmodule

module AND3_X1(A1, A2, A3, ZN);
input A1, A2, A3;
output ZN;
assign ZN = (A1 & A2 & A3);
endmodule

module OR3_X1(A1, A2, A3, ZN);
input A1, A2, A3;
output ZN;
assign ZN = (A1 | A2 | A3);
endmodule

module AND4_X1(A1, A2, A3, A4, ZN);
input A1, A2, A3, A4;
output ZN;
assign ZN = (A1 & A2 & A3 & A4);
endmodule

module OR4_X1(A1, A2, A3, A4, ZN);
input A1, A2, A3, A4;
output ZN;
assign ZN = (A1 | A2 | A3 | A4);
endmodule

// Autogenerated set with suffix _X2
module BUF_X2(A, Z);
input A;
output Z;
assign Z = A;
endmodule

module INV_X2(A, ZN);
input A;
output ZN;
assign ZN = ~A;
endmodule

module NAND2_X2(A1, A2, ZN);
input A1, A2;
output ZN;
assign ZN = ~(A1 & A2);
endmodule

module NOR2_X2(A1, A2, ZN);
input A1, A2;
output ZN;
assign ZN = ~(A1 | A2);
endmodule

module XNOR2_X2(A, B, ZN);
input A, B;
output ZN;
assign ZN = ~(A ^ B);
endmodule

module NAND3_X2(A1, A2, A3, ZN);
input A1, A2, A3;
output ZN;
assign ZN = ~(A1 & A2 & A3);
endmodule

module NOR3_X2(A1, A2, A3, ZN);
input A1, A2, A3;
output ZN;
assign ZN = ~(A1 | A2 | A3);
endmodule

module NAND4_X2(A1, A2, A3, A4, ZN);
input A1, A2, A3, A4;
output ZN;
assign ZN = ~(A1 & A2 & A3 & A4);
endmodule

module NOR4_X2(A1, A2, A3, A4, ZN);
input A1, A2, A3, A4;
output ZN;
assign ZN = ~(A1 | A2 | A3 | A4);
endmodule

// Non-invering variants
module AND2_X2(A1, A2, ZN);
input A1, A2;
output ZN;
assign ZN = (A1 & A2);
endmodule

module OR2_X2(A1, A2, ZN);
input A1, A2;
output ZN;
assign ZN = (A1 | A2);
endmodule

module XOR2_X2(A, B, Z);
input A, B;
output Z;
assign Z = (A ^ B);
endmodule

module AND3_X2(A1, A2, A3, ZN);
input A1, A2, A3;
output ZN;
assign ZN = (A1 & A2 & A3);
endmodule

module OR3_X2(A1, A2, A3, ZN);
input A1, A2, A3;
output ZN;
assign ZN = (A1 | A2 | A3);
endmodule

module AND4_X2(A1, A2, A3, A4, ZN);
input A1, A2, A3, A4;
output ZN;
assign ZN = (A1 & A2 & A3 & A4);
endmodule

module OR4_X2(A1, A2, A3, A4, ZN);
input A1, A2, A3, A4;
output ZN;
assign ZN = (A1 | A2 | A3 | A4);
endmodule

// Autogenerated set with suffix _X4
module BUF_X4(A, Z);
input A;
output Z;
assign Z = A;
endmodule

module INV_X4(A, ZN);
input A;
output ZN;
assign ZN = ~A;
endmodule

module NAND2_X4(A1, A2, ZN);
input A1, A2;
output ZN;
assign ZN = ~(A1 & A2);
endmodule

module NOR2_X4(A1, A2, ZN);
input A1, A2;
output ZN;
assign ZN = ~(A1 | A2);
endmodule

module XNOR2_X4(A, B, ZN);
input A, B;
output ZN;
assign ZN = ~(A ^ B);
endmodule

module NAND3_X4(A1, A2, A3, ZN);
input A1, A2, A3;
output ZN;
assign ZN = ~(A1 & A2 & A3);
endmodule

module NOR3_X4(A1, A2, A3, ZN);
input A1, A2, A3;
output ZN;
assign ZN = ~(A1 | A2 | A3);
endmodule

module NAND4_X4(A1, A2, A3, A4, ZN);
input A1, A2, A3, A4;
output ZN;
assign ZN = ~(A1 & A2 & A3 & A4);
endmodule

module NOR4_X4(A1, A2, A3, A4, ZN);
input A1, A2, A3, A4;
output ZN;
assign ZN = ~(A1 | A2 | A3 | A4);
endmodule

// Non-invering variants
module AND2_X4(A1, A2, ZN);
input A1, A2;
output ZN;
assign ZN = (A1 & A2);
endmodule

module OR2_X4(A1, A2, ZN);
input A1, A2;
output ZN;
assign ZN = (A1 | A2);
endmodule

module XOR2_X4(A, B, Z);
input A, B;
output Z;
assign Z = (A ^ B);
endmodule

module AND3_X4(A1, A2, A3, ZN);
input A1, A2, A3;
output ZN;
assign ZN = (A1 & A2 & A3);
endmodule

module OR3_X4(A1, A2, A3, ZN);
input A1, A2, A3;
output ZN;
assign ZN = (A1 | A2 | A3);
endmodule

module AND4_X4(A1, A2, A3, A4, ZN);
input A1, A2, A3, A4;
output ZN;
assign ZN = (A1 & A2 & A3 & A4);
endmodule

module OR4_X4(A1, A2, A3, A4, ZN);
input A1, A2, A3, A4;
output ZN;
assign ZN = (A1 | A2 | A3 | A4);
endmodule
