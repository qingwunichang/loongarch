module BridgesCtrlChiselToVerilog(
  input         clock,
  input         reset,
  input         io_ceIF,
  input         io_weIF,
  input  [3:0]  io_bselIF,
  input  [31:0] io_vaddrIF,
  input  [31:0] io_wdataIF,
  output [31:0] io_rdataIF,
  output        io_doneIF,
  input         io_ceMEM,
  input         io_weMEM,
  input  [3:0]  io_bselMEM,
  input  [31:0] io_vaddrMEM,
  input  [31:0] io_wdataMEM,
  output [31:0] io_rdataMEM,
  output        io_doneMEM,
  input  [31:0] io_baseRam_rdata,
  output        io_baseRam_ce,
  output        io_baseRam_we,
  output [3:0]  io_baseRam_bsel,
  output [19:0] io_baseRam_paddr,
  output [31:0] io_baseRam_wdata,
  input         io_baseRam_done,
  input         io_baseRam_allowIn,
  input  [31:0] io_extRam_rdata,
  output        io_extRam_ce,
  output        io_extRam_we,
  output [3:0]  io_extRam_bsel,
  output [19:0] io_extRam_paddr,
  output [31:0] io_extRam_wdata,
  input         io_extRam_done,
  input         io_extRam_allowIn,
  input  [7:0]  io_uart_rdata,
  output        io_uart_ce,
  output        io_uart_we,
  output [31:0] io_uart_vaddr,
  output [7:0]  io_uart_wdata,
  input         io_uart_done,
  input         io_uart_allowIn
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] state; // @[BridgesCtrlChiselToVerilog.scala 60:22]
  reg [31:0] regVaddrIF; // @[BridgesCtrlChiselToVerilog.scala 68:27]
  reg [31:0] regVaddrMEM; // @[BridgesCtrlChiselToVerilog.scala 74:28]
  reg  uartAllowIn; // @[BridgesCtrlChiselToVerilog.scala 110:28]
  reg  baseRamAllowIn; // @[BridgesCtrlChiselToVerilog.scala 112:31]
  reg  extRamAllowIn; // @[BridgesCtrlChiselToVerilog.scala 114:30]
  wire  _ifLocation_T_4 = ~io_vaddrIF[27] & ~io_vaddrIF[22]; // @[BridgesCtrlChiselToVerilog.scala 124:42]
  wire  _ifLocation_T_8 = ~io_vaddrIF[27] & io_vaddrIF[22]; // @[BridgesCtrlChiselToVerilog.scala 124:81]
  wire [2:0] _ifLocation_T_9 = {_ifLocation_T_4,_ifLocation_T_8,1'h0}; // @[Cat.scala 31:58]
  wire  _memLocation_T_4 = ~io_vaddrMEM[27] & ~io_vaddrMEM[22]; // @[BridgesCtrlChiselToVerilog.scala 125:44]
  wire  _memLocation_T_8 = ~io_vaddrMEM[27] & io_vaddrMEM[22]; // @[BridgesCtrlChiselToVerilog.scala 125:85]
  wire [2:0] _memLocation_T_10 = {_memLocation_T_4,_memLocation_T_8,io_vaddrMEM[27]}; // @[Cat.scala 31:58]
  wire [2:0] ifLocation = 2'h0 == state ? _ifLocation_T_9 : 3'h4; // @[BridgesCtrlChiselToVerilog.scala 120:17 124:18]
  wire [2:0] memLocation = 2'h0 == state ? _memLocation_T_10 : 3'h2; // @[BridgesCtrlChiselToVerilog.scala 120:17 125:19]
  wire  _GEN_0 = io_vaddrMEM[27] & uartAllowIn & io_ceMEM; // @[BridgesCtrlChiselToVerilog.scala 136:50 138:26 93:14]
  wire  _GEN_1 = io_vaddrMEM[27] & uartAllowIn & io_weMEM; // @[BridgesCtrlChiselToVerilog.scala 136:50 139:26 94:14]
  wire [31:0] _GEN_2 = io_vaddrMEM[27] & uartAllowIn ? io_vaddrMEM : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 136:50 140:29 95:17]
  wire [7:0] _GEN_3 = io_vaddrMEM[27] & uartAllowIn ? io_wdataMEM[7:0] : 8'h0; // @[BridgesCtrlChiselToVerilog.scala 136:50 141:29 96:17]
  wire [1:0] _GEN_4 = io_vaddrMEM[27] & uartAllowIn ? 2'h2 : state; // @[BridgesCtrlChiselToVerilog.scala 136:50 142:21 60:22]
  wire  _GEN_5 = _memLocation_T_4 & baseRamAllowIn & io_ceMEM; // @[BridgesCtrlChiselToVerilog.scala 144:72 146:29 83:17]
  wire  _GEN_6 = _memLocation_T_4 & baseRamAllowIn & io_weMEM; // @[BridgesCtrlChiselToVerilog.scala 144:72 147:29 84:17]
  wire [3:0] _GEN_7 = _memLocation_T_4 & baseRamAllowIn ? io_bselMEM : 4'h0; // @[BridgesCtrlChiselToVerilog.scala 144:72 148:31 85:19]
  wire [19:0] _GEN_8 = _memLocation_T_4 & baseRamAllowIn ? io_vaddrMEM[21:2] : 20'h0; // @[BridgesCtrlChiselToVerilog.scala 144:72 149:32 86:20]
  wire [31:0] _GEN_9 = _memLocation_T_4 & baseRamAllowIn ? io_wdataMEM : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 144:72 150:32 87:20]
  wire [1:0] _GEN_10 = _memLocation_T_4 & baseRamAllowIn ? 2'h2 : _GEN_4; // @[BridgesCtrlChiselToVerilog.scala 144:72 151:21]
  wire  _GEN_11 = _memLocation_T_8 & extRamAllowIn & io_ceMEM; // @[BridgesCtrlChiselToVerilog.scala 153:72 155:28 88:16]
  wire  _GEN_12 = _memLocation_T_8 & extRamAllowIn & io_weMEM; // @[BridgesCtrlChiselToVerilog.scala 153:72 156:28 89:16]
  wire [3:0] _GEN_13 = _memLocation_T_8 & extRamAllowIn ? io_bselMEM : 4'h0; // @[BridgesCtrlChiselToVerilog.scala 153:72 157:30 90:18]
  wire [19:0] _GEN_14 = _memLocation_T_8 & extRamAllowIn ? io_vaddrMEM[21:2] : 20'h0; // @[BridgesCtrlChiselToVerilog.scala 153:72 158:31 91:19]
  wire [31:0] _GEN_15 = _memLocation_T_8 & extRamAllowIn ? io_wdataMEM : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 153:72 159:31 92:19]
  wire  _GEN_17 = _ifLocation_T_4 & baseRamAllowIn & io_ceIF; // @[BridgesCtrlChiselToVerilog.scala 164:71 166:29 83:17]
  wire  _GEN_18 = _ifLocation_T_4 & baseRamAllowIn & io_weIF; // @[BridgesCtrlChiselToVerilog.scala 164:71 167:29 84:17]
  wire [3:0] _GEN_19 = _ifLocation_T_4 & baseRamAllowIn ? io_bselIF : 4'h0; // @[BridgesCtrlChiselToVerilog.scala 164:71 168:31 85:19]
  wire [19:0] _GEN_20 = _ifLocation_T_4 & baseRamAllowIn ? io_vaddrIF[21:2] : 20'h0; // @[BridgesCtrlChiselToVerilog.scala 164:71 169:32 86:20]
  wire [31:0] _GEN_21 = _ifLocation_T_4 & baseRamAllowIn ? io_wdataIF : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 164:71 170:32 87:20]
  wire [1:0] _GEN_22 = _ifLocation_T_4 & baseRamAllowIn ? 2'h1 : state; // @[BridgesCtrlChiselToVerilog.scala 164:71 171:21 60:22]
  wire  _GEN_23 = _ifLocation_T_8 & extRamAllowIn & io_ceIF; // @[BridgesCtrlChiselToVerilog.scala 174:69 176:28 88:16]
  wire  _GEN_24 = _ifLocation_T_8 & extRamAllowIn & io_weIF; // @[BridgesCtrlChiselToVerilog.scala 174:69 177:28 89:16]
  wire [3:0] _GEN_25 = _ifLocation_T_8 & extRamAllowIn ? io_bselIF : 4'h0; // @[BridgesCtrlChiselToVerilog.scala 174:69 178:30 90:18]
  wire [19:0] _GEN_26 = _ifLocation_T_8 & extRamAllowIn ? io_vaddrIF[21:2] : 20'h0; // @[BridgesCtrlChiselToVerilog.scala 174:69 179:31 91:19]
  wire [31:0] _GEN_27 = _ifLocation_T_8 & extRamAllowIn ? io_wdataIF : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 174:69 180:31 92:19]
  wire [1:0] _GEN_28 = _ifLocation_T_8 & extRamAllowIn ? 2'h1 : _GEN_22; // @[BridgesCtrlChiselToVerilog.scala 174:69 181:21]
  wire  _T_36 = memLocation == 3'h1; // @[BridgesCtrlChiselToVerilog.scala 188:30]
  wire  _GEN_29 = memLocation == 3'h1 & io_ceMEM; // @[BridgesCtrlChiselToVerilog.scala 188:44 189:28 93:14]
  wire  _GEN_30 = memLocation == 3'h1 & io_weMEM; // @[BridgesCtrlChiselToVerilog.scala 188:44 190:28 94:14]
  wire [31:0] _GEN_31 = memLocation == 3'h1 ? io_vaddrMEM : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 188:44 191:31 95:17]
  wire [7:0] _GEN_32 = memLocation == 3'h1 ? io_wdataMEM[7:0] : 8'h0; // @[BridgesCtrlChiselToVerilog.scala 188:44 192:31 96:17]
  wire  _io_baseRam_ce_T = memLocation == 3'h4; // @[BridgesCtrlChiselToVerilog.scala 197:58]
  wire  _io_baseRam_ce_T_1 = ifLocation == 3'h4; // @[BridgesCtrlChiselToVerilog.scala 198:45]
  wire  _io_baseRam_ce_T_3 = _io_baseRam_ce_T ? io_ceMEM : _io_baseRam_ce_T_1 & io_ceIF; // @[Mux.scala 101:16]
  wire  _io_baseRam_we_T_3 = _io_baseRam_ce_T ? io_weMEM : _io_baseRam_ce_T_1 & io_weIF; // @[Mux.scala 101:16]
  wire [3:0] _io_baseRam_bsel_T_2 = _io_baseRam_ce_T_1 ? io_bselIF : 4'h0; // @[Mux.scala 101:16]
  wire [3:0] _io_baseRam_bsel_T_3 = _io_baseRam_ce_T ? io_bselMEM : _io_baseRam_bsel_T_2; // @[Mux.scala 101:16]
  wire [19:0] _io_baseRam_paddr_T_6 = _io_baseRam_ce_T_1 ? io_vaddrIF[21:2] : 20'h0; // @[Mux.scala 101:16]
  wire [19:0] _io_baseRam_paddr_T_7 = _io_baseRam_ce_T ? io_vaddrMEM[21:2] : _io_baseRam_paddr_T_6; // @[Mux.scala 101:16]
  wire [31:0] _io_baseRam_wdata_T_2 = _io_baseRam_ce_T_1 ? io_wdataIF : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _io_baseRam_wdata_T_3 = _io_baseRam_ce_T ? io_wdataMEM : _io_baseRam_wdata_T_2; // @[Mux.scala 101:16]
  wire  _io_extRam_ce_T = memLocation == 3'h2; // @[BridgesCtrlChiselToVerilog.scala 208:57]
  wire  _io_extRam_ce_T_1 = ifLocation == 3'h2; // @[BridgesCtrlChiselToVerilog.scala 209:45]
  wire  _io_extRam_ce_T_3 = _io_extRam_ce_T ? io_ceMEM : _io_extRam_ce_T_1 & io_ceIF; // @[Mux.scala 101:16]
  wire  _io_extRam_we_T_3 = _io_extRam_ce_T ? io_weMEM : _io_extRam_ce_T_1 & io_weIF; // @[Mux.scala 101:16]
  wire [3:0] _io_extRam_bsel_T_2 = _io_extRam_ce_T_1 ? io_bselIF : 4'h0; // @[Mux.scala 101:16]
  wire [3:0] _io_extRam_bsel_T_3 = _io_extRam_ce_T ? io_bselMEM : _io_extRam_bsel_T_2; // @[Mux.scala 101:16]
  wire [19:0] _io_extRam_paddr_T_6 = _io_extRam_ce_T_1 ? io_vaddrIF[21:2] : 20'h0; // @[Mux.scala 101:16]
  wire [19:0] _io_extRam_paddr_T_7 = _io_extRam_ce_T ? io_vaddrMEM[21:2] : _io_extRam_paddr_T_6; // @[Mux.scala 101:16]
  wire [31:0] _io_extRam_wdata_T_2 = _io_extRam_ce_T_1 ? io_wdataIF : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _io_extRam_wdata_T_3 = _io_extRam_ce_T ? io_wdataMEM : _io_extRam_wdata_T_2; // @[Mux.scala 101:16]
  wire  _state_T_3 = _io_extRam_ce_T & extRamAllowIn; // @[BridgesCtrlChiselToVerilog.scala 220:49]
  wire  _state_T_4 = _io_baseRam_ce_T & baseRamAllowIn | _state_T_3; // @[BridgesCtrlChiselToVerilog.scala 219:74]
  wire  _state_T_6 = _T_36 & uartAllowIn; // @[BridgesCtrlChiselToVerilog.scala 221:49]
  wire  _state_T_7 = _state_T_4 | _state_T_6; // @[BridgesCtrlChiselToVerilog.scala 220:68]
  wire  _state_T_11 = _io_extRam_ce_T_1 & extRamAllowIn; // @[BridgesCtrlChiselToVerilog.scala 223:48]
  wire  _state_T_12 = _io_baseRam_ce_T_1 & baseRamAllowIn | _state_T_11; // @[BridgesCtrlChiselToVerilog.scala 222:69]
  wire  _state_T_13 = _state_T_7 & _state_T_12; // @[BridgesCtrlChiselToVerilog.scala 221:66]
  wire [1:0] _state_T_14 = _state_T_13 ? 2'h3 : 2'h0; // @[BridgesCtrlChiselToVerilog.scala 219:25]
  wire  _GEN_33 = io_ceIF & io_ceMEM & ifLocation != memLocation & _GEN_29; // @[BridgesCtrlChiselToVerilog.scala 184:73 93:14]
  wire  _GEN_34 = io_ceIF & io_ceMEM & ifLocation != memLocation & _GEN_30; // @[BridgesCtrlChiselToVerilog.scala 184:73 94:14]
  wire [31:0] _GEN_35 = io_ceIF & io_ceMEM & ifLocation != memLocation ? _GEN_31 : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 184:73 95:17]
  wire [7:0] _GEN_36 = io_ceIF & io_ceMEM & ifLocation != memLocation ? _GEN_32 : 8'h0; // @[BridgesCtrlChiselToVerilog.scala 184:73 96:17]
  wire  _GEN_37 = io_ceIF & io_ceMEM & ifLocation != memLocation & _io_baseRam_ce_T_3; // @[BridgesCtrlChiselToVerilog.scala 184:73 197:27 83:17]
  wire  _GEN_38 = io_ceIF & io_ceMEM & ifLocation != memLocation & _io_baseRam_we_T_3; // @[BridgesCtrlChiselToVerilog.scala 184:73 199:27 84:17]
  wire [3:0] _GEN_39 = io_ceIF & io_ceMEM & ifLocation != memLocation ? _io_baseRam_bsel_T_3 : 4'h0; // @[BridgesCtrlChiselToVerilog.scala 184:73 201:29 85:19]
  wire [19:0] _GEN_40 = io_ceIF & io_ceMEM & ifLocation != memLocation ? _io_baseRam_paddr_T_7 : 20'h0; // @[BridgesCtrlChiselToVerilog.scala 184:73 203:30 86:20]
  wire [31:0] _GEN_41 = io_ceIF & io_ceMEM & ifLocation != memLocation ? _io_baseRam_wdata_T_3 : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 184:73 205:30 87:20]
  wire  _GEN_42 = io_ceIF & io_ceMEM & ifLocation != memLocation & _io_extRam_ce_T_3; // @[BridgesCtrlChiselToVerilog.scala 184:73 208:26 88:16]
  wire  _GEN_43 = io_ceIF & io_ceMEM & ifLocation != memLocation & _io_extRam_we_T_3; // @[BridgesCtrlChiselToVerilog.scala 184:73 210:26 89:16]
  wire [3:0] _GEN_44 = io_ceIF & io_ceMEM & ifLocation != memLocation ? _io_extRam_bsel_T_3 : 4'h0; // @[BridgesCtrlChiselToVerilog.scala 184:73 212:28 90:18]
  wire [19:0] _GEN_45 = io_ceIF & io_ceMEM & ifLocation != memLocation ? _io_extRam_paddr_T_7 : 20'h0; // @[BridgesCtrlChiselToVerilog.scala 184:73 214:29 91:19]
  wire [31:0] _GEN_46 = io_ceIF & io_ceMEM & ifLocation != memLocation ? _io_extRam_wdata_T_3 : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 184:73 216:29 92:19]
  wire [1:0] _GEN_47 = io_ceIF & io_ceMEM & ifLocation != memLocation ? _state_T_14 : state; // @[BridgesCtrlChiselToVerilog.scala 184:73 219:19 60:22]
  wire  _GEN_48 = io_ceIF & ~io_ceMEM ? _GEN_17 : _GEN_37; // @[BridgesCtrlChiselToVerilog.scala 162:41]
  wire  _GEN_49 = io_ceIF & ~io_ceMEM ? _GEN_18 : _GEN_38; // @[BridgesCtrlChiselToVerilog.scala 162:41]
  wire [3:0] _GEN_50 = io_ceIF & ~io_ceMEM ? _GEN_19 : _GEN_39; // @[BridgesCtrlChiselToVerilog.scala 162:41]
  wire [19:0] _GEN_51 = io_ceIF & ~io_ceMEM ? _GEN_20 : _GEN_40; // @[BridgesCtrlChiselToVerilog.scala 162:41]
  wire [31:0] _GEN_52 = io_ceIF & ~io_ceMEM ? _GEN_21 : _GEN_41; // @[BridgesCtrlChiselToVerilog.scala 162:41]
  wire  _GEN_54 = io_ceIF & ~io_ceMEM ? _GEN_23 : _GEN_42; // @[BridgesCtrlChiselToVerilog.scala 162:41]
  wire  _GEN_55 = io_ceIF & ~io_ceMEM ? _GEN_24 : _GEN_43; // @[BridgesCtrlChiselToVerilog.scala 162:41]
  wire [3:0] _GEN_56 = io_ceIF & ~io_ceMEM ? _GEN_25 : _GEN_44; // @[BridgesCtrlChiselToVerilog.scala 162:41]
  wire [19:0] _GEN_57 = io_ceIF & ~io_ceMEM ? _GEN_26 : _GEN_45; // @[BridgesCtrlChiselToVerilog.scala 162:41]
  wire [31:0] _GEN_58 = io_ceIF & ~io_ceMEM ? _GEN_27 : _GEN_46; // @[BridgesCtrlChiselToVerilog.scala 162:41]
  wire  _GEN_59 = io_ceIF & ~io_ceMEM ? 1'h0 : _GEN_33; // @[BridgesCtrlChiselToVerilog.scala 162:41 93:14]
  wire  _GEN_60 = io_ceIF & ~io_ceMEM ? 1'h0 : _GEN_34; // @[BridgesCtrlChiselToVerilog.scala 162:41 94:14]
  wire [31:0] _GEN_61 = io_ceIF & ~io_ceMEM ? 32'h0 : _GEN_35; // @[BridgesCtrlChiselToVerilog.scala 162:41 95:17]
  wire [7:0] _GEN_62 = io_ceIF & ~io_ceMEM ? 8'h0 : _GEN_36; // @[BridgesCtrlChiselToVerilog.scala 162:41 96:17]
  wire  _GEN_63 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_0 : _GEN_59; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire  _GEN_64 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_1 : _GEN_60; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire [31:0] _GEN_65 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_2 : _GEN_61; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire [7:0] _GEN_66 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_3 : _GEN_62; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire  _GEN_68 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_5 : _GEN_48; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire  _GEN_69 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_6 : _GEN_49; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire [3:0] _GEN_70 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_7 : _GEN_50; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire [19:0] _GEN_71 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_8 : _GEN_51; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire [31:0] _GEN_72 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_9 : _GEN_52; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire  _GEN_73 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_11 : _GEN_54; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire  _GEN_74 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_12 : _GEN_55; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire [3:0] _GEN_75 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_13 : _GEN_56; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire [19:0] _GEN_76 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_14 : _GEN_57; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire [31:0] _GEN_77 = io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation ? _GEN_15 : _GEN_58; // @[BridgesCtrlChiselToVerilog.scala 132:93]
  wire  _io_doneIF_T_1 = ~regVaddrIF[27]; // @[BridgesCtrlChiselToVerilog.scala 233:44]
  wire  _io_doneIF_T_5 = io_baseRam_done & (~regVaddrIF[27] & ~regVaddrIF[22]); // @[BridgesCtrlChiselToVerilog.scala 233:39]
  wire  _io_doneIF_T_10 = io_extRam_done & (_io_doneIF_T_1 & regVaddrIF[22]); // @[BridgesCtrlChiselToVerilog.scala 234:38]
  wire  _io_doneIF_T_11 = io_baseRam_done & (~regVaddrIF[27] & ~regVaddrIF[22]) | _io_doneIF_T_10; // @[BridgesCtrlChiselToVerilog.scala 233:80]
  wire [31:0] _io_rdataIF_T_11 = _io_doneIF_T_10 ? io_extRam_rdata : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _io_rdataIF_T_12 = _io_doneIF_T_5 ? io_baseRam_rdata : _io_rdataIF_T_11; // @[Mux.scala 101:16]
  wire  _io_doneMEM_T_1 = ~regVaddrMEM[27]; // @[BridgesCtrlChiselToVerilog.scala 248:42]
  wire  _io_doneMEM_T_5 = io_baseRam_done & (~regVaddrMEM[27] & ~regVaddrMEM[22]); // @[BridgesCtrlChiselToVerilog.scala 248:39]
  wire  _io_doneMEM_T_10 = io_extRam_done & (_io_doneMEM_T_1 & regVaddrMEM[22]); // @[BridgesCtrlChiselToVerilog.scala 249:38]
  wire  _io_doneMEM_T_11 = io_baseRam_done & (~regVaddrMEM[27] & ~regVaddrMEM[22]) | _io_doneMEM_T_10; // @[BridgesCtrlChiselToVerilog.scala 248:80]
  wire  _io_doneMEM_T_13 = io_uart_done & regVaddrMEM[27]; // @[BridgesCtrlChiselToVerilog.scala 250:36]
  wire  _io_doneMEM_T_14 = _io_doneMEM_T_11 | _io_doneMEM_T_13; // @[BridgesCtrlChiselToVerilog.scala 249:79]
  wire  _state_T_16 = io_doneIF & io_doneMEM; // @[BridgesCtrlChiselToVerilog.scala 252:29]
  wire  _state_T_18 = io_doneIF & ~io_doneMEM; // @[BridgesCtrlChiselToVerilog.scala 253:29]
  wire  _state_T_20 = ~io_doneIF & io_doneMEM; // @[BridgesCtrlChiselToVerilog.scala 254:30]
  wire [1:0] _state_T_21 = _state_T_20 ? 2'h1 : 2'h3; // @[Mux.scala 101:16]
  wire [1:0] _state_T_22 = _state_T_18 ? 2'h2 : _state_T_21; // @[Mux.scala 101:16]
  wire [1:0] _state_T_23 = _state_T_16 ? 2'h0 : _state_T_22; // @[Mux.scala 101:16]
  wire [23:0] _io_rdataMEM_T_4 = io_uart_rdata[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _io_rdataMEM_T_5 = {_io_rdataMEM_T_4,io_uart_rdata}; // @[BridgesCtrlChiselToVerilog.scala 257:75]
  wire [31:0] _io_rdataMEM_T_17 = _io_doneMEM_T_10 ? io_extRam_rdata : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _io_rdataMEM_T_18 = _io_doneMEM_T_5 ? io_baseRam_rdata : _io_rdataMEM_T_17; // @[Mux.scala 101:16]
  wire [31:0] _io_rdataMEM_T_19 = _io_doneMEM_T_13 ? _io_rdataMEM_T_5 : _io_rdataMEM_T_18; // @[Mux.scala 101:16]
  wire [1:0] _state_T_24 = io_doneMEM ? 2'h0 : 2'h2; // @[BridgesCtrlChiselToVerilog.scala 274:23]
  wire  _GEN_78 = 2'h2 == state & _io_doneMEM_T_14; // @[BridgesCtrlChiselToVerilog.scala 120:17 270:22 82:14]
  wire [1:0] _GEN_79 = 2'h2 == state ? _state_T_24 : state; // @[BridgesCtrlChiselToVerilog.scala 120:17 274:17 60:22]
  wire [31:0] _GEN_80 = 2'h2 == state ? _io_rdataMEM_T_19 : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 120:17 276:23 98:15]
  wire  _GEN_81 = 2'h3 == state & _io_doneIF_T_11; // @[BridgesCtrlChiselToVerilog.scala 120:17 245:19 81:13]
  wire  _GEN_82 = 2'h3 == state ? _io_doneMEM_T_14 : _GEN_78; // @[BridgesCtrlChiselToVerilog.scala 120:17 248:20]
  wire [31:0] _GEN_84 = 2'h3 == state ? _io_rdataMEM_T_19 : _GEN_80; // @[BridgesCtrlChiselToVerilog.scala 120:17 256:21]
  wire [31:0] _GEN_85 = 2'h3 == state ? _io_rdataIF_T_12 : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 120:17 261:20 97:14]
  wire  _GEN_86 = 2'h1 == state ? io_baseRam_done & (~regVaddrIF[27] & ~regVaddrIF[22]) | _io_doneIF_T_10 : _GEN_81; // @[BridgesCtrlChiselToVerilog.scala 120:17 233:19]
  wire [31:0] _GEN_88 = 2'h1 == state ? _io_rdataIF_T_12 : _GEN_85; // @[BridgesCtrlChiselToVerilog.scala 120:17 236:20]
  wire  _GEN_89 = 2'h1 == state ? 1'h0 : _GEN_82; // @[BridgesCtrlChiselToVerilog.scala 120:17 82:14]
  wire [31:0] _GEN_90 = 2'h1 == state ? 32'h0 : _GEN_84; // @[BridgesCtrlChiselToVerilog.scala 120:17 98:15]
  assign io_rdataIF = 2'h0 == state ? 32'h0 : _GEN_88; // @[BridgesCtrlChiselToVerilog.scala 120:17 97:14]
  assign io_doneIF = 2'h0 == state ? 1'h0 : _GEN_86; // @[BridgesCtrlChiselToVerilog.scala 120:17 81:13]
  assign io_rdataMEM = 2'h0 == state ? 32'h0 : _GEN_90; // @[BridgesCtrlChiselToVerilog.scala 120:17 98:15]
  assign io_doneMEM = 2'h0 == state ? 1'h0 : _GEN_89; // @[BridgesCtrlChiselToVerilog.scala 120:17 82:14]
  assign io_baseRam_ce = 2'h0 == state & _GEN_68; // @[BridgesCtrlChiselToVerilog.scala 120:17 83:17]
  assign io_baseRam_we = 2'h0 == state & _GEN_69; // @[BridgesCtrlChiselToVerilog.scala 120:17 84:17]
  assign io_baseRam_bsel = 2'h0 == state ? _GEN_70 : 4'h0; // @[BridgesCtrlChiselToVerilog.scala 120:17 85:19]
  assign io_baseRam_paddr = 2'h0 == state ? _GEN_71 : 20'h0; // @[BridgesCtrlChiselToVerilog.scala 120:17 86:20]
  assign io_baseRam_wdata = 2'h0 == state ? _GEN_72 : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 120:17 87:20]
  assign io_extRam_ce = 2'h0 == state & _GEN_73; // @[BridgesCtrlChiselToVerilog.scala 120:17 88:16]
  assign io_extRam_we = 2'h0 == state & _GEN_74; // @[BridgesCtrlChiselToVerilog.scala 120:17 89:16]
  assign io_extRam_bsel = 2'h0 == state ? _GEN_75 : 4'h0; // @[BridgesCtrlChiselToVerilog.scala 120:17 90:18]
  assign io_extRam_paddr = 2'h0 == state ? _GEN_76 : 20'h0; // @[BridgesCtrlChiselToVerilog.scala 120:17 91:19]
  assign io_extRam_wdata = 2'h0 == state ? _GEN_77 : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 120:17 92:19]
  assign io_uart_ce = 2'h0 == state & _GEN_63; // @[BridgesCtrlChiselToVerilog.scala 120:17 93:14]
  assign io_uart_we = 2'h0 == state & _GEN_64; // @[BridgesCtrlChiselToVerilog.scala 120:17 94:14]
  assign io_uart_vaddr = 2'h0 == state ? _GEN_65 : 32'h0; // @[BridgesCtrlChiselToVerilog.scala 120:17 95:17]
  assign io_uart_wdata = 2'h0 == state ? _GEN_66 : 8'h0; // @[BridgesCtrlChiselToVerilog.scala 120:17 96:17]
  always @(posedge clock) begin
    if (reset) begin // @[BridgesCtrlChiselToVerilog.scala 60:22]
      state <= 2'h0; // @[BridgesCtrlChiselToVerilog.scala 60:22]
    end else if (2'h0 == state) begin // @[BridgesCtrlChiselToVerilog.scala 120:17]
      if (io_ceMEM & ~io_ceIF | io_ceMEM & io_ceIF & ifLocation == memLocation) begin // @[BridgesCtrlChiselToVerilog.scala 132:93]
        if (_memLocation_T_8 & extRamAllowIn) begin // @[BridgesCtrlChiselToVerilog.scala 153:72]
          state <= 2'h2; // @[BridgesCtrlChiselToVerilog.scala 160:21]
        end else begin
          state <= _GEN_10;
        end
      end else if (io_ceIF & ~io_ceMEM) begin // @[BridgesCtrlChiselToVerilog.scala 162:41]
        state <= _GEN_28;
      end else begin
        state <= _GEN_47;
      end
    end else if (2'h1 == state) begin // @[BridgesCtrlChiselToVerilog.scala 120:17]
      if (io_doneIF) begin // @[BridgesCtrlChiselToVerilog.scala 235:21]
        state <= 2'h0;
      end else begin
        state <= 2'h1;
      end
    end else if (2'h3 == state) begin // @[BridgesCtrlChiselToVerilog.scala 120:17]
      state <= _state_T_23; // @[BridgesCtrlChiselToVerilog.scala 251:15]
    end else begin
      state <= _GEN_79;
    end
    if (reset) begin // @[BridgesCtrlChiselToVerilog.scala 68:27]
      regVaddrIF <= 32'h0; // @[BridgesCtrlChiselToVerilog.scala 68:27]
    end else if (2'h0 == state) begin // @[BridgesCtrlChiselToVerilog.scala 120:17]
      regVaddrIF <= io_vaddrIF; // @[BridgesCtrlChiselToVerilog.scala 130:18]
    end else begin
      regVaddrIF <= 32'h0; // @[BridgesCtrlChiselToVerilog.scala 107:14]
    end
    if (reset) begin // @[BridgesCtrlChiselToVerilog.scala 74:28]
      regVaddrMEM <= 32'h0; // @[BridgesCtrlChiselToVerilog.scala 74:28]
    end else if (2'h0 == state) begin // @[BridgesCtrlChiselToVerilog.scala 120:17]
      regVaddrMEM <= io_vaddrMEM; // @[BridgesCtrlChiselToVerilog.scala 129:19]
    end else begin
      regVaddrMEM <= 32'h0; // @[BridgesCtrlChiselToVerilog.scala 102:15]
    end
    uartAllowIn <= reset | io_uart_allowIn; // @[BridgesCtrlChiselToVerilog.scala 110:{28,28} 111:15]
    baseRamAllowIn <= reset | io_baseRam_allowIn; // @[BridgesCtrlChiselToVerilog.scala 112:{31,31} 113:18]
    extRamAllowIn <= reset | io_extRam_allowIn; // @[BridgesCtrlChiselToVerilog.scala 114:{30,30} 115:17]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  state = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  regVaddrIF = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  regVaddrMEM = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  uartAllowIn = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  baseRamAllowIn = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  extRamAllowIn = _RAND_5[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
