
module mul_u5 (
	p_reset, m_clock, a, b,
	dout, con
);
	input p_reset, m_clock;
	input [4:0] a, b;
	output [9:0] dout;
	input con;

	// -> �����Ȃ� 5x5=10 �r�b�g��Z
	assign dout = a * b;

endmodule
