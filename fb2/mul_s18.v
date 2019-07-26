
module mul_s18 (
	p_reset, m_clock, a, b,
	dout, con
);
	input p_reset, m_clock;
	input signed [17:0] a, b;
	output signed [35:0] dout;
	input con;

	// -> 符号付き 18x18=36 ビット乗算
	assign dout = a * b;

endmodule
