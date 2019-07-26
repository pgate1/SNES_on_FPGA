
module mul_s24 (
	a, b, dout, con
);
	input signed [23:0] a, b;
//	input signed [7:0] b;
	output signed [47:0] dout;
	input con;

	// -> 符号付き 24x24=48 ビット乗算
	assign dout = a * b;

endmodule
