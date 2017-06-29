module ForwardingUint( //包括转发以及数据相关无法转发时的阻塞判断
    input              clk,
    input              rst,
    input              stall,
    input      [55:0]  WB_out,
	input      [63:0]  IF_ID_bus_r, //两者是相同的
	input      [206:0] ID_EXE_bus_r,
	input      [179:0] EXE_MEM_bus_r,
	input      [141:0] MEM_WB_bus_r,
	output     [63:0]  IF_ID_bus_out,
	output     [206:0] ID_EXE_bus_out,
	output     [179:0] EXE_MEM_bus_out,
	output     [141:0] MEM_WB_bus_out,
    output             Q
	);


//ID_EXE_bus   
wire [4:0]  ID_EXE_rs;
wire [4:0]  ID_EXE_rt;
wire [4:0]  ID_EXE_rd;
wire        ID_EXE_cal_r;
wire        ID_EXE_cal_i;
wire        ID_EXE_store;
wire        ID_EXE_load;
wire        ID_EXE_jump;
wire        ID_EXE_mt;
wire [2:0]  ID_EXE_beq;
wire        ID_b_type;       //新增
wire        ID_b_zero;
wire        ID_EXE_mf;
wire        ID_EXE_lui;
wire 		ID_EXE_multiply;
wire 		ID_EXE_divide;
wire 		ID_EXE_sign_exe;
wire 		ID_EXE_mthi;
wire 		ID_EXE_mtlo;
wire [12:0] ID_EXE_alu_control;
wire [31:0] ID_EXE_alu_operand1;//outA
wire [31:0] ID_EXE_alu_operand2;//outB
wire [5:0]  ID_EXE_mem_control;
wire [31:0] ID_EXE_store_data;
wire 		ID_EXE_mfhi;
wire 		ID_EXE_mflo;
wire 		ID_EXE_mtc0;
wire 		ID_EXE_mfc0;
wire [7:0]  ID_EXE_cp0r_addr;
wire 		ID_EXE_syscall;
wire 		ID_EXE_break;
wire 		ID_EXE_eret;
wire        ID_EXE_rf_wen;
wire [4:0]  ID_EXE_rf_wdest;
wire [31:0] ID_EXE_pc;
wire        ID_EXE_inst_j_link;
wire [4:0]  sa;

assign {sa,                         //5
        ID_EXE_inst_j_link,         //1
        ID_EXE_rs,                  //5
        ID_EXE_rt,                  //5
        ID_EXE_rd,                  //5
        ID_EXE_cal_r,               //1
        ID_EXE_cal_i,               //1
        ID_EXE_store,               //1
        ID_EXE_load,                //1
        ID_EXE_jump,                //1
        ID_EXE_mt,                  //1
        ID_EXE_beq,                 //3
        ID_b_type,                  //1
        ID_b_zero,                  //1
        ID_EXE_mf,                  //1
        ID_EXE_lui,                 //1
        ID_EXE_multiply,            //1
		ID_EXE_divide,              //1
		ID_EXE_sign_exe,            //1
		ID_EXE_mthi,                //1
		ID_EXE_mtlo,                //1  
        ID_EXE_alu_control,         //13
        ID_EXE_alu_operand1,//A
        ID_EXE_alu_operand2,//B	
        ID_EXE_mem_control,
        ID_EXE_store_data,               		
        ID_EXE_mfhi,
        ID_EXE_mflo,                            		
        ID_EXE_mtc0,
        ID_EXE_mfc0,
        ID_EXE_cp0r_addr,
        ID_EXE_syscall,
        ID_EXE_break,
        ID_EXE_eret,    
        ID_EXE_rf_wen,
        ID_EXE_rf_wdest,                     		
        ID_EXE_pc} = ID_EXE_bus;  


