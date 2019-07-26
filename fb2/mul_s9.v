
module mul_s9 (
	p_reset, m_clock, a, b,
	dout, con
);
	input p_reset, m_clock;
	input signed [8:0] a, b;
	output signed [17:0] dout;
	input con;

	// -> 符号付き 9x9=18 ビット乗算
	assign dout = a * b;

endmodule
