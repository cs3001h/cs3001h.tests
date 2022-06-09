module cpu (
    input           clk,
    input           rst,

    output          imem_en,
    output          imem_wen,
    output  [31:0]  imem_addr,
    output  [31:0]  imem_wdata,
    input   [31:0]  imem_rdata,

    output          dmem_en,
    output          dmem_wen,
    output  [31:0]  dmem_addr,
    output  [31:0]  dmem_wdata,
    input   [31:0]  dmem_rdata
);

    wire    [31:0]  pc;
    wire    [31:0]  inst;
    wire            branch_en;
    wire    [31:0]  branch_addr;
    wire    [31:0]  imm;
    wire            mem_read;
    wire            mem_write;
    wire            mem2reg;
    wire    [ 3:0]  aluop;
    wire    [ 1:0]  alu_src_a;
    wire    [ 1:0]  alu_src_b;
    wire    [31:0]  rf_qa;
    wire    [31:0]  rf_qb;
    wire    [31:0]  rf_di;
    wire    [31:0]  alu_do;
    wire    [31:0]  mem_do;

    PC u_PC (clk, rst, 32'h00001000, branch_en, branch_addr, pc);

    IF u_IF (pc, inst, imem_en, imem_wen, imem_addr, imem_wdata, imem_rdata);

    ID u_ID (clk, rst, pc, inst, imm, branch_en, branch_addr, mem_read, mem_write, mem2reg, aluop, alu_src_a, alu_src_b, rf_qa, rf_qb, rf_di);

    EX u_EX (pc, imm, rf_qa, rf_qb, aluop, alu_src_a, alu_src_b, alu_do);

    MA u_MA (alu_do, mem_read, mem_do, mem_write, rf_qb, dmem_en, dmem_wen, dmem_addr, dmem_wdata, dmem_rdata);

    WB u_WB (alu_do, mem_do, mem2reg, rf_di);

endmodule

module regfile (
    input           clk,
    input           rst,
    input   [ 4:0]  ra,
    input   [ 4:0]  rb,
    input           we,
    input   [ 4:0]  rd,
    input   [31:0]  di,
    output  [31:0]  qa,
    output  [31:0]  qb
);

    reg [31:0] rf [0:31];

    assign qa = ra == 0 ? 'h0 : rf[ra];
    assign qb = rb == 0 ? 'h0 : rf[rb];

    always @(posedge clk) begin
        if (!rst && we && rd != 0)
            rf[rd] <= di;
    end

endmodule

module PC (
    input           clk,
    input           rst_en,
    input   [31:0]  rst_addr,
    input           branch_en,
    input   [31:0]  branch_addr,
    output  [31:0]  pc
);

    reg [31:0] pcr;

    always @(posedge clk) begin
        if (rst_en)
            pcr <= rst_addr;
        else if (branch_en)
            pcr <= branch_addr;
        else
            pcr <= pcr + 'h4;
    end

    assign pc = pcr;

endmodule

module IF (
    input   [31:0]  pc,
    output  [31:0]  inst,

    output          imem_en,
    output          imem_wen,
    output  [31:0]  imem_addr,
    output  [31:0]  imem_wdata,
    input   [31:0]  imem_rdata
);

    assign  imem_en     = 1;
    assign  imem_wen    = 0;
    assign  imem_addr   = pc;
    assign  imem_wdata  = 'h0;

    assign  inst = { imem_rdata[7:0], imem_rdata[15:8], imem_rdata[23:16], imem_rdata[31:24] };

endmodule

module ID (
    input           clk,
    input           rst,

    input   [31:0]  pc,
    input   [31:0]  inst,

    output  [31:0]  imm,
    output          branch_en,
    output  [31:0]  branch_addr,
    output          mem_read,
    output          mem_write,
    output          mem2reg,
    output  [ 3:0]  aluop,
    output  [ 1:0]  alu_src_a,
    output  [ 1:0]  alu_src_b,

    output  [31:0]  rf_qa,
    output  [31:0]  rf_qb,
    input   [31:0]  rf_di
);

    wire [6:0] opcode = inst[6:0];
    wire [2:0] funct3 = inst[14:12];
    wire [6:0] funct7 = inst[31:25];

    wire lui    = opcode == 7'b0110111;
    wire auipc  = opcode == 7'b0010111;
    wire jal    = opcode == 7'b1101111;
    wire jalr   = opcode == 7'b1100111;
    wire beq    = opcode == 7'b1100011 && funct3 == 3'b000;
    wire bne    = opcode == 7'b1100011 && funct3 == 3'b001;
    wire blt    = opcode == 7'b1100011 && funct3 == 3'b100;
    wire bge    = opcode == 7'b1100011 && funct3 == 3'b101;
    wire bltu   = opcode == 7'b1100011 && funct3 == 3'b110;
    wire bgeu   = opcode == 7'b1100011 && funct3 == 3'b111;
    wire lw     = opcode == 7'b0000011 && funct3 == 3'b010;
    wire sw     = opcode == 7'b0100011 && funct3 == 3'b010;
    wire i_type = opcode == 7'b0010011;
    wire r_type = opcode == 7'b0110011;

    wire       rf_we = lui | auipc | jal | jalr | lw | i_type | r_type;
    wire [4:0] rf_ra = inst[19:15];
    wire [4:0] rf_rb = inst[24:20];
    wire [4:0] rf_rd = inst[11:7];

    regfile u_regfile (clk, rst, rf_ra, rf_rb, rf_we, rf_rd, rf_di, rf_qa, rf_qb);

    assign imm          =   lui | auipc                            ? { inst[31:12], 12'b0 }                                             :
                            jal                                    ? { {12{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21] }   :
                            jalr | lw | i_type                     ? { {20{inst[31]}}, inst[31:20] }                                    :
                            beq | bne | blt | bge | bltu | bgeu    ? { {20{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8] }     :
                            sw                                     ? { {20{inst[31]}}, inst[31:25], inst[11:7] }                        :
                            'h0;

    assign branch_en    =   jal | jalr |
                            (beq && rf_qa == rf_qb) |
                            (bne && rf_qa != rf_qb) |
                            (blt && $signed(rf_qa) <  $signed(rf_qb)) |
                            (bge && $signed(rf_qa) >= $signed(rf_qb)) |
                            (bltu && $unsigned(rf_qa) <  $unsigned(rf_qb)) |
                            (bgeu && $unsigned(rf_qa) >= $unsigned(rf_qb)) ;
    assign branch_addr  =   jal | beq | bne | blt | bge | bltu | bgeu   ? pc + (imm << 1)               :
                            jalr                                        ? (rf_qa + imm) & 32'hfffffffe  :
                            'h0;

    assign mem_read     =   lw;
    assign mem_write    =   sw;
    assign mem2reg      =   mem_read;

    assign aluop        =   lui | auipc | jal | jalr | lw | sw  ? 4'b0000                                   :
                            i_type                              ? { funct3 == 3'b101 & funct7[5] , funct3 } :
                            r_type                              ? { funct7[5], funct3 }                     :
                            4'b1111;
    assign alu_src_a    =   lw | sw | i_type | r_type        ? 2'b00 :   // qa
                            lui                              ? 2'b10 :   // 0
                            auipc | jal | jalr               ? 2'b01 :   // pc
                            2'b11;
    assign alu_src_b    =   r_type                           ? 2'b00 :   // qb
                            lui | auipc | lw | sw | i_type   ? 2'b01 :   // imm
                            jal | jalr                       ? 2'b10 :   // 4
                            2'b11;

endmodule

module EX (
    input   [31:0]  pc,
    input   [31:0]  imm,
    input   [31:0]  rf_qa,
    input   [31:0]  rf_qb,

    input   [ 3:0]  aluop,
    input   [ 1:0]  alu_src_a,
    input   [ 1:0]  alu_src_b,

    output  [31:0]  alu_do
);

    reg [31:0] at;
    reg [31:0] bt;
    reg [31:0] rt;

    always @(alu_src_a, pc, rf_qa) begin
        case (alu_src_a)
            2'b00: at = rf_qa; 
            2'b01: at = pc; 
            2'b10: at = 'h0; 
            default: at = 'h0;
        endcase
    end

    always @(alu_src_b, imm, rf_qb) begin
        case (alu_src_b)
            2'b00: bt = rf_qb;
            2'b01: bt = imm;
            2'b10: bt = 'h4; 
            default: bt = 'h0;
        endcase
    end

    always @(aluop, at, bt) begin
        case (aluop)
            4'b0000: rt = at + bt;
            4'b1000: rt = at - bt;
            4'b0001: rt = at << bt;
            4'b0010: rt = $signed(at) < $signed(bt) ? 'h1 : 'h0;
            4'b0011: rt = $unsigned(at) < $unsigned(bt) ? 'h1 : 'h0;
            4'b0100: rt = at ^ bt;
            4'b0101: rt = at >> bt;
            4'b1101: rt = $signed(at) >>> bt;
            4'b0110: rt = at | bt;
            4'b0111: rt = at & bt;
            default: rt = 'h0;
        endcase
    end

    assign alu_do = rt;

endmodule

module MA (
    input   [31:0]  alu_do,
    input           mem_read,
    output  [31:0]  mem_do,
    input           mem_write,
    input   [31:0]  rf_qb,

    output          dmem_en,
    output          dmem_wen,
    output  [31:0]  dmem_addr,
    output  [31:0]  dmem_wdata,
    input   [31:0]  dmem_rdata
);

    assign  dmem_en     = mem_read | mem_write;
    assign  dmem_wen    = mem_write;
    assign  dmem_addr   = dmem_en ? alu_do : 'h0;
    assign  dmem_wdata  = dmem_wen ? { rf_qb[7:0], rf_qb[15:8], rf_qb[23:16], rf_qb[31:24] } : 'h0;

    assign  mem_do = { dmem_rdata[7:0], dmem_rdata[15:8], dmem_rdata[23:16], dmem_rdata[31:24] };

endmodule

module WB (
    input   [31:0]  alu_do,
    input   [31:0]  mem_do,
    input           mem2reg,
    output  [31:0]  rf_di
);

    assign rf_di = mem2reg ? mem_do : alu_do;

endmodule