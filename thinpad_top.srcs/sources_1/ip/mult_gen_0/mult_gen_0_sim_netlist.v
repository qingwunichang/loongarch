// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Fri Aug 16 13:04:01 2024
// Host        : LAPTOP-476JT8H0 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top mult_gen_0 -prefix
//               mult_gen_0_ mult_gen_0_sim_netlist.v
// Design      : mult_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_gen_0,mult_gen_v12_0_16,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_16,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module mult_gen_0
   (A,
    B,
    P);
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [31:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [31:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [31:0]P;

  wire [31:0]A;
  wire [31:0]B;
  wire [31:0]P;
  wire [47:0]NLW_U0_PCASC_UNCONNECTED;
  wire [1:0]NLW_U0_ZERO_DETECT_UNCONNECTED;

  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "32" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "0" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "31" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_gen_0_mult_gen_v12_0_16 U0
       (.A(A),
        .B(B),
        .CE(1'b1),
        .CLK(1'b1),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "32" *) (* C_B_TYPE = "0" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "32" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "0" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "1" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "31" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* downgradeipidentifiedwarnings = "yes" *) 
module mult_gen_0_mult_gen_v12_0_16
   (CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);
  input CLK;
  input [31:0]A;
  input [31:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [31:0]P;
  output [47:0]PCASC;

  wire \<const0> ;
  wire [31:0]A;
  wire [31:0]B;
  wire [31:0]P;
  wire [47:0]NLW_i_mult_PCASC_UNCONNECTED;
  wire [1:0]NLW_i_mult_ZERO_DETECT_UNCONNECTED;

  assign PCASC[47] = \<const0> ;
  assign PCASC[46] = \<const0> ;
  assign PCASC[45] = \<const0> ;
  assign PCASC[44] = \<const0> ;
  assign PCASC[43] = \<const0> ;
  assign PCASC[42] = \<const0> ;
  assign PCASC[41] = \<const0> ;
  assign PCASC[40] = \<const0> ;
  assign PCASC[39] = \<const0> ;
  assign PCASC[38] = \<const0> ;
  assign PCASC[37] = \<const0> ;
  assign PCASC[36] = \<const0> ;
  assign PCASC[35] = \<const0> ;
  assign PCASC[34] = \<const0> ;
  assign PCASC[33] = \<const0> ;
  assign PCASC[32] = \<const0> ;
  assign PCASC[31] = \<const0> ;
  assign PCASC[30] = \<const0> ;
  assign PCASC[29] = \<const0> ;
  assign PCASC[28] = \<const0> ;
  assign PCASC[27] = \<const0> ;
  assign PCASC[26] = \<const0> ;
  assign PCASC[25] = \<const0> ;
  assign PCASC[24] = \<const0> ;
  assign PCASC[23] = \<const0> ;
  assign PCASC[22] = \<const0> ;
  assign PCASC[21] = \<const0> ;
  assign PCASC[20] = \<const0> ;
  assign PCASC[19] = \<const0> ;
  assign PCASC[18] = \<const0> ;
  assign PCASC[17] = \<const0> ;
  assign PCASC[16] = \<const0> ;
  assign PCASC[15] = \<const0> ;
  assign PCASC[14] = \<const0> ;
  assign PCASC[13] = \<const0> ;
  assign PCASC[12] = \<const0> ;
  assign PCASC[11] = \<const0> ;
  assign PCASC[10] = \<const0> ;
  assign PCASC[9] = \<const0> ;
  assign PCASC[8] = \<const0> ;
  assign PCASC[7] = \<const0> ;
  assign PCASC[6] = \<const0> ;
  assign PCASC[5] = \<const0> ;
  assign PCASC[4] = \<const0> ;
  assign PCASC[3] = \<const0> ;
  assign PCASC[2] = \<const0> ;
  assign PCASC[1] = \<const0> ;
  assign PCASC[0] = \<const0> ;
  assign ZERO_DETECT[1] = \<const0> ;
  assign ZERO_DETECT[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "32" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "0" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "31" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_gen_0_mult_gen_v12_0_16_viv i_mult
       (.A(A),
        .B(B),
        .CE(1'b0),
        .CLK(1'b1),
        .P(P),
        .PCASC(NLW_i_mult_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_i_mult_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2019.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
HPMPLvpmoX7LOmPj78BMT9X1rCnPz6PdhVGZQ307N9haGfAdMGVirvGR3e0Glyn2ieoWqXA6qOQL
t0xn28+h0g==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
Nxv/BnutRgdmHnLyK7kvDGjm7WGfFKW2mxQ6xUKF14zS4ziz5pSV0ueW4VqAzUyEPsErIAEuyV6F
m5KCqRBB197Q2NbZa7O7tdAqboX6tPAJzbB6u4U/MmNS1AQcSgtfj5srMbdBzDa5pR4V3HrI0MRj
0xhV1BWf725FYPP4av0=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
F5KGJgEDQsX2btdjtRUlSmNtuyodIhGXEa3/AXv1Y7qgSO8gknBfiqj5HcIaVA9b4npQpDnNcmq+
1ONAqLeLhdOm9TES+GsTAkh/lClvl89bzfqgOV33iqwQHYIHwSsWMRXT9JSUx+YWu+g6xKpT1Ycn
8BCPsq4QUJIqL6W16fheEHB/lkMgnespIWEYJJG6R6zvv2zG8GiU6cG8zHrRjdvAj8kOkhmiMvSd
YjGXJSMfjw7ojCPSUF+nb6WWhUEmoMA/6lgSVaXRm00YHSZ09k7rKTJWSXFSpTmkL2WOsQhNS0ek
jdTK2KF5K6z2YOK4zkfHgZ+fB0KJyANaLLJH/Q==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lFuQXeJ0hi7qnIKAR+37XCSOwp8bGLukonngcICceOVpL87+rxvhP5TyNJ/zXpAWDF0BaRYlGr7d
isPiUStrvUthNyOqCr4vFZyhCdY8n+Mrv3OCvLoLQSarxVXbaKbXb0tPsXJCUdXTrCt9mr5x0Nda
6DAI8FBPlFMAiqnFXnYMwlUiSlkNWUpInuNw7+1eD8kUdckEUV1PDwZ0yjpFqMokMH9oJjN6z0Yy
65D8Tqo288ZMfZQuIimjski+X6EK157XbpyuoZIuYLJ7j6oaATdintgfZpgGzVvhCZtMbx6/SJtR
efW5vLBGiGs7rPBPE2T8fosHGOvmeC9QBSj8Ww==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Q8VVvHzTNgU3tZr4+8ia7ylST+kbNPWskONHDOT1dTkB7cHZIAWyzXpQZPuEgk2wJq21PoqmVlG9
t08IYzkfC8vYQ2LRf2Co3SXc7p3gF2OFMC68J9Nf9D+/PXJCJy3QO4H8oO39l6bn8c56K2ARnK0R
mMIALbCWSBDGCWGQmXWZJ+xmDGs1KgTeiSW3bZRftWJ6K8l8BhMit8BLOY2Mi3jJ0WRhN8kKd6JT
D4NU1jTZT6jEtmI7Gnj/AXG6auTqDPHsVQzf+ZzBsLTfw83CFoO70xM997L5cZXlqz8fEDmxezkr
wWxPwJbJeVkRV3tUxlo2Bs2x1uVkXQeNVMI8jg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
oUeTLA0HA2uKORUHo1HidNC3lw54gxwlLUkv28qRPv1pz7AEVUbIJ7wsyu2Scju+EkC2Ivi8HbBn
jxkeqRDTAwAbAqIKnY3AdyfojN9Hb8SMLcLnpWLLCpb6E0vwA09r7uqKRZ8wYAgT9CPFvzpQ3zKt
9DTLgQ3rZtFxx2nfCug=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Fayrlym1l14Y48yZ195XboT9ZQmp/mAzUyHby3Y9qJTzDF+m6mRQ/ZbebObo8bu4VAm45JeETPx1
YI4UZNOK4IqKv0BZsAlzUfAYAmqmkmIJYbn2gWUCwXyKX5AoA4ONnlxEHxzZhqtsmEXvxwTEs25/
R7iLzeoMfmwwNHgPNQkteiR4zDlB76CYmgu6EOSUX5Nnitq1oh7qRuU8WqWN7lLfgIC6T7qNHwGD
RPze2yiP06fSG45jPrOn2fvBX9SRbUXjNtiFgmqim4anwJU46v7y3ubit/I6giZhz5PJMZfkDaFX
ag+uCMq4Q8ZEolqMBmjUjat86BdVd4Nmr0yUaA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kIpxh3qIIkWUg8aLJSPKvKhKTPFH7T8fisti5RtNaftS7xh3KDsGLYnF1lYhH2RVXgzbdaVqvtED
5QJazVo6wUFI91xgFeOR5jX+Ny5UBUX2MngsK+UZyZg5+EdtSiDtiJNtQqgjq1Rn+XQCGF3xP80n
7YvuVMbgRHCAfWrWw7ZJ7Y3raRzeIkx+koPFio7XnC+QdRJ0ItO1YtQgF4Sg1Ihr5TH8/RrNn903
kPa+anH9spo3SFCf2Ts11UXAGLdIBmOLMtEAKjjCUbtmjGSeSc0gn2q2I+xRTFcegLevlr/iuLTw
3lFndBAoW40xOiCDjWZ6Rz7J+jZhsRl3D0Bhwg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
JTuv/xYw3/fNsgOcXDR/uPaWt6Uh5S5WV8Ktl765UEViGurfLyaYH9mky+HMLsSflN1dMsQdKBV4
+tSV/CkbmuwjOD069IHOpOLOSOfpQVSjNprsfpvJVQOzVvi6hHqz23QHN4G06EI2FKouvrjPmmBE
tzsTeTAmiDxT31Ys2Wt6OLmrFD765KM5r9m8ovVuLwQdj/tSbXhynbWAY4o4hIhXVwAttHNbHMSv
pBBWzHDT1JMNLmrRaRBq0+vaTu4WQxfLsNkvB6zjHBCljp1PlABp3uBjWyYuZk3XopQgEBszG05r
+7lID9nNBmOMepp/u5CeEK9dNasi+QWioaw+tA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
476+kMxH1fr5vG2Zw5FxO2kTdiv0AzwsgCTbPDm+1y7lQwaUC8xOhacK18AXyIY2emzSDDqjBMKJ
7kJMnV6DGeNORJNgFnqmkElbWZcu94sahjgLCMDK/zKpmwqLsJR9EvY8TT6IrPE1jVGVFeKi6k86
o/G5Ll7SoDh9Figes4KsUV7FcvQtWI9Y8zUyucX+NxiPLLge4/m5+BuSc2wOdfDEex0KT8GuDQaA
MLiWbCDZvuME24w+Sg3FeWLUZoGQdNJKIKfXvFqEn0uwiQy77RSNLePJQ6GzuPYUWuimK8IraWYT
VXGzpqltE4vS9s3wwmctGJIV0GfUsgF8OJgkVQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 17248)
`pragma protect data_block
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
LzxDXEQBwb2TgnQ=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