//EXE_MEM
wire         EXE_MEM_cal_r;
wire         EXE_MEM_cal_i;
wire         EXE_MEM_store;
wire         EXE_MEM_load;
wire         EXE_MEM_jump;
wire         EXE_MEM_mt;
wire         EXE_MEM_mf;
wire         EXE_MEM_lui;
wire [4:0]   EXE_MEM_rs;
wire [4:0]   EXE_MEM_rt;
wire [4:0]   EXE_MEM_rd;
wire [5:0]   EXE_MEM_mem_control;
wire [31:0]  EXE_MEM_store_data; //MFRTM_Q
wire [31:0]  EXE_MEM_exe_result;
wire [31:0]  EXE_MEM_lo_result;
wire         EXE_MEM_hi_write;
wire         EXE_MEM_lo_write;
wire 		 EXE_MEM_mfhi;
wire 		 EXE_MEM_mflo;
wire 		 EXE_MEM_mtc0;
wire 		 EXE_MEM_mfc0;
wire [7:0]   EXE_MEM_cp0r_addr;
wire         EXE_MEM_syscall;
wire         EXE_MEM_eret;
wire         EXE_MEM_rf_wen;
wire [4:0]   EXE_MEM_rf_wdest;
wire [31:0]  EXE_MEM_pc;
wire         EXE_MEM_inst_j_link;        

assign {
        EXE_MEM_inst_j_link,  
        EXE_MEM_rs,
        EXE_MEM_rt,
        EXE_MEM_rd,
        EXE_MEM_cal_r,
        EXE_MEM_cal_i,
        EXE_MEM_store,
        EXE_MEM_load,
        EXE_MEM_jump,
        EXE_MEM_mt,
        EXE_MEM_mf,
        EXE_MEM_lui,
        EXE_MEM_mem_control,
        EXE_MEM_store_data,
        EXE_MEM_exe_result,
        EXE_MEM_lo_result,
        EXE_MEM_hi_write,
        EXE_MEM_lo_write,
        EXE_MEM_mfhi,
        EXE_MEM_mflo,
        EXE_MEM_mtc0,
        EXE_MEM_mfc0,
        EXE_MEM_cp0r_addr,
        EXE_MEM_syscall,
        EXE_MEM_eret,
        EXE_MEM_rf_wen,
        EXE_MEM_rf_wdest,
        EXE_MEM_pc         } = EXE_MEM_bus_r;  


//MEM_WB
wire wen;
wire [4:0]   MEM_WB_wdest;
wire [31:0]  MEM_WB_mem_result;
wire [31:0]  MEM_WB_lo_result;
wire         MEM_WB_hi_write;
wire         MEM_WB_lo_write;
wire		 MEM_WB_mfhi;
wire		 MEM_WB_mflo;
wire		 MEM_WB_mtc0;
wire		 MEM_WB_mfc0;
wire [7:0]   MEM_WB_cp0r_addr;
wire         MEM_WB_syscall;
wire         MEM_WB_eret;
wire [31:0]  MEM_WB_pc;
wire [4:0]   MEM_WB_rs;
wire [4:0]   MEM_WB_rt;
wire [4:0]   MEM_WB_rd;
wire         MEM_WB_cal_r;
wire         MEM_WB_cal_i;
wire         MEM_WB_store;
wire         MEM_WB_load;
wire         MEM_WB_jump;
wire         MEM_WB_mt;
wire         MEM_WB_mf;
wire         MEM_WB_lui;
wire         MEM_WB_inst_j_link;   


assign {    MEM_WB_inst_j_link,
            MEM_WB_rs,
            MEM_WB_rt,
            MEM_WB_rd,
            MEM_WB_cal_r,
            MEM_WB_cal_i,
            MEM_WB_store,
            MEM_WB_load,
            MEM_WB_jump,
            MEM_WB_mt,
            MEM_WB_mf,
            MEM_WB_lui,
            MEM_WB_wen,
            MEM_WB_wdest,
            MEM_WB_mem_result,
            MEM_WB_lo_result,
            MEM_WB_hi_write,
            MEM_WB_lo_write,
            MEM_WB_mfhi,
            MEM_WB_mflo,
            MEM_WB_mtc0,
            MEM_WB_mfc0,
            MEM_WB_cp0r_addr,
            MEM_WB_syscall,
            MEM_WB_eret,
            MEM_WB_pc}  = MEM_WB_bus_r;

