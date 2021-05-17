`timescale 1ns / 1ps

module alu_tb();
    reg [5:0] S;
    reg [31:0] A, B;
    wire CMP;
    wire [31:0] Q;
    reg CMP_soll;
    reg [31:0] Q_soll;
    
    alu dut(.A(A), .B(B), .S(S), .Q(Q), .CMP(CMP));
    
    initial begin
        
        //Testmuster 1: A == B erkannt
        S=6'b100011; A=32'd0; B=32'd0; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 2: A != B erkannt
        S=6'b100011; A=32'd1; B=32'd0; Q_soll=1'bx; CMP_soll=1'b0; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 3: A==B mit beliebigem Wert
        S=6'b100011; A=32'd42; B=32'd42; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 4: andere DC belegung
        S=6'b000011; A=32'd0; B=32'd0; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 5: A == B erkannt
        S=6'b000111; A=32'd0; B=32'd0; Q_soll=1'bx; CMP_soll=1'b0; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 6: A != B erkannt
        S=6'b000111; A=32'd1; B=32'd0; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 7: A!=B andere werte
        S=6'b000111; A=32'd250; B=32'd1; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 8: Andere DC belegung
        S=6'b100111; A=32'd0; B=32'd0; Q_soll=1'bx; CMP_soll=1'b0; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 9: A<B erkannt
        S=6'b010011; A=32'd25; B=32'd27; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 10: A > B erkannt
        S=6'b010011; A=32'd105; B=32'd0; Q_soll=1'bx; CMP_soll=1'b0; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 11: Beide werte negativ
        S=6'b010011; A=-32'd5; B=-32'd4; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 12: Ein wert negativ
        S=6'b010011; A=-32'd20; B=32'd1; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 13: Anderer Wert negativ
        S=6'b010011; A=32'd0; B=-32'd3; Q_soll=1'bx; CMP_soll=1'b0; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 14: A == B erkannt und andere DC belegung
        S=6'b110011; A=32'd0; B=32'd0; Q_soll=1'bx; CMP_soll=1'b0; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 15: A < B erkannt
        S=6'b011011; A=32'd0; B=32'd2; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 16: A > B erkannt
        S=6'b011011; A=32'd5; B=32'd4; Q_soll=1'bx; CMP_soll=1'b0; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 17: A == B erkannt und andere DC belegung
        S=6'b111011; A=32'd0; B=32'd0; Q_soll=1'bx; CMP_soll=1'b0; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 18: A<B erkannt
        S=6'b010111; A=32'd25; B=32'd27; Q_soll=1'bx; CMP_soll=1'b0; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 19: A > B erkannt
        S=6'b010111; A=32'd105; B=32'd0; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 20: Beide werte negativ
        S=6'b010111; A=-32'd5; B=-32'd4; Q_soll=1'bx; CMP_soll=1'b0; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 21: Ein wert negativ
        S=6'b010111; A=-32'd20; B=32'd1; Q_soll=1'bx; CMP_soll=1'b0; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 22: Anderer Wert negativ
        S=6'b010111; A=32'd0; B=-32'd3; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 23: A == B erkannt und andere DC belegung
        S=6'b110111; A=32'd0; B=32'd0; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 24: A < B erkannt
        S=6'b011111; A=32'd0; B=32'd2; Q_soll=1'bx; CMP_soll=1'b0; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 25: A > B erkannt
        S=6'b011111; A=32'd5; B=32'd4; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 26: A == B erkannt und andere DC belegung
        S=6'b111111; A=32'd0; B=32'd0; Q_soll=1'bx; CMP_soll=1'b1; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 27: 0+B=B
        S=6'b000000; A=32'd0; B=32'd50; Q_soll=32'd50; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 28: A+0=A
        S=6'b000000; A=32'd67; B=32'd0; Q_soll=32'd67; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 29: A+B
        S=6'b000000; A=32'd42; B=32'd58; Q_soll=32'd100; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 30: A negativ
        S=6'b000000; A=-32'd5; B=32'd4; Q_soll=-32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 31: B negativ
        S=6'b000000; A=32'd12; B=-32'd10; Q_soll=32'd2; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 32: beide negativ
        S=6'b000000; A=-32'd10; B=-32'd20; Q_soll=-32'd30; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 33: 0+0 und andere DC belegung
        S=6'b100000; A=32'd0; B=32'd0; Q_soll=32'd0; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 34: 0+B=B
        S=6'b000001; A=32'd0; B=32'd50; Q_soll=32'd50; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 35: A+0=A
        S=6'b000001; A=32'd67; B=32'd0; Q_soll=32'd67; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 36: A+B
        S=6'b000001; A=32'd42; B=32'd58; Q_soll=32'd100; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 37: A negativ
        S=6'b000001; A=-32'd5; B=32'd4; Q_soll=-32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 38: B negativ
        S=6'b000001; A=32'd12; B=-32'd10; Q_soll=32'd2; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 39: beide negativ
        S=6'b000001; A=-32'd10; B=-32'd20; Q_soll=-32'd30; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 40: 0+0
        S=6'b000001; A=32'd0; B=32'd0; Q_soll=32'd0; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 41: 
        S=6'b100001; A=32'd5; B=32'd4; Q_soll=32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 42: 
        S=6'b100001; A=32'd4; B=32'd5; Q_soll=-32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 43: 
        S=6'b100001; A=-32'd5; B=-32'd4; Q_soll=-32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 44: 
        S=6'b100001; A=-32'd4; B=-32'd5; Q_soll=32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 45: 
        S=6'b100001; A=32'd0; B=32'd0; Q_soll=32'd0; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 46: 
        S=6'b100001; A=32'd5; B=32'd0; Q_soll=32'd5; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 47: 
        S=6'b100001; A=32'd0; B=32'd5; Q_soll=-32'd5; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 48: 
        S=6'b100001; A=32'd0; B=-32'd5; Q_soll=32'd5; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 49: Testpattern mit allen m?glichen Bitkombinationen
        S=6'b011100; A=32'b0011; B=32'b0101; Q_soll=32'b0001; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 50: andere DC belegung
        S=6'b111100; A=32'b0011; B=32'b0101; Q_soll=32'b0001; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 51: Testpattern mit allen m?glichen Bitkombinationen
        S=6'b011101; A=32'b0011; B=32'b0101; Q_soll=32'b0001; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 52: andere DC belegung
        S=6'b111101; A=32'b0011; B=32'b0101; Q_soll=32'b0001; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 53: Testpattern mit allen m?glichen Bitkombinationen
        S=6'b011000; A=32'b0011; B=32'b0101; Q_soll=32'b0111; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 54: andere DC belegung
        S=6'b111000; A=32'b0011; B=32'b0101; Q_soll=32'b0111; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 55: Testpattern mit allen m?glichen Bitkombinationen
        S=6'b011001; A=32'b0011; B=32'b0101; Q_soll=32'b0111; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 56: andere DC belegung
        S=6'b111001; A=32'b0011; B=32'b0101; Q_soll=32'b0111; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 57: Testpattern mit allen m?glichen Bitkombinationen
        S=6'b010000; A=32'b0011; B=32'b0101; Q_soll=32'b0110; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 58: andere DC belegung
        S=6'b110000; A=32'b0011; B=32'b0101; Q_soll=32'b0110; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 59: Testpattern mit allen m?glichen Bitkombinationen
        S=6'b010001; A=32'b0011; B=32'b0101; Q_soll=32'b0110; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 60: andere DC belegung
        S=6'b110001; A=32'b0011; B=32'b0101; Q_soll=32'b0110; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 61: 
        S=6'b000100; A=32'b1010; B=32'd1; Q_soll=32'b10100; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 62: 
        S=6'b000100; A=32'b101; B=32'd2; Q_soll=32'b10100; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 63: 
        S=6'b000101; A=32'b1010; B=32'd1; Q_soll=32'b10100; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 64: 
        S=6'b000101; A=32'b101; B=32'd2; Q_soll=32'b10100; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 65: 
        S=6'b010100; A=32'b1010; B=32'd1; Q_soll=32'b101; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 66: 
        S=6'b010100; A=32'hffffffff; B=32'd2; Q_soll=32'h3fffffff; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 67: 
        S=6'b010101; A=32'b1010; B=32'd1; Q_soll=32'b101; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 68: 
        S=6'b010101; A=32'hffffffff; B=32'd2; Q_soll=32'h3fffffff; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 69: 
        S=6'b110100; A=32'b1010; B=32'd1; Q_soll=32'b101; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 70: 
        S=6'b110100; A=32'hffffffff; B=32'd2; Q_soll=32'hffffffff; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 71: 
        S=6'b110101; A=32'b1010; B=32'd1; Q_soll=32'b101; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 72: 
        S=6'b110101; A=32'hffffffff; B=32'd2; Q_soll=32'hffffffff; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 73: 
        S=6'b001000; A=32'd25; B=32'd27; Q_soll=32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 74: 
        S=6'b001000; A=32'd105; B=32'd0; Q_soll=32'd0; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 75: 
        S=6'b001000; A=-32'd5; B=-32'd4; Q_soll=32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 76: 
        S=6'b001000; A=-32'd20; B=32'd1; Q_soll=32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 77: 
        S=6'b001000; A=32'd0; B=-32'd3; Q_soll=32'd0; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 78: 
        S=6'b101000; A=32'd0; B=32'd0; Q_soll=32'd0; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 79: 
        S=6'b001001; A=32'd25; B=32'd27; Q_soll=32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 80: 
        S=6'b001001; A=32'd105; B=32'd0; Q_soll=32'd0; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 81: 
        S=6'b001001; A=-32'd5; B=-32'd4; Q_soll=32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 82: 
        S=6'b001001; A=-32'd20; B=32'd1; Q_soll=32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 83: 
        S=6'b001001; A=32'd0; B=-32'd3; Q_soll=32'd0; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 84: 
        S=6'b101001; A=32'd0; B=32'd0; Q_soll=32'd0; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 85: 
        S=6'b001100; A=32'd0; B=32'd2; Q_soll=32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 86: 
        S=6'b001100; A=32'd5; B=32'd4; Q_soll=32'd0; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 87: 
        S=6'b101100; A=32'd0; B=32'd0; Q_soll=32'd0; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 88: 
        S=6'b001101; A=32'd0; B=32'd2; Q_soll=32'd1; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 89: 
        S=6'b001101; A=32'd5; B=32'd4; Q_soll=32'd0; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
        
        //Testmuster 90: 
        S=6'b101101; A=32'd0; B=32'd0; Q_soll=32'd0; CMP_soll=1'bx; #10;
        if (CMP != CMP_soll || Q != Q_soll) $finish;
     
        $finish;  
    end
endmodule