
module mul_u5 (
	p_reset, m_clock, a, b,
	dout, con
);
	input p_reset, m_clock;
	input [4:0] a, b;
	output [9:0] dout;
	input con;

	// -> •„†‚È‚µ 5x5=10 ƒrƒbƒgæZ
	assign dout = a * b;

endmodule