wire       WB_cal_r;
wire       WB_cal_i;
wire       WB_store;
wire       WB_load;
wire       WB_jump;
wire       WB_mt;
wire       WB_mf;
wire       WB_lui;
wire [4:0] WB_rs;
wire [4:0] WB_rt;
wire [4:0] WB_rd;
wire       WB_inst_j_link;
wire [31:0]WB_Q;

assign {WB_Q,
        WB_inst_j_link,
        WB_cal_r,
        WB_cal_i,
        WB_store,
        WB_load,
        WB_jump,
        WB_mt,
        WB_mf,
        WB_lui,
        WB_rs,
        WB_rt,
        WB_rd  } = WB_out;

///////////////////////////////////////////////////////////////////////////////////////////////////
//ForwardingUint
wire [ 2:0] RSD,RTD;
wire [ 1:0] RSE,RTE;
wire        RTM;
wire RTEIR;
wire RSEIR;
wire RSDIR;

assign RTM = MEM_WB_store && WB_load           && MEM_WB_rt == WB_rt ? 1 :
             MEM_WB_store && WB_cal_r          && MEM_WB_rt == WB_rt ? 1 :
             MEM_WB_store && WB_mt             && MEM_WB_rt == WB_rt ? 1 :
             MEM_WB_store && WB_cal_i          && MEM_WB_rt == WB_rt ? 1 :
             MEM_WB_store && WB_lui            && MEM_WB_rt == WB_rt ? 1 :
             MEM_WB_store && WB_inst_j_link    && MEM_WB_rt == WB_rt ? 1 :
             MEM_WB_store && WB_mf             && MEM_WB_rt == WB_rt ? 1 :
                                                                       0 ;
assign RTEIR = EXE_MEM_cal_r || EXE_MEM_mt || EXE_MEM_store;                                                   
assign RTE = RTEIR && MEM_WB_cal_r             && EXE_MEM_rt == MEM_WB_rd ? 1 :
             RTEIR && MEM_WB_mt                && EXE_MEM_rt == MEM_WB_rd ? 1 :
             RTEIR && MEM_WB_cal_i             && EXE_MEM_rt == MEM_WB_rt ? 1 :
             RTEIR && MEM_WB_lui               && EXE_MEM_rt == MEM_WB_rt ? 1 :
             RTEIR && MEM_WB_mf                && EXE_MEM_rt == MEM_WB_rd ? 1 :
             RTEIR && MEM_WB_inst_j_link       && EXE_MEM_rt == MEM_WB_rd ? 2 :
             RTEIR && WB_load                  && EXE_MEM_rt == MEM_WB_rt ? 3 :
             RTEIR && WB_cal_r                 && EXE_MEM_rt == MEM_WB_rd ? 3 :
             RTEIR && WB_cal_i                 && EXE_MEM_rt == MEM_WB_rt ? 3 :
             RTEIR && WB_lui                   && EXE_MEM_rt == MEM_WB_rt ? 3 :
             RTEIR && WB_inst_j_link           && EXE_MEM_rt == MEM_WB_rd ? 3 :
             RTEIR && WB_mf                    && EXE_MEM_rt == MEM_WB_rd ? 3 :
                                                                            0 ;

