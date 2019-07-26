
module mul_s19 (
	p_reset, m_clock, a, b,
	dout, con
);
	input p_reset, m_clock;
	input signed [18:0] a, b;
	output signed [37:0] dout;
	input con;

	// -> 符号付き 19x19=38 ビット乗算
	assign dout = a * b;

endmodule