assign RSEIR = EXE_MEM_load || EXE_MEM_store || EXE_MEM_cal_r || EXE_MEM_mt || EXE_MEM_cal_i;
assign RSE = RSEIR && MEM_WB_cal_r               && EXE_MEM_rs == MEM_WB_rd ? 1 :
             RSEIR && MEM_WB_mt                  && EXE_MEM_rs == MEM_WB_rd ? 1 :
             RSEIR && MEM_WB_cal_i               && EXE_MEM_rs == MEM_WB_rt ? 1 :
             RSEIR && MEM_WB_lui                 && EXE_MEM_rs == MEM_WB_rt ? 1 :
             RSEIR && MEM_WB_mf                  && EXE_MEM_rs == MEM_WB_rd ? 1 :
             RSEIR && MEM_WB_inst_j_link         && EXE_MEM_rs == MEM_WB_rd ? 2 :
             RSEIR && WB_load                    && EXE_MEM_rs == WB_rt     ? 3 :
             RSEIR && WB_cal_r                   && EXE_MEM_rs == WB_rd     ? 3 :
             RSEIR && WB_cal_i                   && EXE_MEM_rs == WB_rt     ? 3 :
             RSEIR && WB_lui                     && EXE_MEM_rs == WB_rt     ? 3 :
             RSEIR && WB_inst_j_link             && EXE_MEM_rs == WB_rd     ? 3 :
             RSEIR && WB_mf                      && EXE_MEM_rs == WB_rd     ? 3 :
                                                                              0 ;

assign RTD = ID_b_type && EXE_MEM_inst_j_link     && ID_EXE_rt == EXE_MEM_rd ? 1 :
             ID_b_type && MEM_WB_cal_r            && ID_EXE_rt == MEM_WB_rd ?  2 :
             ID_b_type && MEM_WB_mt               && ID_EXE_rt == MEM_WB_rd ?  2 :
             ID_b_type && MEM_WB_cal_i            && ID_EXE_rt == MEM_WB_rt?   2 :
             ID_b_type && MEM_WB_lui              && ID_EXE_rt == MEM_WB_rt?   2 :
             ID_b_type && MEM_WB_mf               && ID_EXE_rt == MEM_WB_rd ?  2 :
             ID_b_type && MEM_WB_inst_j_link      && ID_EXE_rt == MEM_WB_rd ?  3 :
             ID_b_type && MEM_WB_load             && ID_EXE_rt == WB_rt ?      4 :
             ID_b_type && WB_cal_r                && ID_EXE_rt == WB_rd ?      4 :
             ID_b_type && WB_cal_i                && ID_EXE_rt == WB_rt ?      4 :
             ID_b_type && WB_lui                  && ID_EXE_rt == WB_rt ?      4 :
             ID_b_type && WB_inst_j_link          && ID_EXE_rt == WB_rd ?      4 :
             ID_b_type && WB_mf                   && ID_EXE_rt == WB_rd ?      4 :
                                                                               0 ;

assign RSDIR = ID_b_type || ID_b_zero || ID_EXE_jump;                            
assign RSD = RSDIR && EXE_MEM_inst_j_link          && ID_EXE_rs == EXE_MEM_rd  ? 1 :
             RSDIR && MEM_WB_cal_r                 && ID_EXE_rs == MEM_WB_rd   ? 2 :
             RSDIR && MEM_WB_mt                    && ID_EXE_rs == MEM_WB_rd   ? 2 :
             RSDIR && MEM_WB_cal_i                 && ID_EXE_rs == MEM_WB_rt   ? 2 :
             RSDIR && MEM_WB_lui                   && ID_EXE_rs == MEM_WB_rt   ? 2 :
             RSDIR && MEM_WB_mf                    && ID_EXE_rs == MEM_WB_rd   ? 2 :
             RSDIR && MEM_WB_inst_j_link           && ID_EXE_rs == MEM_WB_rd   ? 3 :
             RSDIR && WB_load                      && ID_EXE_rs == WB_rt       ? 4 :
             RSDIR && WB_cal_r                     && ID_EXE_rs == WB_rd       ? 4 :
             RSDIR && WB_cal_i                     && ID_EXE_rs == WB_rt       ? 4 :
             RSDIR && WB_lui                       && ID_EXE_rs == WB_rt       ? 4 :
             RSDIR && WB_inst_j_link               && ID_EXE_rs == WB_rd       ? 4 :
             RSDIR && WB_mf                        && ID_EXE_rs == WB_rd       ? 4 :
                                                                                 0 ;

wire [31:0] MFRSD_Q;
wire [31:0] MFRTD_Q;
wire [31:0] MFRTM_Q;

MUX8 MFRSD(
        .in_0(ID_EXE_alu_operand1),
        .in_1(EXE_MEM_pc),
        .in_2(EXE_MEM_exe_result),
        .in_3(MEM_WB_pc),
        .in_4(WB_Q),
        .A(RSD),
        .Q(MFRSD_Q)
    );

MUX8 MFRTD(
        .in_0(ID_EXE_alu_operand2),
        .in_1(EXE_MEM_pc),
        .in_2(EXE_MEM_exe_result),
        .in_3(MEM_WB_pc),
        .in_4(WB_Q),
        .A(RTD),
        .Q(MFRTD_Q)
    );

wire Q; 
wire [31:0] RS_E;
wire [31:0] RS_EMUX;
wire [31:0] RT_E;
wire [31:0] RT_M;

//1 for branch 
//0 for no branch

    /**
     * 000(BEQ ) : D1 == D2
     * 001(BNE ) : D1 != D2
     * 010(BLEZ) : D1 <= D2 (D2=0)
     * 011(BGTZ) : D1 >  D2 (D2=0) 
     * 100(BLTZ) : D1 <  D2 (D2=0)    
     * 101(BGEZ) : D1 >= D2 (D2=0)
     */

assign Q = (ID_EXE_beq == 3'b000) ? ( MFRSD_Q == MFRTD_Q) :
           (ID_EXE_beq == 3'b001) ? ( MFRSD_Q != MFRTD_Q) :
           (ID_EXE_beq == 3'b010) ? ( $signed(MFRSD_Q) <= 0  ) :
           (ID_EXE_beq == 3'b011) ? ( $signed(MFRSD_Q) >  0  ) :
           (ID_EXE_beq == 3'b100) ? ( $signed(MFRSD_Q) <  0  ) :
           (ID_EXE_beq == 3'b101) ? ( $signed(MFRSD_Q) >= 0  ) :
           (ID_EXE_beq == 3'b110) ? ( $signed(MFRSD_Q) <  0  ) :
           (ID_EXE_beq == 3'b111) ? ( $signed(MFRSD_Q) >= 0  ) ;
assign RS_EMUX = (sa == 5'b0) ? MFRSD_Q : {{27{1'b0}},sa};



wire [31:0] outA;
wire [31:0] outB;

MUX4 MFRSE(
        .in_0(RS_E),
        .in_1(EXE_MEM_exe_result),
        .in_2(MEM_WB_pc),
        .in_3(WB_Q),
        .A(RSE),
        .Q(outA)
    );

MUX4 MFRTE(
        .in_0(RT_E),
        .in_1(EXE_MEM_exe_result),
        .in_2(MEM_WB_pc),
        .in_3(WB_Q),
        .A(RTE),
        .Q(outB)
    );

wire ID_EX_Rst;
assign  ID_EX_Rst = rst || stall;

PLR #(270) ID_EX(
    .Clk(clk),
    .Rst(ID_EX_Rst),
    .We(1),
    .d({
        ID_EXE_bus_r[206:155],
        outA,
        outB,
        ID_EXE_bus_r[90:0],
        RS_EMUX,
        MFRTD_Q,
    }),
    .q({
        ID_EXE_bus_out,
        RS_E,
        RT_E,
    })
);

PLR #(211) EX_MEM(
        .Clk(clk),
        .Rst(rst),
        .We(1),
        .d({
            EXE_MEM_bus_r[179:150],
            MFRTM_Q,
            EXE_MEM_bus_r[117:0],
            MFRTE_Q
        }),
        .q({
            EXE_MEM_bus_out[179:150],
            EXE_MEM_bus_out[149:118],
            EXE_MEM_bus_out[117:0],
            RT_M
        })
    );

PLR #(141) MEM_WB(
        .Clk(clk),
        .Rst(rst),
        .We(1),
        .d(MEM_WB_bus_r),
        .q( MEM_WB_bus_out),
    );

MUX MFRTM(
        .in_0(RT_M),
        .in_1(WD_Q),
        .A(RTM),
        .Q(MFRTM_Q)
    );
